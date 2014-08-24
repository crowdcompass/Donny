//
//  NSIndexPath+CGPoint.m
//  Donny
//
//  Created by Ben Cullen-Kerney on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "NSIndexPath+CGPoint.h"
#import <UIKit/UIKit.h>

@implementation NSIndexPath (CGPoint)

+ (NSIndexPath*)fromPoint:(CGPoint)point
{
    NSUInteger xOut;
    NSUInteger yOut;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int winWidth = screenRect.size.width;
    int winHeight = screenRect.size.height;
    int xBase = (winWidth / 3);
    int yBase = (winHeight / 3);
    if (point.x <= xBase) {
        xOut = 0;
    } else if (point.x <= (xBase * 2)) {
        xOut = 1;
    } else {
        xOut = 2;
    }
    if (point.y <= yBase) {
        yOut = 0;
    } else if (point.y <= (yBase * 2)) {
        yOut = 1;
    } else {
        yOut = 2;
    }
//    
//    NSLog(@"winWidth: %i", winWidth);
//    NSLog(@"winHeight: %i", winHeight);
//    NSLog(@"xBase: %i", xBase);
//    NSLog(@"yBase: %i", yBase);
//    NSLog(@"origX: %f", point.x);
//    NSLog(@"origY: %f", point.y);
//    NSLog(@"xOut: %i", xOut);
//    NSLog(@"yOut: %i", yOut);
//    
    return [NSIndexPath indexPathForItem:xOut inSection:yOut];
}


@end
