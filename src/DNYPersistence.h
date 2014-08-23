//
//  DNYPersistence.h
//  Donny
//
//  Created by Alex Belliotti on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

@interface DNYPersistence : NSObject

@property (strong, nonatomic) NSManagedObjectContext *mainQueueContext;

@end
