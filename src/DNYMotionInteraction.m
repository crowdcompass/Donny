//
//  DNYMotionInteraction.m
//  Donny
//
//  Created by Corlett, Robert on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYMotionInteraction.h"
#import <CoreMotion/CoreMotion.h>

#define LOG_DEVICE_ROTATION 0

@interface DNYMotionInteraction()

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) NSUInteger rockCounter;

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

- (void)outputDeviceMotionData:(CMDeviceMotion *)motion {
#if LOG_DEVICE_ROTATION
    NSLog(@"Rotation rate x: %.2f", motion.rotationRate.x);
    NSLog(@"Rotation rate y: %.2f", motion.rotationRate.y);
    NSLog(@"Rotation rate z: %.2f", motion.rotationRate.z);
#endif

    //gravity z close to -1.0 means device laying flat
    if (-0.8 > motion.gravity.z && motion.gravity.z > -1.2) {
        //acceleration x between 0.2 and 0.5 is gentle rocking, greater than 1.0 == too rough
        if (0.2 < motion.userAcceleration.x && motion.userAcceleration.x < 0.5) {
            self.rockCounter++;
        } else if (motion.userAcceleration.x > 1.0) {
            //reset rock counter and 'hurt' creature
            self.rockCounter = 0;
            //'hurt' creature health
            NSLog(@"OUCH! ROCKING TOO HARD!?");
        }
    }

    if (self.rockCounter > 10) {
        NSLog(@"HAPPY CREATURE!");
        self.rockCounter = 0;
    }
}



@end
