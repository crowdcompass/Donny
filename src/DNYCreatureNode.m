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
        [self addChild:_leftEyeBrow];
        _leftEye = [DNYSpriteNode spriteNodeWithImageNamed:@"eye-sleep.png"];
        _leftEye.position = CGPointMake(70.f, 393.f);
        self.leftEyeShadow = [self addDropShadowToSpriteNode:_leftEye];
        [self addChild:_leftEye];
        
        _rightEyeBrow = [DNYSpriteNode spriteNodeWithImageNamed:@"eyebrow-positive.png"];
        _rightEyeBrow.hidden = YES;
        [self addChild:_rightEyeBrow];
        _rightEye = [DNYSpriteNode spriteNodeWithImageNamed:@"eye-sleep.png"];
        _rightEye.position = CGPointMake(250.f, 393.f);
        self.rightEyeShadow = [self addDropShadowToSpriteNode:_rightEye];
        [self addChild:_rightEye];
       
        _nose = [DNYSpriteNode spriteNodeWithImageNamed:@"nose.png"];
        _nose.position = CGPointMake(160.f, 353.f);
        self.noseShadow = [self addDropShadowToSpriteNode:_nose];
        [self addChild:_nose];
        
        _mouth = [DNYSpriteNode spriteNodeWithImageNamed:@"mouth-sleep-01.png"];
        _mouth.position = CGPointMake(180.f, 218.f);
        self.mouthShadow = [self addDropShadowToSpriteNode:_mouth];
        [self addChild:_mouth];
        
        _lookingAt = [NSIndexPath indexPathForItem:1 inSection:1];
    }
    
    return self;
}

static const float kDropShadowYOffset = 8.f;
- (DNYSpriteNode *)addDropShadowToSpriteNode:(DNYSpriteNode *)spriteNode {
    spriteNode.zPosition++;
    DNYSpriteNode *dropShadow = [spriteNode copy];
    dropShadow.alpha = 0.25;
    dropShadow.position = CGPointMake(spriteNode.position.x, spriteNode.position.y - kDropShadowYOffset);

    spriteNode.dropShadow = dropShadow;
    [self addChild:dropShadow];

    return dropShadow;
}

- (void)removeAllActions {
    [super removeAllActions];
    
    for (SKNode *node in self.children) {
        [node removeAllActions];
    }
}

#pragma mark - DNYCreatureNode

#pragma mark Actions

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

- (void)displayFaceForHappiness:(NSInteger)happiness {
    //set background color
    self.scene.backgroundColor = [self creatureColorForHappiness:happiness];

    switch (happiness) {
        case -3:
            [self normalMinus3];
            break;
        case -2:
            [self normalMinus2];
            break;
        case -1:
            [self normalMinus1];
            break;
        case 0:
            [self normal];
            break;
        case 1:
            [self normalPlus1];
            break;
        case 2:
            [self normalPlus2];
            break;
        case 3:
            [self normalPlus3];
            break;
        case 4:
            //
            break;
        default:
            break;
    }
}

- (void)normalMinus3 {
    [self removeAllActions];
    
    [self eyebrowsNegative];
    [self eyesSmall];
    [self mouthFrown];
}

- (void)normalMinus2 {
    [self removeAllActions];
    
    [self eyebrowsNegative];
    [self eyesSmall];
    [self mouthFrown];
}

- (void)normalMinus1 {
    [self removeAllActions];
    
    [self eyebrowsNone];
    [self eyesStandard];
    [self mouthStraight];
}

- (void)normal {
    [self removeAllActions];
    
    [self eyebrowsNone];
    [self eyesStandard];
    [self mouthSmile];
}

- (void)normalPlus1 {
    [self removeAllActions];
    
    [self eyebrowsPositive];
    [self eyesStandard];
    [self mouthSmile];
}

- (void)normalPlus2 {
    [self removeAllActions];
    
    [self eyebrowsPositive];
    [self eyesSmall];
    [self mouthGood];
}

- (void)normalPlus3 {
    [self removeAllActions];
    
    [self eyebrowsPositive];
    [self eyesWink];
    [self mouthHappiest];
}

- (void)sleep {
    [self removeAllActions];

    [self eyebrowsNone];
    [self eyesSleep];
    [self mouthSleeping];
}

- (void)wakeup {
    [self removeAllActions];

    [self eyebrowsNone];
    [self eyesStandard];
    [self mouthSmile];

    [self runAction:[self flashActionFromColor:[SKColor colorWithRed:152/255.f green:255/255.f blue:164/255.f alpha:1]
                                       toColor:[SKColor colorWithRed:203/255.f green:202/255.f blue:255/255.f alpha:1]]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self blink:2];
    });
}

- (void)reactPositively {
    [self removeAllActions];

    [self runAction:[self flashActionFromColor:[SKColor colorWithRed:203/255.f green:202/255.f blue:255/255.f alpha:1]
                                       toColor:[SKColor colorWithRed:152/225.f green:255/255.f blue:164/255.f alpha:1]]];
    [self eyebrowsPositive];
    [self eyesWink];
    [self mouthGood];
}

