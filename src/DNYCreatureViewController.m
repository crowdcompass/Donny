//
//  DNYCreatureViewController.m
//  Donny
//
//  Created by Alex Belliotti on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYCreatureViewController.h"
#import "DNYFaceInteraction.h"

@interface DNYCreatureViewController ()

@property (nonatomic, strong) DNYFaceInteraction *faceInteraction;

@end

@implementation DNYCreatureViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _creatureModel = [[DNYCreatureModel alloc] init];
        _creatureModel.controller = self;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.faceInteraction = [[DNYFaceInteraction alloc] initWithCreature:self.creatureModel];
}


@end
