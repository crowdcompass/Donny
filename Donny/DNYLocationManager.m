//
//  DNYLocationManager.m
//  Donny
//
//  Created by Alex Belliotti on 8/24/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYLocationManager.h"

NSString *const kBaseIdentifier = @"com.crowdcompass.donny";

@interface DNYLocationManagerDelegateContainer : NSObject

@property (weak, nonatomic) id<DNYBeaconDelegate> delegate;

- (instancetype)initWithDelegate:(id<DNYBeaconDelegate>)delegate;

@end

@implementation DNYLocationManagerDelegateContainer

- (instancetype)initWithDelegate:(id<DNYBeaconDelegate>)delegate {
    if (self) {
        _delegate = delegate;
    }
    
    return self;
}

@end

@interface DNYLocationManager()

@property (strong, atomic) NSMutableDictionary *delegates;

@end

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
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        
        _delegates = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark - DNYLocationManager

- (void)registerDelegate:(id<DNYBeaconDelegate>)delegate forBeaconWithUUID:(NSUUID *)uuid identifier:(NSString *)identifier {
    NSParameterAssert(uuid && identifier);
    
    @synchronized (self.delegates) {
        NSMutableSet *existingDelegates = self.delegates[uuid];
        
        NSString *idString = [NSString stringWithFormat:@"%@.%@", kBaseIdentifier, identifier];
        
        CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                          identifier:idString];
        beaconRegion.notifyEntryStateOnDisplay = YES;
        beaconRegion.notifyOnEntry = YES;
        beaconRegion.notifyOnExit = YES;
        
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        
        DNYLocationManagerDelegateContainer *container =
        [[DNYLocationManagerDelegateContainer alloc] initWithDelegate:delegate];
        
        if (existingDelegates) {
            [existingDelegates addObject:container];
        } else {
            self.delegates[uuid] = [NSMutableSet setWithObject:container];
        }
    }
}

#pragma mark - CLLocationDelegate

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    for (CLBeacon *beacon in beacons) {
        NSSet *delegateContainers = self.delegates[beacon.proximityUUID];
        
        for (DNYLocationManagerDelegateContainer *container in delegateContainers) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [container.delegate locationManager:self didRangeBeacon:beacon];
            });
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"!---------BAD THINGS IN DNYLocationManager--------!");
}

@end
