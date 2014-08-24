//
//  DNYSpriteNode.m
//  Donny
//
//  Created by Corlett, Robert on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYSpriteNode.h"

@implementation DNYSpriteNode

- (instancetype)init {
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"texture"];
}

- (void)runAction:(SKAction *)action {
    [self runAction:action ignoreDropShadow:NO];
}

- (void)runAction:(SKAction *)action ignoreDropShadow:(BOOL)ignore {
    [super runAction:action];

    if (ignore) {
        return;
    }

    [self.dropShadow runAction:action];
    self.dropShadow.position = CGPointMake(self.dropShadow.position.x, self.position.y - 8.f);
}

@end
