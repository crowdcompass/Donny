//
//  DNYFaceInteraction.m
//  Donny
//
//  Created by Corlett, Robert on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYFaceInteraction.h"
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <AssertMacros.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSIndexPath+CGPoint.h"

#define kSmileInterval 3

@interface DNYCreatureModel (DNYFaceInteractionBehavior)

-(void) dny_FaceInteractionToggleLeftEyeWink;
-(void) dny_FaceInteractionToggleRightEyeWink;
-(void) dny_FaceInteractionEvaluateBlink;
-(void) dny_FaceInteractionSetSmile;
-(void) dny_FaceInteractionTrackFacePosition:(CGPoint)coord;

@end

@implementation DNYCreatureModel (DNYFaceInteractionBehavior)


-(void)dny_FaceInteractionToggleLeftEyeWink
{
    if (!self.isAwake) return;
    
    NSLog(@"Left eye closed");
    if (!self.leftEyeClosed) {
        [self.creatureNode leftEyeWink];
    }
    self.leftEyeClosed = !self.leftEyeClosed;
    
    [self dny_FaceInteractionEvaluateBlink];
}

-(void)dny_FaceInteractionToggleRightEyeWink
{
    if (!self.isAwake) return;
    
    NSLog(@"Right eye closed");
    if (!self.rightEyeClosed) {
        [self.creatureNode rightEyeWink];        
    }
    self.rightEyeClosed = !self.rightEyeClosed;

    [self dny_FaceInteractionEvaluateBlink];
}

-(void) dny_FaceInteractionEvaluateBlink {
    if (!self.isAwake) return;
    
    if (self.leftEyeClosed && self.rightEyeClosed) {
        [self.creatureNode blink:2];
        self.leftEyeClosed = NO;
        self.rightEyeClosed = NO;
    }
}

-(void) dny_FaceInteractionSetSmile
{
    NSLog(@"Smile");
    if (!self.isSleeping) {
        [self vibrateChuckle];
        [self increaseHappinessWithReaction:YES withSickness:NO];
    }
}

-(void) dny_FaceInteractionTrackFacePosition:(CGPoint)coord
{
    NSIndexPath *path = [NSIndexPath fromPoint:coord];
//    NSLog(@"!!!!COORD---  (%f, %f)", coord.x, coord.y);
//    NSLog(@"Looking at %@", path);
    [self.creatureNode lookAt:path];
}

@end

@interface DNYFaceInteraction() 

@property (nonatomic, assign) BOOL leftEyeClosed;
@property (nonatomic, assign) BOOL rightEyeClosed;

@property (nonatomic) BOOL isUsingFrontFacingCamera;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic) dispatch_queue_t videoDataOutputQueue;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIImage *borderImage;
@property (nonatomic, strong) CIDetector *faceDetector;

-(CGPoint) pointForCreatureFromPoint:(CGPoint)point;

@end

@implementation DNYFaceInteraction

- (instancetype)initWithCreature:(DNYCreatureModel *)creature {
    self = [super initWithCreature:creature];
    if (self) {
        self.leftEyeClosed = NO;
        self.rightEyeClosed = NO;
        [self setupAVCapture];
        NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
        _faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    }
    return self;
}