- (void)reactNegatively {
    [self removeAllActions];

    [self runAction:[self flashActionFromColor:[SKColor colorWithRed:203/255.f green:202/255.f blue:255/255.f alpha:1]
                                       toColor:[SKColor colorWithRed:255/255.f green:152/255.f blue:164/255.f alpha:1]]];
    [self eyebrowsNegative];
    [self eyesSmall];
    [self mouthBad];

}




#pragma mark Fine Grain Control

//Eyebrows
- (void)eyebrowsNone {
    self.leftEyeBrow.hidden = YES;
    self.rightEyeBrow.hidden = YES;

}

- (void)eyebrowsPositive {
    self.leftEyeBrow.hidden = NO;
    self.leftEyeBrow.position = CGPointMake(80.f, 453.f);

    self.rightEyeBrow.hidden = NO;
    self.rightEyeBrow.position = CGPointMake(240.f, 453.f);

    SKTexture *texture = [SKTexture textureWithImageNamed:@"eyebrow-positive"];
    SKAction *action = [SKAction setTexture:texture resize:YES];
    SKAction *flip = [SKAction scaleXTo:-self.leftEyeBrow.xScale duration:0];

    [self.leftEyeBrow runAction:action];
    [self.rightEyeBrow runAction:flip];
    [self.rightEyeBrow runAction:action];
}

- (void)eyebrowsSad {
    self.leftEyeBrow.hidden = NO;
    self.leftEyeBrow.position = CGPointMake(80.f, 453.f);

    self.rightEyeBrow.hidden = NO;
    self.rightEyeBrow.position = CGPointMake(240.f, 453.f);

    SKTexture *texture = [SKTexture textureWithImageNamed:@"eyebrow-sad"];
    SKAction *action = [SKAction setTexture:texture resize:YES];
    SKAction *flip = [SKAction scaleXTo:-self.leftEyeBrow.xScale duration:0];

    [self.leftEyeBrow runAction:action];
    [self.rightEyeBrow runAction:flip];
    [self.rightEyeBrow runAction:action];

}

- (void)eyebrowsNegative {
    self.leftEyeBrow.hidden = NO;
    self.leftEyeBrow.position = CGPointMake(80.f, 453.f);

    self.rightEyeBrow.hidden = NO;
    self.rightEyeBrow.position = CGPointMake(240.f, 453.f);

    SKTexture *texture = [SKTexture textureWithImageNamed:@"eyebrow-negative"];
    SKAction *action = [SKAction setTexture:texture resize:YES];
    SKAction *flip = [SKAction scaleXTo:-self.leftEyeBrow.xScale duration:0];

    [self.leftEyeBrow runAction:action];
    [self.rightEyeBrow runAction:flip];
    [self.rightEyeBrow runAction:action];

}

//Eyes
- (void)eyesStandard {
    SKTexture *texture = [SKTexture textureWithImageNamed:@"eye-standard"];
    SKAction *action = [SKAction setTexture:texture resize:YES];

    [self.leftEye runAction:action];
    [self.rightEye runAction:action];
}

- (void)eyesSmall {
    SKTexture *texture = [SKTexture textureWithImageNamed:@"eye-small"];
    SKAction *action = [SKAction setTexture:texture resize:YES];

    [self.leftEye runAction:action];
    [self.rightEye runAction:action];

}

- (void)eyesSleep {
    SKTexture *texture = [SKTexture textureWithImageNamed:@"eye-sleep"];
    SKAction *action = [SKAction setTexture:texture resize:YES];

    [self.leftEye runAction:action];
    [self.rightEye runAction:action];

}

- (void)eyesWink {
    SKTexture *texture = [SKTexture textureWithImageNamed:@"eye-wink"];
    SKAction *action = [SKAction setTexture:texture resize:YES];

    [self.leftEye runAction:action];
    [self.rightEye runAction:action];

}

//Mouth
- (void)mouthBad {
    self.mouth.position = CGPointMake(160.f, 203.f);

    SKTexture *texture = [SKTexture textureWithImageNamed:@"mouth-bad-reaction"];
    SKAction *action = [SKAction setTexture:texture resize:YES];

    [self.mouth runAction:action];
}

- (void)mouthFrown {
    SKTexture *frownTexture = [SKTexture textureWithImageNamed:@"mouth-frown.png"];
    SKAction *textureAction = [SKAction setTexture:frownTexture resize:YES];
    SKAction *moveAction = [SKAction moveTo:CGPointMake(160.f, 233.f) duration:0.];
    
    SKAction *groupAction = [SKAction group:@[ textureAction, moveAction ]];
    [self.mouth runAction:groupAction];
}

- (void)mouthGood {
    self.mouth.position = CGPointMake(160.f, 223.f);

    SKTexture *texture = [SKTexture textureWithImageNamed:@"mouth-good-reaction.png"];
    SKAction *action = [SKAction setTexture:texture resize:YES];

    [self.mouth runAction:action];
}

