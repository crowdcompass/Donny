//
//  AppDelegate.h
//  Donny
//
//  Created by Ben Cullen-Kerney on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DNYPersistence;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DNYPersistence *persistence;

@end

