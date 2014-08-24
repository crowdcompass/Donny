//
//  DonnyTests.m
//  DonnyTests
//
//  Created by Ben Cullen-Kerney on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSIndexPath+CGVector.h"

@interface DonnyTests : XCTestCase

@end

BOOL vectorsEqual(CGVector a, CGVector b) {
    return a.dx == b.dx && a.dy == b.dy;
}

@implementation DonnyTests

- (void)testVector {
    NSIndexPath *initial1 = [NSIndexPath indexPathForItem:0 inSection:1];
    NSIndexPath *to1 = [NSIndexPath indexPathForItem:2 inSection:0];
    
    CGVector computed1 = [initial1 vectorTo:to1];
    CGVector expected1 = CGVectorMake(2.f, 1.f);
    
    XCTAssertTrue(vectorsEqual(computed1, expected1));
    
    NSIndexPath *initial2 = [NSIndexPath indexPathForItem:1 inSection:0];
    NSIndexPath *to2 = [NSIndexPath indexPathForItem:1 inSection:1];
    
    CGVector computed2 = [initial2 vectorTo:to2];
    CGVector expected2 = CGVectorMake(0.f, -1.f);
    
    XCTAssertTrue(vectorsEqual(computed2, expected2));
}

@end
