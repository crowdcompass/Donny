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

@interface DNYCreatureModel (DNYFaceInteractionBehavior)

-(void) dny_FaceInteractionSetLeftEyeWink;
-(void) dny_FaceInteractionSetRightEyeWink;
-(void) dny_FaceInteractionSetSmile;
-(void) dny_FaceInteractionTrackFacePosition:(CGPoint)coord;

@end

@implementation DNYCreatureModel (DNYFaceInteractionBehavior)

-(void)dny_FaceInteractionSetLeftEyeWink
{
    NSLog(@"Left eye closed");
}

-(void)dny_FaceInteractionSetRightEyeWink
{
    NSLog(@"Right eye closed");
}

-(void) dny_FaceInteractionSetSmile
{
    NSLog(@"Smile");
    [self vibrateChuckle];
}

-(void) dny_FaceInteractionTrackFacePosition:(CGPoint)coord
{
    NSLog(@"Face position is %@", NSStringFromCGPoint(coord));
}

@end

@interface DNYFaceInteraction() 

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
        if ( ff.hasLeftEyePosition && ff.leftEyeClosed ) {
            [self.creature dny_FaceInteractionSetLeftEyeWink];
        }
        if ( ff.hasRightEyePosition && ff.rightEyeClosed ) {
            [self.creature dny_FaceInteractionSetRightEyeWink];
        }
        if ( ff.hasSmile ) {
            [self.creature dny_FaceInteractionSetSmile];
        }
        if ( ff.hasMouthPosition ) {
            [self.creature dny_FaceInteractionTrackFacePosition:[self pointForCreatureFromPoint:ff.mouthPosition]];
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
    CGAffineTransform coordinatesTransform = CGAffineTransformMakeRotation(M_PI/2);
    coordinatesTransform = CGAffineTransformTranslate(coordinatesTransform, 1.f, -[[UIScreen mainScreen] bounds].size.width);
    
    CGPoint transformedPoint = CGPointApplyAffineTransform(point, coordinatesTransform);
    return transformedPoint;
}

@end
