//
//  DNYTickleInteraction.m
//  Donny
//
//  Created by Dave Shanley on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYTickleInteraction.h"
#import "AppDelegate.h"
#import "DNYCreatureViewController.h"

@implementation DNYTickleInteraction

- (id)initWithCreature:(DNYCreatureModel *)creature {
    self = [super initWithCreature:creature];
    if (self) {
        [self setupTickleGesture];
    }
    return self;
}

- (void)setupTickleGesture {
    DNYTickleGestureRecognizer *recognizer = [[DNYTickleGestureRecognizer alloc] initWithTarget:self action:@selector(handleTickle:)];
    recognizer.delegate = self;
    [self.creature.controller.view addGestureRecognizer:recognizer];
}

- (void)handleTickle:(DNYTickleGestureRecognizer *)recognizer {
    NSLog(@"DNYTickleInteraction::handleTickle tickled!");
    [self.creature increaseHappiness];
}

@end
