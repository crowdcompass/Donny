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
#import "DNYFoodInteraction.h"
#import "DNYScene.h"
#import "DNYCreatureNode.h"
#import "DNYMotionInteraction.h"

@interface DNYCreatureViewController ()

@property (strong, nonatomic) DNYScene *scene;
@property (weak, nonatomic) SKView *skView;

@property (nonatomic, strong) DNYFaceInteraction *faceInteraction;
@property (nonatomic, strong) DNYMotionInteraction *motionInteraction;
@property (nonatomic, strong) DNYFoodInteraction *foodInteraction;

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
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    [self.creatureModel wake];
    
    SKView *view = [[SKView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.view addSubview:view];
    self.skView = view;
    
    self.faceInteraction = [[DNYFaceInteraction alloc] initWithCreature:self.creatureModel];
    self.motionInteraction = [[DNYMotionInteraction alloc] initWithCreature:self.creatureModel];
    self.foodInteraction = [[DNYFoodInteraction alloc] initWithCreature:self.creatureModel];
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
    [self.scene.creatureNode sleep];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.scene.creatureNode wakeup];
    });
}

@end
