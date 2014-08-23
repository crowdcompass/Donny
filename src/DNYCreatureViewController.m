//
//  DNYCreatureViewController.m
//  Donny
//
//  Created by Alex Belliotti on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYCreatureViewController.h"
#import <SpriteKit/SpriteKit.h>

//model
#import "DNYFaceInteraction.h"
#import "DNYScene.h"

@interface DNYCreatureViewController ()

@property (strong, nonatomic) DNYScene *scene;
@property (weak, nonatomic) SKView *skView;

@property (nonatomic, strong) DNYFaceInteraction *faceInteraction;

@end

@implementation DNYCreatureViewController

#pragma mark - UIViewController

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
    
    self.skView = (SKView *)self.view;
    self.skView.backgroundColor = [SKColor whiteColor];
    
    self.faceInteraction = [[DNYFaceInteraction alloc] initWithCreature:self.creatureModel];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (!self.skView.scene) {
        [self setupSpriteKit];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - DNYCreatureViewController

- (void)setupSpriteKit {
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    
    self.scene = [[DNYScene alloc] initWithSize:self.skView.bounds.size];
    
    [self.skView presentScene:self.scene];
}


@end
