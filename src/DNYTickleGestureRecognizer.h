//
//  DNYTicketGestureRecognizer.h
//  Donny
//
//  Created by Dave Shanley on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DirectionUnknown = 0,
    DirectionLeft,
    DirectionRight
} Direction;

@interface DNYTickleGestureRecognizer : UIGestureRecognizer

@property (assign) int tickleCount;
@property (assign) CGPoint currentTickleStart;
@property (assign) Direction lastDirection;

@end
