//
//  DNYCreatureNode.m
//  Donny
//
//  Created by Alex Belliotti on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYCreatureNode.h"
#import <Foundation/Foundation.h>

#import "NSIndexPath+CGVector.h"

@interface DNYCreatureNode ()

@property (strong, nonatomic) NSArray *nodes;

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
        
        self.nodes = @[ _leftEyeBrow, _leftEye, _rightEyeBrow, _rightEye,
                        _nose, _mouth ];
        
        _lookingAt = [NSIndexPath indexPathForItem:1 inSection:1];
    }
    
    return self;
}

- (void)removeAllActions {
    [super removeAllActions];
    
    for (SKNode *node in self.nodes) {
        [node removeAllActions];
    }
}

#pragma mark - DNYCreatureNode

#pragma mark Actions

- (void)blink {
    SKTexture *currentEyeTexture = [self.leftEye.texture copy];
    SKTexture *blinkEyeTexture = [SKTexture textureWithImageNamed:@"eye-wink.png"];
    
    SKAction *blinkAction = [SKAction setTexture:blinkEyeTexture resize:YES];
    SKAction *blinkTimeAction = [SKAction waitForDuration:.35];
    SKAction *undoBlinkAction = [SKAction setTexture:currentEyeTexture resize:YES];
    
    SKAction *actionGroup = [SKAction sequence:@[ blinkAction, blinkTimeAction, undoBlinkAction ]];
    
    [self.leftEye runAction:actionGroup];
    [self.rightEye runAction:actionGroup];
}

//1 1.5, 2 1.75
- (void)sleep {
    SKTexture *sleep1Texture = [SKTexture textureWithImageNamed:@"mouth-sleep-01.png"];
    SKTexture *sleep2Texture = [SKTexture textureWithImageNamed:@"mouth-sleep-02.png"];
    
    SKAction *time1 = [SKAction waitForDuration:1.5];
    SKAction *time2 = [SKAction waitForDuration:1.75];
    
    SKAction *goToSleep1 = [SKAction setTexture:sleep1Texture resize:YES];
    
    SKAction *moveDown = [SKAction moveByX:10.f y:-10.f duration:0];
    SKAction *moveUp = [SKAction moveByX:-10.f y:10.f duration:0];

    SKAction *goToSleep2 = [SKAction setTexture:sleep2Texture resize:YES];

    SKAction *groupAction = [SKAction sequence:@[ goToSleep1, time1, moveDown, goToSleep2, time2, moveUp ]];
    SKAction *repeatingAction = [SKAction repeatActionForever:groupAction];
    
    [self.mouth runAction:repeatingAction];
    
    /*
    SKAction *animateAction = [SKAction animateWithTextures:@[ sleep1Texture, sleep2Texture ] timePerFrame:1.5 resize:YES restore:YES];
    [self.mouth runAction:[SKAction repeatActionForever:animateAction]];
     */
}

- (void)wakeup {
    self.leftEyeBrow.hidden = YES;
    self.rightEyeBrow.hidden = YES;
    
    SKTexture *normalEyeTexture = [SKTexture textureWithImageNamed:@"eye-standard.png"];
    SKAction *normalEyeActionTexture = [SKAction setTexture:normalEyeTexture resize:YES];
    SKAction *normalEyeActionMoveLeft = [SKAction moveTo:CGPointMake(70.f, 383.f) duration:0];
    SKAction *normalEyeActionMoveRight = [SKAction moveTo:CGPointMake(250.f, 383.f) duration:0];
    
    SKAction *leftEyeGroup = [SKAction group:@[ normalEyeActionTexture, normalEyeActionMoveLeft ]];
    SKAction *rightEyeGroup = [SKAction group:@[ normalEyeActionTexture, normalEyeActionMoveRight ]];
    
    SKTexture *normalMouthTexture = [SKTexture textureWithImageNamed:@"mouth-smile.png"];
    SKAction *normalMouthActionTexture = [SKAction setTexture:normalMouthTexture resize:YES];
    SKAction *normalMouthActionMove = [SKAction moveTo:CGPointMake(160.f, 243.f) duration:0];
    SKAction *mouthGroup = [SKAction group:@[ normalMouthActionTexture, normalMouthActionMove ]];
    
    [self removeAllActions];
    
    [self.leftEye runAction:leftEyeGroup];
    [self.rightEye runAction:rightEyeGroup];
    [self.mouth runAction:mouthGroup];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self blink];
    });
}

- (void)lookAt:(NSIndexPath *)path {
    NSAssert(path.row >= 0 && path.row <=3 && path.item >=0 && path.item <= 3,
             @"Over the line, Donny!");
    
    CGVector baseVector = [self.lookingAt vectorTo:path];
    CGVector moveEyesBy = scaleVectorBy(baseVector, 6.f);
    CGVector moveBy = scaleVectorBy(baseVector, 3.f);
    
    SKAction *moveEyeAction = [SKAction moveBy:moveEyesBy duration:.33];
    [self.leftEye runAction:moveEyeAction];
    [self.rightEye runAction:moveEyeAction];
    
    SKAction *moveNoseAction = [SKAction moveBy:moveBy duration:.33];
    [self.nose runAction:moveNoseAction];
    
    SKAction *moveMouthAction = [SKAction moveBy:moveBy duration:.33];
    [self.mouth runAction:moveMouthAction];
    
    self.lookingAt = path;
}

CGVector scaleVectorBy(CGVector vec, CGFloat scale) {
    return CGVectorMake(vec.dx * scale, vec.dy * scale);
}

@end
