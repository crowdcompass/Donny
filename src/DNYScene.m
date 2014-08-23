//
//  DNYScene.m
//  Donny
//
//  Created by Alex Belliotti on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYScene.h"

#import "DNYCreatureNode.h"

@interface DNYScene()

@end

@implementation DNYScene

#pragma mark - SKScene

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self) {
        self.scaleMode = SKSceneScaleModeAspectFill;
        _creatureNode = [[DNYCreatureNode alloc] init];
        [self addChild:_creatureNode];
    }
    
    return self;
}

- (void)didEvaluateActions {
    int debug = 1;
}

@end
