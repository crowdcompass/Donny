//
//  DNYVomitNode.h
//  Donny
//
//  Created by Alex Belliotti on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DNYVomitNode : SKNode

+ (instancetype)vomitNodeWithTargetNode:(SKNode *)targetNode isHappy:(BOOL)happy;

@end
