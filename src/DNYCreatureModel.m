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

- (void)makeAwake;
- (void)makeAsleep;
- (void)makeVibrate;
- (void)makeVibrateChuckle;
- (void)makeStopVibrating;

- (void)evaluate;

@end


@implementation DNYCreatureModel

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark State Machine


STATE_MACHINE(^(LSStateMachine * sm) {
    sm.initialState = @"sleeping";
    
    [sm addState:@"sleeping"];
    [sm addState:@"awake"];
    [sm addState:@"suspended"];
    [sm addState:@"terminated"];
    [sm addState:@"vibrating"];
    
    
    [sm when:@"wake" transitionFrom:@"sleeping" to:@"awake"];
    [sm when:@"suspend" transitionFrom:@"awake" to:@"suspended"];
    [sm when:@"unsuspend" transitionFrom:@"suspended" to:@"awake"];
    [sm when:@"terminate" transitionFrom:@"awake" to:@"terminated"];
    [sm when:@"terminate" transitionFrom:@"sleeping" to:@"terminated"];
    
    [sm when:@"vibrate" transitionFrom:@"awake" to:@"vibrating"];
    [sm when:@"vibrateChuckle" transitionFrom:@"awake" to:@"vibrating"];
    [sm when:@"makeStopVibrating" transitionFrom:@"vibrating" to:@"awake"];
    
    [sm after:@"wake" do:^(DNYCreatureModel *creature) {
        [creature makeAwake];
    }];
    [sm after:@"vibrate" do:^(DNYCreatureModel *creature) {
        [creature makeVibrate];
        [creature makeStopVibrating];
    }];
    [sm after:@"vibrateChuckle" do:^(DNYCreatureModel *creature) {
        [creature makeVibrateChuckle];
        [creature makeStopVibrating];
    }];
    
})

- (id)init {
    self = [super init];
    if (self) {
        [self initializeStateMachine];
    }
    return self;
}


//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Core capabilities

- (void)makeAwake {
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(evaluate)];
    displayLink.frameInterval = kDefaultCreatureLoopRate;
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)makeAsleep {
    
}

- (void)makeVibrate {
     AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

/**
 This uses a private API method, so would need to be compiled out of a sumbitted app
 */
- (void)makeVibrateChuckle {
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

- (void)makeStopVibrating {
    AudioServicesStopSystemSound();
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Creature runloop

- (void)evaluate {
    NSLog(@">>> Evaluating Donny's State <<<");
}


@end
