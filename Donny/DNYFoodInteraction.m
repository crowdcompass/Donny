//
//  DNYFoodInteraction.m
//  Donny
//
//  Created by Ben Cullen-Kerney on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYFoodInteraction.h"
#import "DNYCreatureModel.h"

#define kFedInterval 30 // wait to feed again

@interface DNYCreatureModel (DNYFoodInteractionBehavior)

-(void) dny_FoodInteractionSmellFood;
-(void) dny_FoodInteractionReceiveFood;

@end

@implementation DNYCreatureModel (DNYFoodInteractionBehavior)

-(void) dny_FoodInteractionSmellFood;
{
    NSLog(@"THAT SMELLS GREAT IS THAT CHICKEN");
}

-(void) dny_FoodInteractionReceiveFood
{
    NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:self.lastFedAt];
    if (diff >= kFedInterval) {
        NSLog(@"YUM CHICKEN");
        [self increaseHappinessWithReaction:YES withSickness:NO];
        self.lastFedAt = [NSDate date];
        [self playAifSoundWithName:@"tasty"];
    } else {
        NSLog(@"NO THANKS I'M FULL");
    }
}

@end

@implementation DNYFoodInteraction

- (instancetype)initWithCreature:(DNYCreatureModel *)creature {
    self = [super initWithCreature:creature];
    if (self) {
        self.creature.lastFedAt = [NSDate dateWithTimeIntervalSinceNow:-300];
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"250511CC-0000-0000-1100-000000000001"];
        _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.crowdcompass.Donny"];
        _beaconRegion.notifyEntryStateOnDisplay = YES;
        _beaconRegion.notifyOnEntry = YES;
        _beaconRegion.notifyOnExit = YES;
        [_locationManager startRangingBeaconsInRegion:_beaconRegion];
        NSLog(@"started ranging for region: %@ uuid: %@", _beaconRegion, uuid);
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion*)region
{
    CLBeacon *beacon = beacons.firstObject;
    if (beacon.proximity == CLProximityImmediate) {
        [self.creature dny_FoodInteractionReceiveFood];
    } else if (beacon.proximity == CLProximityNear) {
        [self.creature dny_FoodInteractionSmellFood];
    }
}

@end
