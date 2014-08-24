//
//  DNYMotionInteraction.m
//  Donny
//
//  Created by Corlett, Robert on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYMotionInteraction.h"
#import <CoreMotion/CoreMotion.h>

@interface DNYMotionInteraction()

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) NSUInteger rockCounter;
@property (nonatomic, assign) NSUInteger sickWaitCounter;
@property (nonatomic, assign) NSUInteger layingCounter;

@end

@implementation DNYMotionInteraction

- (instancetype)initWithCreature:(DNYCreatureModel *)creature {
    self = [super initWithCreature:creature];
    if (self) {
        [self setupMotionManagement];
    }
    return self;
}

- (void)setupMotionManagement {
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 0.2;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        [self outputDeviceMotionData:motion];
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

//Rock while flat == get sleepy
//Lie flat == Go to sleep completely

- (void)outputDeviceMotionData:(CMDeviceMotion *)motion {

    //gravity z close to -1.0 means device laying flat
    if (-0.8 > motion.gravity.z && motion.gravity.z > -1.2) {
        //acceleration x between 0.2 and 0.5 is gentle rocking, greater than 1.0 == too rough
        if (0.2 < motion.userAcceleration.x && motion.userAcceleration.x < 0.5) {
            self.rockCounter++;
        }
    }

    if (self.rockCounter > 6) {
        NSLog(@"Call rocking nicely");
        self.rockCounter = 0;
        if ([self.creature isAwake]) {
            [self.creature sleep];
        }
    }

    if (motion.userAcceleration.x > 1.0 || motion.userAcceleration.y > 1.0 || motion.userAcceleration.z > 1.0) {
        NSLog(@"Call shook hard x: %.2f y:%.2f z:%.2f", motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z);
        self.rockCounter = 0;
        if (self.creature.isSleeping) {
            self.sickWaitCounter = 6;
            [self.creature wake];
        } else {
            if (self.sickWaitCounter > 0) {
                return;
            } else {
                [self.creature decreaseHappinessWithReaction:YES withSickness:YES];
            }
        }
        
    }

    if (-0.99 > motion.gravity.z && motion.gravity.z > -1.01) {
        self.layingCounter++;
        if (self.layingCounter > 30) {
            NSLog(@"Call lying flat for a while");
            self.creature.flat = YES;
            self.layingCounter = 0;
        }
    } else {
        self.layingCounter = 0;
    }
}

- (void)evaluate {
    if (self.sickWaitCounter > 0) self.sickWaitCounter--;
}

@end
