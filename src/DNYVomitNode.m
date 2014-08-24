//
//  DNYVomitNode.m
//  Donny
//
//  Created by Alex Belliotti on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYVomitNode.h"

#import "UIColor+RGB.h"

const CGFloat kTotalParticles = 800.f;
const CGFloat kTotalParticleBirthRate = 200.f;

@implementation DNYVomitNode

+ (instancetype)vomitNodeWithTargetNode:(SKNode *)targetNode isHappy:(BOOL)happy {
    NSParameterAssert(!!targetNode);
    
    DNYVomitNode *vomit = [DNYVomitNode node];
    NSArray *emitters = nil;
    
    if (happy) {
        emitters = [self happyColorEmitters:targetNode];
    } else {
        emitters = [self sickColorEmitters:targetNode];
    }
    
    for (SKEmitterNode *emitter in emitters) {
        [vomit addChild:emitter];
    }
    
    return vomit;
}

+ (NSArray *)happyColorEmitters:(SKNode *)target {
    SKColor *greenColor = [UIColor colorWithR:126 G:211 B:33];
    SKColor *orangeColor = [UIColor colorWithR:255 G:139 B:0];
    SKColor *purpleColor = [UIColor colorWithR:189 G:16 B:224];
    SKColor *redColor = [UIColor colorWithR:224 G:16 B:16];
    SKColor *yellowColor = [UIColor colorWithR:248 G:231 B:28];
    
    NSArray *colors = @[ greenColor, orangeColor, purpleColor, redColor, yellowColor ];
    
    NSMutableArray *emitters = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        SKEmitterNode *emitter = [self vomitEmitterWithTargetNode:target];
        emitter.particleColor = color;
        emitter.numParticlesToEmit = kTotalParticles / (CGFloat)colors.count;
        emitter.particleBirthRate = kTotalParticleBirthRate / (CGFloat)colors.count;
        
        [emitters addObject:emitter];
    }
    
    return emitters;
}

+ (NSArray *)sickColorEmitters:(SKNode *)target {
    SKColor *purple1 = [UIColor colorWithR:189 G:16 B:224]; //80%
    SKColor *purple2 = [UIColor colorWithR:144 G:19 B:254]; //10%
    SKColor *purple3 = [UIColor colorWithR:93 G:28 B:150]; //10%
    
    NSArray *colors = @[ purple1, purple2, purple3 ];
    
    NSMutableArray *emitters = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        SKEmitterNode *emitter = [self vomitEmitterWithTargetNode:target];
        emitter.particleColor = color;
//        emitter.numParticlesToEmit = kTotalParticles / (CGFloat)colors.count;
//        emitter.particleBirthRate = kTotalParticleBirthRate / (CGFloat)colors.count;
        if ([color isEqual:purple1]) {
            //first color is 80% of particles
            emitter.numParticlesToEmit = .6f * kTotalParticles;
            emitter.particleBirthRate = .6f * kTotalParticleBirthRate;
        } else {
            //remaining two are %20
            emitter.numParticlesToEmit = .4f * kTotalParticles;
            emitter.particleBirthRate = .4f * kTotalParticleBirthRate;
        }
        [emitters addObject:emitter];
    }
    
    return emitters;
}

+ (SKEmitterNode *)vomitEmitterWithTargetNode:(SKNode *)target {
    SKEmitterNode *vomit = [SKEmitterNode node];
    
    vomit.targetNode = target;
    vomit.particleSize = CGSizeMake(20.f, 20.f);
    vomit.particleLifetime = 15.f;
    vomit.particleAlphaRange = .85f;
    
    vomit.particlePositionRange = CGVectorMake(80.f, 15.f);
    vomit.particleSpeedRange = 60.f;
    vomit.yAcceleration = -465.f;
    vomit.emissionAngle = (3.f * (CGFloat)M_PI) / 2.f;
    
    return vomit;
}

@end
