//
//  DNYCreatureModel.h
//  Donny
//
//  Created by Alex Belliotti on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNYCreatureViewController.h"
#import "StateMachine.h"
#import "DNYCreatureNode.h"

@interface DNYCreatureModel : NSObject

@property (weak, nonatomic) DNYCreatureViewController *controller;

@property (nonatomic, retain) NSString *state; // Property managed by StateMachine

@property (nonatomic, retain) NSDate *terminatedAt;

@property (nonatomic, weak) DNYCreatureNode *creatureNode;

@end

@interface DNYCreatureModel (State)

- (void)initializeStateMachine;

- (BOOL)sleep;
- (BOOL)wake;
- (BOOL)vibrate;
- (BOOL)vibrateChuckle;
- (BOOL)suspend;
- (BOOL)unsuspend;
- (BOOL)terminate;

- (BOOL)isSleeping;
- (BOOL)isAwake;
- (BOOL)isVibrating;
- (BOOL)isSuspended;
- (BOOL)isTerminated;

- (BOOL)canSleep;
- (BOOL)canWake;
- (BOOL)canVibrate;
- (BOOL)canSuspend;
- (BOOL)canUnsuspend;
- (BOOL)canTerminate;

@end
