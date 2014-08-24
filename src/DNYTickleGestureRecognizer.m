//
//  DNYTicketGestureRecognizer.m
//  Donny
//
//  Created by Dave Shanley on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYTickleGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

// See http://www.raywenderlich.com/6567/uigesturerecognizer-tutorial-in-ios-5-pinches-pans-and-more

#define REQUIRED_TICKLES        2
#define MOVE_AMT_PER_TICKLE     25

@implementation DNYTickleGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"tickle: touches began");
    UITouch * touch = [touches anyObject];
    self.currentTickleStart = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"tickle: touches moved");
    // Make sure we've moved a minimum amount since curTickleStart
    UITouch * touch = [touches anyObject];
    CGPoint ticklePoint = [touch locationInView:self.view];
    CGFloat moveAmt = ticklePoint.x - self.currentTickleStart.x;
    Direction curDirection;
    if (moveAmt < 0) {
        curDirection = DirectionLeft;
    } else {
        curDirection = DirectionRight;
    }
    if (ABS(moveAmt) < MOVE_AMT_PER_TICKLE) return;
    
    // Make sure we've switched directions
    if (self.lastDirection == DirectionUnknown ||
        (self.lastDirection == DirectionLeft && curDirection == DirectionRight) ||
        (self.lastDirection == DirectionRight && curDirection == DirectionLeft)) {
        
        // w00t we've got a tickle!
        self.tickleCount++;
        self.currentTickleStart = ticklePoint;
        self.lastDirection = curDirection;
        
        // Once we have the required number of tickles, switch the state to ended.
        // As a result of doing this, the callback will be called.
        if (self.state == UIGestureRecognizerStatePossible && self.tickleCount > REQUIRED_TICKLES) {
            [self setState:UIGestureRecognizerStateEnded];
        }
    }
    
}

- (void)resetState {
    self.tickleCount = 0;
    self.currentTickleStart = CGPointZero;
    self.lastDirection = DirectionUnknown;
    if (self.state == UIGestureRecognizerStatePossible) {
        [self setState:UIGestureRecognizerStateFailed];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"tickle: touches ended");
    [self resetState];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"tickle: touches cancelled");
    [self resetState];
}

@end
