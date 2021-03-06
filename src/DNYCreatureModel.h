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

@class DNYCreatureNode;

extern NSString *const kUserDefaultKeyHappiness;

@class DNYCreatureViewController;

@interface DNYCreatureModel : NSObject <AVSpeechSynthesizerDelegate>

@property (weak, nonatomic) DNYCreatureViewController *controller;
@property (nonatomic, retain) NSString *state; // Property managed by StateMachine
@property (nonatomic, retain) NSDate *terminatedAt;
@property (nonatomic, strong) NSArray *interactions;

// This would ideally be defined via extension
@property (nonatomic, strong) NSDate *lastFedAt;
@property (nonatomic, assign) BOOL leftEyeClosed;
@property (nonatomic, assign) BOOL rightEyeClosed;
@property (nonatomic, assign) BOOL sick;

@property (nonatomic, strong) NSDate *lastSmiledAt;

@property (assign, nonatomic, readonly) NSInteger happiness;
@property (assign, nonatomic) BOOL flat;

@property (nonatomic, weak) DNYCreatureNode *creatureNode;

- (void)increaseHappinessWithReaction:(BOOL)shoudlReact withSickness:(BOOL)sick;
- (void)decreaseHappinessWithReaction:(BOOL)shouldReact withSickness:(BOOL)sick;



@end

@interface DNYCreatureModel (State)

- (void)initializeStateMachine;
- (void)setupInteractions;

- (BOOL)sleep;
- (BOOL)wake;
- (BOOL)suspend;
- (BOOL)unsuspend;
- (BOOL)terminate;

- (void)vibrate;
- (void)vibrateChuckle;
- (void)playSoundWithName:(NSString *)filename;
- (void)playAifSoundWithName:(NSString *)filename;
- (void)happinessDidChange:(NSInteger)newHappy;

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
