//
//  NSIndexPath+CGVector.h
//  Donny
//
//  Created by Alex Belliotti on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface NSIndexPath (CGVector)

- (CGVector)vectorTo:(NSIndexPath *)to;

@end
