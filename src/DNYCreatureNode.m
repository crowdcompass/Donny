//
//  DNYCreatureNode.m
//  Donny
//
//  Created by Alex Belliotti on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYCreatureNode.h"

@interface DNYCreatureNode ()

@end

@implementation DNYCreatureNode

#pragma mark - SKSpriteNode/SKNode/NSObject

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _leftEyeBrow = [SKSpriteNode spriteNodeWithImageNamed:@"eyebrow-positive.png"];
        _leftEyeBrow.hidden = YES;
        [self addChild:_leftEyeBrow];
        _leftEye = [SKSpriteNode spriteNodeWithImageNamed:@"eye-sleep.png"];
        _leftEye.position = CGPointMake(70.f, 393.f);
        [self addChild:_leftEye];
        
        _rightEyeBrow = [SKSpriteNode spriteNodeWithImageNamed:@"eyebrow-positive.png"];
        _rightEyeBrow.hidden = YES;
        [self addChild:_rightEyeBrow];
        _rightEye = [SKSpriteNode spriteNodeWithImageNamed:@"eye-sleep.png"];
        _rightEye.position = CGPointMake(250.f, 393.f);
        [self addChild:_rightEye];
       
        _nose = [SKSpriteNode spriteNodeWithImageNamed:@"nose.png"];
        _nose.position = CGPointMake(160.f, 353.f);
        [self addChild:_nose];
        
        _mouth = [SKSpriteNode spriteNodeWithImageNamed:@"mouth-sleep-01.png"];
        _mouth.position = CGPointMake(180.f, 218.f);
        [self addChild:_mouth];
    }
    
    return self;
}

#pragma mark - DNYCreatureNode

#pragma mark Actions

- (void)blink {
    
}

@end
