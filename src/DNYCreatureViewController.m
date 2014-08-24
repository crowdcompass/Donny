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


@end

@implementation DNYCreatureViewController

#pragma mark - UIViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _creatureModel = [[DNYCreatureModel alloc] init];
        _creatureModel.controller = self;
        [_creatureModel setupInteractions];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.creatureModel wake];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.creatureModel.creatureNode mouthVomit];
    });
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - DNYCreatureViewController

- (void)setupSpriteKit {
    self.skView.showsFPS = NO;
    self.skView.showsNodeCount = NO;
    
    self.scene = [[DNYScene alloc] initWithSize:self.skView.bounds.size];
    
    [self.skView presentScene:self.scene];
    self.creatureModel.creatureNode = self.scene.creatureNode;
}

@end
