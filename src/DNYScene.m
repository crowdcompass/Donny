//
//  DNYScene.m
//  Donny
//
//  Created by Alex Belliotti on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYScene.h"

#import "DNYCreatureNode.h"
#import "UIColor+RGB.h"

@interface DNYScene()

@end

@implementation DNYScene

#pragma mark - SKScene

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self) {
        self.scaleMode = SKSceneScaleModeAspectFill;
        self.backgroundColor = [UIColor colorWithR:203 G:202 B:255];
        _creatureNode = [[DNYCreatureNode alloc] init];
        [self addChild:_creatureNode];
    }
    
    return self;
}

- (void)didEvaluateActions {
    int debug = 1;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        SKNode *node = [self.creatureNode nodeAtPoint:[touch locationInNode:self]];
        if ([node.description containsString:@"eye"]) {
            NSLog(@"Touched eye");
        } else if ([node.description containsString:@"nose"]) {
            NSLog(@"Touched nose");
        } else if ([node.description containsString:@"mouth"]) {
            NSLog(@"Touched mouth");
        }
    }
}

@end
