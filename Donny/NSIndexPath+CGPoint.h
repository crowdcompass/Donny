//
//  NSIndexPath+CGPoint.h
//  Donny
//
//  Created by Ben Cullen-Kerney on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface NSIndexPath (CGPoint)

+ (NSIndexPath*)fromPoint:(CGPoint)point;

@end
