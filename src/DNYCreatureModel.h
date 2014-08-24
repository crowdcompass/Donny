//
//  DNYCreatureModel.h
//  Donny
//
//  Created by Alex Belliotti on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "StateMachine.h"
#import "DNYCreatureNode.h"

@class DNYCreatureViewController;

@interface DNYCreatureModel : NSObject <AVSpeechSynthesizerDelegate>

@property (weak, nonatomic) DNYCreatureViewController *controller;
@property (nonatomic, retain) NSString *state; // Property managed by StateMachine
@property (nonatomic, retain) NSDate *terminatedAt;
@property (nonatomic, strong) NSArray *interactions;

@property (nonatomic, weak) DNYCreatureNode *creatureNode;

@end

@interface DNYCreatureModel (State)

- (void)initializeStateMachine;
- (void)setupInteractions;

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
