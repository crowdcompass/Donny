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
    [super runAction:action];
    if (action.duration != 0.33) {
        [self.dropShadow runAction:action];
        self.dropShadow.position = CGPointMake(self.position.x, self.position.y - 8.f);
    }
}

@end