- (void)setupAVCapture
{
    NSError *error = nil;

    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        [session setSessionPreset:AVCaptureSessionPresetLow];
    } else {
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    }

    // Select a video device, make an input
    AVCaptureDevice *device;

    AVCaptureDevicePosition desiredPosition = AVCaptureDevicePositionFront;

    // find the front facing camera
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            device = d;
            self.isUsingFrontFacingCamera = YES;
            break;
        }
    }
    // fall back to the default camera.
    if( nil == device )
    {
        self.isUsingFrontFacingCamera = NO;
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }

    // get the input device
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];

    if( !error ) {

        // add the input to the session
        if ( [session canAddInput:deviceInput] ){
            [session addInput:deviceInput];
        }

        // Make a video data output
        self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];

        // we want BGRA, both CoreGraphics and OpenGL work well with 'BGRA'
        NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                           [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        [self.videoDataOutput setVideoSettings:rgbOutputSettings];
        [self.videoDataOutput setAlwaysDiscardsLateVideoFrames:YES]; // discard if the data output queue is blocked

        // create a serial dispatch queue used for the sample buffer delegate
        // a serial dispatch queue must be used to guarantee that video frames will be delivered in order
        // see the header doc for setSampleBufferDelegate:queue: for more information
        self.videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
        [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];

        if ( [session canAddOutput:self.videoDataOutput] ){
            [session addOutput:self.videoDataOutput];
        }

        // get the output for doing face detection.
        [[self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];

        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
//        self.previewLayer.frame = self.creature.controller.view.frame;
//        [self.creature.controller.view.layer addSublayer:self.previewLayer];
        [session startRunning];
        
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    // get the image
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer
                                                      options:(__bridge NSDictionary *)attachments];
    if (attachments) {
        CFRelease(attachments);
    }

    // make sure your device orientation is not locked.
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];

    NSDictionary *imageOptions = nil;

    imageOptions = @{CIDetectorImageOrientation:[self exifOrientation:curDeviceOrientation], CIDetectorEyeBlink: @(YES), CIDetectorSmile: @(YES)};

    NSArray *features = [self.faceDetector featuresInImage:ciImage
                                                   options:imageOptions];
    

    for (CIFaceFeature *ff in features) {
//        NSLog(@"-----MouthPosition-----:(%f, %f)", ff.mouthPosition.x, ff.mouthPosition.y);
//        if ( ff.hasLeftEyePosition && ff.leftEyeClosed ) {
//            self.leftEyeClosed = YES;
//        }
//        if ( ff.hasRightEyePosition && ff.rightEyeClosed ) {
//            self.rightEyeClosed = YES;
//        }
        if ( ff.hasSmile ) {
            if (!self.creature.lastSmiledAt || [[self.creature.lastSmiledAt dateByAddingTimeInterval:kSmileInterval] compare:[NSDate date]] == NSOrderedAscending) {
                [self.creature dny_FaceInteractionSetSmile];
                self.creature.lastSmiledAt = [NSDate date];
            }
        }
        if ( ff.hasMouthPosition ) {
            [self.creature dny_FaceInteractionTrackFacePosition:[self pointForCreatureFromPoint:ff.mouthPosition]];
        } else {
            self.leftEyeClosed = NO;
            self.rightEyeClosed = NO;
        }
    }
}

- (NSNumber *) exifOrientation: (UIDeviceOrientation) orientation
{
    int exifOrientation;
    /* kCGImagePropertyOrientation values
     The intended display orientation of the image. If present, this key is a CFNumber value with the same value as defined
     by the TIFF and EXIF specifications -- see enumeration of integer constants.
     The value specified where the origin (0,0) of the image is located. If not present, a value of 1 is assumed.

     used when calling featuresInImage: options: The value for this key is an integer NSNumber from 1..8 as found in kCGImagePropertyOrientation.
     If present, the detection will be done based on that orientation but the coordinates in the returned features will still be based on those of the image. */

    enum {
        PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
        PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
        PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
        PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
        PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
        PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
    };

    switch (orientation) {
        case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
            break;
        case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
            if (self.isUsingFrontFacingCamera)
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            else
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
            break;
        case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            if (self.isUsingFrontFacingCamera)
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
            else
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            break;
        case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
        default:
            exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
            break;
    }
    return [NSNumber numberWithInt:exifOrientation];
}

-(CGPoint) pointForCreatureFromPoint:(CGPoint)point
{
    static CGSize screenSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        screenSize = [[UIScreen mainScreen] bounds].size;
    });
    
    CGAffineTransform coordinatesTransform = CGAffineTransformMakeRotation(M_PI/2);
    coordinatesTransform = CGAffineTransformTranslate(coordinatesTransform, 1.f, -screenSize.width);
    
    CGPoint normalizedPoint = normalizeTransformedPoint(point);
    CGPoint scaledPoint = {screenSize.width * normalizedPoint.x, screenSize.height * normalizedPoint.y};
    CGPoint transformedPoint = CGPointApplyAffineTransform(scaledPoint, coordinatesTransform);
    return transformedPoint;
}

//normalize for these observed ranges
//x (50-150)
//y (30-110)
CGPoint normalizeTransformedPoint(CGPoint point) {
    CGFloat x = (point.x - 50.f) / 100.f;
    CGFloat y = (point.y - 30.f) / 80.f;
    
//    NSLog(@"Normalized: (%f, %f)", x, y);
    
    return CGPointMake(x, y);
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Loop

- (void)evaluate {
    if (!self.creature.isAwake) return;
    
    if (self.leftEyeClosed) {
        [self.creature dny_FaceInteractionToggleLeftEyeWink];
    }
    if (self.rightEyeClosed) {
        [self.creature dny_FaceInteractionToggleRightEyeWink];
    }
}


@end
