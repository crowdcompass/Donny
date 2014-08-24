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

@end

@implementation DNYCreatureNode

#pragma mark - SKSpriteNode/SKNode/NSObject

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _leftEyeBrow = [DNYSpriteNode spriteNodeWithImageNamed:@"eyebrow-positive.png"];
        _leftEyeBrow.hidden = YES;
        [self addDropShadowToSpriteNode:_leftEyeBrow];
        [self addChild:_leftEyeBrow];
        _leftEye = [DNYSpriteNode spriteNodeWithImageNamed:@"eye-sleep.png"];
        _leftEye.position = CGPointMake(70.f, 393.f);
        [self addDropShadowToSpriteNode:_leftEye];
        [self addChild:_leftEye];
        
        _rightEyeBrow = [DNYSpriteNode spriteNodeWithImageNamed:@"eyebrow-positive.png"];
        _rightEyeBrow.hidden = YES;
        [self addDropShadowToSpriteNode:_rightEyeBrow];
        [self addChild:_rightEyeBrow];
        _rightEye = [DNYSpriteNode spriteNodeWithImageNamed:@"eye-sleep.png"];
        _rightEye.position = CGPointMake(250.f, 393.f);
        [self addDropShadowToSpriteNode:_rightEye];
        [self addChild:_rightEye];
       
        _nose = [DNYSpriteNode spriteNodeWithImageNamed:@"nose.png"];
        _nose.position = CGPointMake(160.f, 353.f);
        [self addDropShadowToSpriteNode:_nose];
        [self addChild:_nose];
        
        _mouth = [DNYSpriteNode spriteNodeWithImageNamed:@"mouth-sleep-01.png"];
        _mouth.position = CGPointMake(180.f, 218.f);
        [self addDropShadowToSpriteNode:_mouth];
        [self addChild:_mouth];
        
        _lookingAt = [NSIndexPath indexPathForItem:1 inSection:1];
    }
    
    return self;
}

static const float kDropShadowYOffset = 8.f;
- (void)addDropShadowToSpriteNode:(DNYSpriteNode *)spriteNode {
    spriteNode.zPosition++;
    DNYSpriteNode *dropShadow = [spriteNode copy];
    dropShadow.alpha = 0.25;
    dropShadow.position = CGPointMake(spriteNode.position.x, spriteNode.position.y - kDropShadowYOffset);

    spriteNode.dropShadow = dropShadow;
    [self addChild:dropShadow];
}

- (void)removeAllActions {
    [super removeAllActions];
    
    for (SKNode *node in self.children) {
        [node removeAllActions];
    }
}

#pragma mark - DNYCreatureNode

#pragma mark Actions

- (void)setCreatureColorForHappiness:(int)happiness {
    switch (happiness) {
        case -3:
            self.scene.backgroundColor = [SKColor colorWithRed:255/255.f green:152/255.f blue:152/255.f alpha:1];
            break;
        case -2:
            self.scene.backgroundColor = [SKColor colorWithRed:237/255.f green:168/255.f blue:186/255.f alpha:1];
            break;
        case -1:
            self.scene.backgroundColor = [SKColor colorWithRed:220/255.f green:185/255.f blue:220/255.f alpha:1];
            break;
        case 0:
            self.scene.backgroundColor = [SKColor colorWithRed:203/255.f green:202/255.f blue:255/255.f alpha:1];
            break;
        case 1:
            self.scene.backgroundColor = [SKColor colorWithRed:163/255.f green:202/255.f blue:252/255.f alpha:1];
            break;
        case 2:
            self.scene.backgroundColor = [SKColor colorWithRed:123/255.f green:202/255.f blue:250/255.f alpha:1];
            break;
        case 3:
            self.scene.backgroundColor = [SKColor colorWithRed:123/255.f green:202/255.f blue:248/255.f alpha:1];
            break;
        case 4:
            //Crazy rainbow vomit
            break;
        default:
            //??
            break;
    }
}

- (void)blink:(NSUInteger)count {
    SKTexture *currentEyeTexture = [self.leftEye.texture copy];
    SKTexture *blinkEyeTexture = [SKTexture textureWithImageNamed:@"eye-wink.png"];
    
    SKAction *blinkAction = [SKAction setTexture:blinkEyeTexture resize:YES];
    SKAction *blinkTimeAction = [SKAction waitForDuration:.15];
    SKAction *undoBlinkAction = [SKAction setTexture:currentEyeTexture resize:YES];
    
    SKAction *singleBlink = [SKAction sequence:@[ blinkAction, blinkTimeAction, undoBlinkAction ]];

    NSMutableArray *groups = [NSMutableArray array];

    for (int i = 0; i <= count; i++) {
        [groups addObject:singleBlink];
    }

    SKAction *actionGroup = [SKAction sequence:groups];

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
    
    SKAction *leftEyeGroup = [SKAction group:@[ normalEyeActionTexture, normalEyeActionMoveLeft]];
    SKAction *rightEyeGroup = [SKAction group:@[ normalEyeActionTexture, normalEyeActionMoveRight ]];
    
    SKTexture *normalMouthTexture = [SKTexture textureWithImageNamed:@"mouth-smile.png"];
    SKAction *normalMouthActionTexture = [SKAction setTexture:normalMouthTexture resize:YES];
    SKAction *normalMouthActionMove = [SKAction moveTo:CGPointMake(160.f, 243.f) duration:0];
    SKAction *mouthGroup = [SKAction group:@[ normalMouthActionTexture, normalMouthActionMove ]];
    
    [self removeAllActions];

    [self runAction:[self flashAction]];
    [self.leftEye runAction:leftEyeGroup];
    [self.rightEye runAction:rightEyeGroup];
    [self.mouth runAction:mouthGroup];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self blink:2];
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

//Action Helpers
- (SKAction *)flashAction {
    //Background flash
    SKColor *goodColor = [SKColor colorWithRed:152/255.f green:255/255.f blue:164/255.f alpha:1];
    SKColor *normalColor = [SKColor colorWithRed:203/255.f green:202/255.f blue:255/255.f alpha:1];
    SKAction *flashAction = [SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        self.scene.backgroundColor = goodColor;
    }], [SKAction waitForDuration:0.1], [SKAction runBlock:^{
        self.scene.backgroundColor = normalColor;
    }], [SKAction waitForDuration:0.1]]] count:2]]];

    return flashAction;
}

@end
