//
//  DNYSpriteNode.m
//  Donny
//
//  Created by Corlett, Robert on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYSpriteNode.h"

@implementation DNYSpriteNode

- (void)runAction:(SKAction *)action {
    [super runAction:action];
    if (self.dropShadow) {
        [self.dropShadow runAction:action];
    }
}

- (void)updateDropShadow {
    self.dropShadow.position = CGPointMake(self.position.x, self.position.y - 8.f);
}

@end
