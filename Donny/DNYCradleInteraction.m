//
//  DNYCradleInteraction.m
//  Donny
//
//  Created by Ben Cullen-Kerney on 8/24/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYCradleInteraction.h"
#import "DNYCreatureModel.h"

@interface DNYCreatureModel (DNYCradleInteractionBehavior)

-(void) dny_CradleInteractionSet;
-(void) dny_CradleInteractionUnset;

@end

@implementation DNYCreatureModel (DNYCradleInteractionBehavior)

-(void) dny_CradleInteractionSet
{
    NSLog(@"I'm in the cradle");
}

-(void) dny_CradleInteractionUnset
{
    NSLog(@"I'm free!");
}

@end

@implementation DNYCradleInteraction

- (instancetype)initWithCreature:(DNYCreatureModel *)creature {
    self = [super initWithCreature:creature];
    if (self) {
        DNYLocationManager *locationManager = [DNYLocationManager instance];
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"CC1F30CD-97DA-4CC4-AD8F-CB808D23D722"];
        [locationManager registerDelegate:self forBeaconWithUUID:uuid];
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacon:(CLBeacon*)beacon
{
    if (beacon.proximity == CLProximityImmediate) {
        [self.creature dny_CradleInteractionSet];
    } else {
        [self.creature dny_CradleInteractionUnset];
    }
}

@end
