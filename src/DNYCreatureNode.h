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

@property (copy, nonatomic) NSIndexPath *lookingAt;

- (void)sleep;
- (void)wakeup;
- (void)blink;

/**
 @param path indexPath representing a point on a 3x3 grid, section is y, item is x
 examples:
 lower right - [NSIndexPath indexPathForItem:2 inSection:2]
 upper right - [NSIndexPath indexPathForItem:2 inSection:0]
 center - [NSIndexPath indexPathForItem:1 inSection:1]
 */
- (void)lookAt:(NSIndexPath *)path;

@end
