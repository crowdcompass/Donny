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
#import "DNYScene.h"
#import "DNYCreatureNode.h"

@interface DNYCreatureViewController ()

@property (strong, nonatomic) DNYScene *scene;
@property (weak, nonatomic) SKView *skView;

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
    
    SKView *view = [[SKView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.view addSubview:view];
    self.skView = view;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (!self.skView.scene) {
        [self setupSpriteKit];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.creatureModel sleep];
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
    self.creatureModel.creatureNode = self.scene.creatureNode;
//    [self.scene.creatureNode sleep];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.scene.creatureNode wakeup];
//    });
}

@end
