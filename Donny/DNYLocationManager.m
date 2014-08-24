//
//  DNYLocationManager.m
//  Donny
//
//  Created by Alex Belliotti on 8/24/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYLocationManager.h"

@implementation DNYLocationManager

+ (instancetype)instance {
    static DNYLocationManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DNYLocationManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestAlwaysAuthorization];
    }
    
    return self;
}

#pragma mark - DNYLocationManager

- (void)registerDelegate:(id<DNYBeaconDelegate>)delegate forBeaconWithUUID:(NSUUID *)uuid {
    
}

@end
