//
//  DNYCreatureNode.m
//  Donny
//
//  Created by Alex Belliotti on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYCreatureNode.h"

@implementation DNYCreatureNode

#pragma mark - SKSpriteNode/SKNode/NSObject

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _leftEyeBrow = [SKSpriteNode spriteNodeWithImageNamed:@"eyebrow-positive.png"];
        _leftEyeBrow.hidden = YES;
        [self addChild:_leftEyeBrow];
        _leftEye = [SKSpriteNode spriteNodeWithImageNamed:@"eye-sleep.png"];
        _leftEye.position = CGPointMake(-105.f, 135.f);
        [self addChild:_leftEye];
        
        _rightEyeBrow = [SKSpriteNode spriteNodeWithImageNamed:@"eyebrow-positive.png"];
        _rightEyeBrow.hidden = YES;
        [self addChild:_rightEyeBrow];
        _rightEye.position = CGPointMake(105.f, 135.f);
        _rightEye = [SKSpriteNode spriteNodeWithImageNamed:@"eye-sleep.png"];
        [self addChild:_rightEye];
        
        _nose = [SKSpriteNode spriteNodeWithImageNamed:@"nose.png"];
        _nose.position = CGPointMake(-0.f, 35.f);
        [self addChild:_nose];
        
        _mouth = [SKSpriteNode spriteNodeWithImageNamed:@"mouth-sleep.png"];
        _mouth.position = CGPointMake(10.f, -125.f);
        [self addChild:_mouth];
    }
    
    return self;
}

#pragma mark - DNYCreatureNode

#pragma mark Actions

- (void)blink {
    
}

@end
