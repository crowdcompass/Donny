//
//  DNYLocationManager.h
//  Donny
//
//  Created by Alex Belliotti on 8/24/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol DNYBeaconDelegate;

@interface DNYLocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

+ (instancetype)instance;

- (void)registerDelegate:(id<DNYBeaconDelegate>)delegate forBeaconWithUUID:(NSUUID *)uuid identifier:(NSString *)identifier;

@end

@protocol DNYBeaconDelegate <NSObject>

- (void)locationManager:(DNYLocationManager *)manager didRangeBeacon:(CLBeacon *)beacon;

@end

