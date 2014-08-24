//
//  DNYProximitySensorInteraction.m
//  Donny
//
//  Created by Alex Belliotti on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYProximitySensorInteraction.h"

#import "DNYCreatureModel.h"

@implementation DNYProximitySensorInteraction

- (instancetype)initWithCreature:(DNYCreatureModel *)creature {
    self = [super initWithCreature:creature];
    
    if (self) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    }
    
    return self;
}

- (void)dealloc {
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

- (void)evaluate {
    if ([[UIDevice currentDevice] proximityState]) {
        [self.creature sleep];
    }
}

@end
