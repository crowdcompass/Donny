//
//  NSIndexPath+CGVector.m
//  Donny
//
//  Created by Alex Belliotti on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "NSIndexPath+CGVector.h"

#import <UIKit/UIKit.h>

@implementation NSIndexPath (CGVector)

- (CGVector)vectorTo:(NSIndexPath *)to {
    return CGVectorMake([to toPoint].x - [self toPoint].x,
                        [to toPoint].y - [self toPoint].y - 1);
}

- (CGPoint)toPoint {
    return CGPointMake((CGFloat)self.item - 1, (CGFloat)self.row - 1);
}

@end
