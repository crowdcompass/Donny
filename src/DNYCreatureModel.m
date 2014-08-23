//
//  DNYCreatureModel.m
//  Donny
//
//  Created by Alex Belliotti on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYCreatureModel.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

#define kDefaultCreatureLoopRate 30 // 60hz/2, number of frames to pass before next eval

@interface DNYCreatureModel ()

- (void)evaluate;

@end

@implementation DNYCreatureModel

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Core capabilities

- (void)makeAlive {
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(evaluate)];
    displayLink.frameInterval = kDefaultCreatureLoopRate;
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)vibrate {
     AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

/**
 This uses a private API method, so would need to be compiled out of a sumbitted app
 */
- (void)vibrateChuckle {
    NSMutableDictionary* patternsDict = [@{} mutableCopy];
    NSMutableArray* patternsArray = [@[] mutableCopy];
    
    [patternsArray addObjectsFromArray:@[@(YES), @(1000),
                                        @(NO),@(500),
                                         @(YES), @(250),
                                         @(NO), @(250),
                                         @(YES), @(250),
                                         @(NO), @(250),
                                         @(YES), @(250)]];
        
    [patternsDict setObject:patternsArray forKey:@"VibePattern"];
    [patternsDict setObject:[NSNumber numberWithInt:1.0] forKey:@"Intensity"];
    
    // suppress warnings
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wall"
    AudioServicesStopSystemSound(kSystemSoundID_Vibrate);
    
    AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate,nil,patternsDict);
#pragma clang diagnostic pop
}


//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Creature runloop

- (void)evaluate {
    NSLog(@">>> Evaluating Donny's State <<<");
}


@end
