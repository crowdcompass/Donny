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

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _creatureNode = [[DNYCreatureNode alloc] init];
        _creatureNode.position = CGPointMake(0.f, 0.f);
        
        [self addChild:_creatureNode];
    }
    
    return self;
}

@end