- (void)mouthHappiest {
    self.mouth.position = CGPointMake(160.f, 213.f);
    
    SKTexture *texture = [SKTexture textureWithImageNamed:@"mouth-happy.png"];
    SKAction *action = [SKAction setTexture:texture resize:YES];
    
    [self.mouth runAction:action];
}

- (void)mouthSick {
    SKTexture *sickTexture = [SKTexture textureWithImageNamed:@"mouth-sick.png"];
    SKAction *sickAction = [SKAction setTexture:sickTexture];
    
    SKAction *moveAction = [SKAction moveTo:CGPointMake(160.f, 233.f) duration:0];
    
    SKAction *group = [SKAction group:@[ sickAction, moveAction ]];
    [self.mouth runAction:group];
}

- (void)mouthSicker {
    SKTexture *sickTexture = [SKTexture textureWithImageNamed:@"mouth-sicker.png"];
    SKAction *sickAction = [SKAction setTexture:sickTexture];
    
    SKAction *moveAction = [SKAction moveTo:CGPointMake(160.f, 233.f) duration:0];
    
    SKAction *group = [SKAction group:@[ sickAction, moveAction ]];
    [self.mouth runAction:group];
}

- (void)mouthSleeping {
    //animated
    self.mouth.position = CGPointMake(170.f, 218.f);

    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"mouth-sleep-01.png"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"mouth-sleep-02.png"];

    SKAction *time1 = [SKAction waitForDuration:1.5];
    SKAction *time2 = [SKAction waitForDuration:1.75];

    SKAction *action1 = [SKAction setTexture:texture1 resize:YES];

    SKAction *moveDown = [SKAction moveByX:10.f y:-10.f duration:0];
    SKAction *moveUp = [SKAction moveByX:-10.f y:10.f duration:0];

    SKAction *action2 = [SKAction setTexture:texture2 resize:YES];

    SKAction *groupAction = [SKAction sequence:@[ action1, time1, moveDown, action2, time2, moveUp ]];
    SKAction *repeatingAction = [SKAction repeatActionForever:groupAction];

    [self.mouth runAction:repeatingAction];
}

- (void)mouthSmile {
    self.mouth.position = CGPointMake(160.f, 223.f);

    SKTexture *texture = [SKTexture textureWithImageNamed:@"mouth-smile"];
    SKAction *action = [SKAction setTexture:texture resize:YES];

    [self.mouth runAction:action];
}

- (void)mouthStraight {
    SKTexture *mouthTexture = [SKTexture textureWithImageNamed:@"mouth-straight.png"];
    SKAction *textureAction = [SKAction setTexture:mouthTexture resize:YES];
    SKAction *moveAction = [SKAction moveTo:CGPointMake(160.f, 243.f) duration:0.f];
    
    SKAction *group = [SKAction group:@[ textureAction, moveAction ]];
    [self.mouth runAction:group];
}

- (void)mouthVomit {
    [NSException raise:@"Not Implemented" format:@"Not implemented"];
}

- (void)lookAt:(NSIndexPath *)path {
    NSAssert(path.row >= 0 && path.row <=3 && path.item >=0 && path.item <= 3,
             @"Over the line, Donny!");
    
    CGVector baseVector = [self.lookingAt vectorTo:path];
    CGVector moveEyesBy = scaleVectorBy(baseVector, 9.f);
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
- (SKAction *)flashActionFromColor:(SKColor *)fromColor toColor:(SKColor *)toColor {
    //Background flash
    SKAction *flashAction = [SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        self.scene.backgroundColor = fromColor;
    }], [SKAction waitForDuration:0.1], [SKAction runBlock:^{
        self.scene.backgroundColor = toColor;
    }], [SKAction waitForDuration:0.1]]] count:2]]];

    return flashAction;
}

- (SKColor *)creatureColorForHappiness:(NSInteger)happiness {
    SKColor *color;
    switch (happiness) {
        case -3:
            color = [SKColor colorWithRed:255/255.f green:152/255.f blue:152/255.f alpha:1];
            break;
        case -2:
            color = [SKColor colorWithRed:237/255.f green:168/255.f blue:186/255.f alpha:1];
            break;
        case -1:
            color = [SKColor colorWithRed:220/255.f green:185/255.f blue:220/255.f alpha:1];
            break;
        case 0:
            color = [SKColor colorWithRed:203/255.f green:202/255.f blue:255/255.f alpha:1];
            break;
        case 1:
            color = [SKColor colorWithRed:163/255.f green:202/255.f blue:252/255.f alpha:1];
            break;
        case 2:
            color = [SKColor colorWithRed:123/255.f green:202/255.f blue:250/255.f alpha:1];
            break;
        case 3:
            color = [SKColor colorWithRed:123/255.f green:202/255.f blue:248/255.f alpha:1];
            break;
        case 4:
            //Crazy rainbow vomit
            break;
        default:
            //??
            break;
    }
    return color;
}

@end
