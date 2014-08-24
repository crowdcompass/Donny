//
//  DNYSpriteNode.h
//  Donny
//
//  Created by Corlett, Robert on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DNYSpriteNode : SKSpriteNode

@property (nonatomic, strong) SKSpriteNode *dropShadow;

- (void)updateDropShadow;

@end
