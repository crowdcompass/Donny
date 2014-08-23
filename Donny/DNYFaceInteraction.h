//
//  DNYFaceInteraction.h
//  Donny
//
//  Created by Corlett, Robert on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYInteraction.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DNYFaceInteraction : DNYInteraction <UIGestureRecognizerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@end
