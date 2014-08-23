//
//  DNYCreatureNode.h
//  Donny
//
//  Created by Alex Belliotti on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DNYCreatureNode : SKNode

@property (strong, nonatomic) SKSpriteNode *leftEyeBrow;
@property (strong, nonatomic) SKSpriteNode *leftEye;

@property (strong, nonatomic) SKSpriteNode *rightEyeBrow;
@property (strong, nonatomic) SKSpriteNode *rightEye;

@property (strong, nonatomic) SKSpriteNode *nose;

@property (strong, nonatomic) SKSpriteNode *mouth;

- (void)sleep;
- (void)wakeup;
- (void)blink;

@end
