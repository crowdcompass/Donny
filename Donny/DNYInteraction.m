//
//  DNYInteraction.m
//  Donny
//
//  Created by Ben Cullen-Kerney on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYInteraction.h"

@implementation DNYInteraction

- (instancetype)initWithCreature:(DNYCreatureModel *)creature {
    self = [super init];
    if (self) {
        _creature = creature;
    }
    NSLog(@"Initialized %@",self);

    return  self;
}

@end
