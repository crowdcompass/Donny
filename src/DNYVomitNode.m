//
//  DNYVomitNode.m
//  Donny
//
//  Created by Alex Belliotti on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYVomitNode.h"

#import "UIColor+RGB.h"

@implementation DNYVomitNode

+ (instancetype)nodeWithTargetNode:(SKNode *)targetNode {
    DNYVomitNode *vomit = [DNYVomitNode node];
    vomit.targetNode = targetNode;
    vomit.particleBirthRate = 100.f;
    vomit.numParticlesToEmit = 500.f;
    vomit.particleLifetime = 3.f;
    vomit.particlePositionRange = CGVectorMake(150.f, 15.f);
    vomit.particleAlphaRange = .85f;
    
    return vomit;
}


+ (NSArray *)happyColors {
    SKColor *greenColor = [UIColor colorWithR:126 G:211 B:33];
    SKColor *orangeColor = [UIColor colorWithR:255 G:139 B:0];
    SKColor *purpleColor = [UIColor colorWithR:189 G:16 B:224];
    SKColor *redColor = [UIColor colorWithR:224 G:16 B:16];
    SKColor *yellowColor = [UIColor colorWithR:248 G:231 B:28];
    
    return @[ greenColor, orangeColor, purpleColor, redColor, yellowColor ];
}

+ (NSArray *)sickColors {
    SKColor *purple1 = [UIColor colorWithR:189 G:16 B:224]; //80
    SKColor *purple2 = [UIColor colorWithR:144 G:19 B:254]; //10
    SKColor *purple3 = [UIColor colorWithR:93 G:28 B:150]; //10
    
    return @[ purple1, purple2, purple3 ];
}

@end
