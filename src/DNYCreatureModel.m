//
//  DNYCreatureModel.m
//  Donny
//
//  Created by Alex Belliotti on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYCreatureModel.h"
#import <QuartzCore/QuartzCore.h>

#define kDefaultCreatureLoopRate 30 // 60hz/2, number of frames to pass before next eval

@interface DNYCreatureModel ()

- (void)evaluate;

@end

@implementation DNYCreatureModel


- (void)makeAlive {
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(evaluate)];
    displayLink.frameInterval = kDefaultCreatureLoopRate;
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)evaluate {
    
}


@end
