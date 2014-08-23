//
//  DNYCreatureNode.m
//  Donny
//
//  Created by Alex Belliotti on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYCreatureNode.h"

@implementation DNYCreatureNode

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _leftEyeBrow = [SKSpriteNode spriteNodeWithImageNamed:@"eyebrow-positive.png"];
        [self addChild:_leftEyeBrow];
        _leftEye = [SKSpriteNode spriteNodeWithImageNamed:@"eye-standard.png"];
        [self addChild:_leftEye];
        
        _rightEyeBrow = [SKSpriteNode spriteNodeWithImageNamed:@"eyebrow-positive.png"];
        [self addChild:_rightEyeBrow];
        _rightEye = [SKSpriteNode spriteNodeWithImageNamed:@"eye-standard.png"];
        [self addChild:_rightEye];
        
        _nose = [SKSpriteNode spriteNodeWithImageNamed:@"nose.png"];
        [self addChild:_nose];
        
        _mouth = [SKSpriteNode spriteNodeWithImageNamed:@"mouth-smile.png"];
        [self addChild:_mouth];
    }
    
    return self;
}

@end
