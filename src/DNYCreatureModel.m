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

#import "DNYMotionInteraction.h"
#import "DNYFaceInteraction.h"
#import "DNYFoodInteraction.h"

#define kDefaultCreatureLoopRate 30 // 60hz/2, number of frames to pass before next eval
#define kDefaultCreatureTimerSeconds 0.5
#define kNeglectInterval 20 // seconds that define being neglected

NSString *const kUserDefaultKeyHappiness        = @"happiness";

@interface DNYCreatureModel ()

@property (nonatomic, strong) NSDate *lastInteraction;

- (void)makeAwake;
- (void)makeAsleep;
- (void)makeVibrate;
- (void)makeVibrateChuckle;
- (void)makeStopVibrating;
- (void)makeNeglected;

- (void)updateLastInteractionTime;
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
    
    [sm when:@"sleep" transitionFrom:@"sleeping" to:@"sleeping"];
    [sm when:@"sleep" transitionFrom:@"awake" to:@"sleeping"];
    [sm when:@"wake" transitionFrom:@"sleeping" to:@"awake"];
    [sm when:@"suspend" transitionFrom:@"awake" to:@"suspended"];
    [sm when:@"unsuspend" transitionFrom:@"suspended" to:@"awake"];
    [sm when:@"terminate" transitionFrom:@"awake" to:@"terminated"];
    [sm when:@"terminate" transitionFrom:@"sleeping" to:@"terminated"];
    
    [sm when:@"vibrate" transitionFrom:@"awake" to:@"vibrating"];
    [sm when:@"vibrateChuckle" transitionFrom:@"awake" to:@"vibrating"];
    [sm when:@"makeStopVibrating" transitionFrom:@"vibrating" to:@"awake"];
    
    [sm after:@"sleep" do:^(DNYCreatureModel *creature) {
        [creature makeAsleep];
    }];
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
        [self setupInteractions];
    }
    return self;
}

- (void)setupInteractions
{
    self.interactions = [NSArray arrayWithObjects:
      [[DNYFaceInteraction alloc] initWithCreature:self],
      [[DNYMotionInteraction alloc] initWithCreature:self],
      [[DNYFoodInteraction alloc] initWithCreature:self],
      nil];
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Core capabilities

- (void)makeAwake {
    NSLog(@"Model::makeAwake");
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:kDefaultCreatureTimerSeconds target:self selector:@selector(evaluate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
//    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(evaluate)];
//    displayLink.frameInterval = kDefaultCreatureLoopRate;
//    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.creatureNode wakeup];
    });
    [self updateLastInteractionTime];
}

- (void)makeAsleep {
    NSLog(@"Model::makeAsleep");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.creatureNode sleep];
    });
    [self updateLastInteractionTime];
}

- (void)makeVibrate {
     AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    [self updateLastInteractionTime];
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
    [self updateLastInteractionTime];
}

- (void)makeStopVibrating {
    AudioServicesStopSystemSound();
    [self updateLastInteractionTime];
}

- (void)makeNeglected {
    NSLog(@"Model::makeNeglected I AM BEING NEGLECTED WAAAAA");
    [self updateLastInteractionTime];
}

- (void)updateLastInteractionTime {
    self.lastInteraction = [NSDate date];
}

- (void)increaseHappiness {
    NSNumber *newHappiness = @(self.happiness + 1);
    [[NSUserDefaults standardUserDefaults] setObject:newHappiness forKey:kUserDefaultKeyHappiness];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)decreaseHappiness {
    NSNumber *newHappiness = @(self.happiness - 1);
    [[NSUserDefaults standardUserDefaults] setObject:newHappiness forKey:kUserDefaultKeyHappiness];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)happiness {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyHappiness] integerValue];
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Creature runloop

- (void)evaluate {
    NSLog(@">>> Evaluating Donny's State <<<");
    NSTimeInterval lastSeen = [[NSDate date] timeIntervalSinceDate:self.lastInteraction];
    
    if (lastSeen >= kNeglectInterval) {
        NSLog(@"Time interval %f", lastSeen);
        [self makeNeglected];
    }
}


@end
