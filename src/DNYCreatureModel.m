//
//  DNYCreatureModel.m
//  Donny
//
//  Created by Alex Belliotti on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYCreatureModel.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

#import "DNYMotionInteraction.h"
#import "DNYFaceInteraction.h"
#import "DNYFoodInteraction.h"
#import "DNYTickleInteraction.h"
#import "DNYPetInteraction.h"
#import "DNYProximitySensorInteraction.h"

#define kDefaultCreatureLoopRate 30 // 60hz/2, number of frames to pass before next eval
#define kDefaultCreatureTimerSeconds 0.5
#define kNeglectInterval 60 // seconds that define being neglected
#define kMoodSettleInterval 20 // seconds


NSString *const kSoundBeepoo                    = @"31867_HardPCM_Chip030";

NSString *const kSoundBoo = @"boo";
NSString *const kSoundGettingSick = @"getting_sick";
NSString *const kSoundPleaseStop = @"please_stop";
NSString *const kSoundTasty = @"tasty";
NSString *const kSoundThatSmell = @"that_smell";
NSString *const kSoundYay = @"yay";

NSString *const kUserDefaultKeyHappiness        = @"happiness";


@interface DNYCreatureModel ()

@property (nonatomic, strong) NSDate *lastInteraction;
@property (nonatomic, strong) AVSpeechSynthesizer *synth;

- (void)makeAwake;
- (void)makeAsleep;
- (void)makeNeglected;
- (void)settleMoodSince:(NSTimeInterval)duration;

- (void)makeTalkWithText:(NSString *)text;

- (void)updateLastInteractionTime;
- (void)evaluate;
- (void)happinessDidChange:(NSInteger)newHappy;

@end


@implementation DNYCreatureModel

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark State Machine


STATE_MACHINE(^(LSStateMachine * sm) {
    sm.initialState = @"sleeping";
    
    [sm addState:@"sleeping"];
    [sm addState:@"awake"];
    [sm addState:@"suspended"];
    [sm addState:@"terminated"];
    
    [sm when:@"sleep" transitionFrom:@"sleeping" to:@"sleeping"];
    [sm when:@"sleep" transitionFrom:@"awake" to:@"sleeping"];
    [sm when:@"wake" transitionFrom:@"sleeping" to:@"awake"];
    [sm when:@"suspend" transitionFrom:@"awake" to:@"suspended"];
    [sm when:@"unsuspend" transitionFrom:@"suspended" to:@"awake"];
    [sm when:@"terminate" transitionFrom:@"awake" to:@"terminated"];
    [sm when:@"terminate" transitionFrom:@"sleeping" to:@"terminated"];
    
    [sm after:@"sleep" do:^(DNYCreatureModel *creature) {
        [creature makeAsleep];
    }];
    [sm after:@"wake" do:^(DNYCreatureModel *creature) {
        [creature makeAwake];
    }];
})

- (id)init {
    self = [super init];
    if (self) {
        [self initializeStateMachine];
        self.synth = [AVSpeechSynthesizer new];
//        NSLog(@"%@", [AVSpeechSynthesisVoice speechVoices]);
        self.synth.delegate = self;
        self.leftEyeClosed = NO;
        self.rightEyeClosed = NO;
        self.sick = NO;
    }
    return self;
}


- (void)setupInteractions {
    self.interactions = @[
                          [[DNYFaceInteraction alloc] initWithCreature:self],
                          [[DNYMotionInteraction alloc] initWithCreature:self],
                          [[DNYFoodInteraction alloc] initWithCreature:self],
                          [[DNYPetInteraction alloc] initWithCreature:self],
                          [[DNYProximitySensorInteraction alloc] initWithCreature:self],
                          [[DNYTickleInteraction alloc] initWithCreature:self],
                          ];

}

- (void)setCreatureNode:(DNYCreatureNode *)creatureNode {
    _creatureNode = creatureNode;
    _creatureNode.creature = self;
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Core capabilities

- (void)makeAwake {
    NSLog(@"Model::makeAwake");
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:kDefaultCreatureTimerSeconds target:self selector:@selector(evaluate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.creatureNode wakeup];
    });
    
    NSError *error = nil;
    if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error]){
        NSLog(@"%@", error);
    }
    
    [self playSoundWithName:kSoundBeepoo];
//    [self makeTalkWithText:@"beeep beeep booop booop boop"];
    [self updateLastInteractionTime];
}

- (void)makeAsleep {
    NSLog(@"Model::makeAsleep");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.creatureNode sleep];
    });
    [self updateLastInteractionTime];
}

- (void)vibrate {
     AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    [self stopVibrating];
}

/**
 This uses a private API method, so would need to be compiled out of a sumbitted app
 */
- (void)vibrateChuckle {
    [self increaseHappinessWithReaction:YES withSickness:NO];
    NSMutableDictionary* patternsDict = [@{} mutableCopy];
    NSMutableArray* patternsArray = [@[] mutableCopy];
    
    [patternsArray addObjectsFromArray:@[@(YES), @(500),
                                        @(NO),@(500),
                                         @(YES), @(250),
                                         @(NO), @(250),
                                         @(YES), @(250),
                                         @(NO), @(250),
                                         @(YES), @(250),
                                         @(NO), @(100),
                                         @(YES), @(150)]];
        
    [patternsDict setObject:patternsArray forKey:@"VibePattern"];
    [patternsDict setObject:[NSNumber numberWithInt:1.0] forKey:@"Intensity"];
    
    // suppress warnings
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wall"
    AudioServicesStopSystemSound(kSystemSoundID_Vibrate);
    
    AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate,nil,patternsDict);
#pragma clang diagnostic pop
    [self updateLastInteractionTime];
    [self stopVibrating];

}

- (void)stopVibrating {
    AudioServicesStopSystemSound();
}

- (void)makeNeglected {
    NSLog(@"Model::makeNeglected I AM BEING NEGLECTED WAAAAA");
    [self updateLastInteractionTime];
}

- (void)updateLastInteractionTime {
    self.lastInteraction = [NSDate date];
}

- (void)increaseHappinessWithReaction:(BOOL)shoudlReact withSickness:(BOOL)sick {
    if (!self.isAwake) return;

    NSLog(@":) happier");
    NSNumber *newHappiness = self.happiness < 4 ? @(self.happiness + 1) : @(4);
    [[NSUserDefaults standardUserDefaults] setObject:newHappiness forKey:kUserDefaultKeyHappiness];
    [[NSUserDefaults standardUserDefaults] synchronize];

    self.sick = sick;
    self.creatureNode.sick = sick;
    [self updateLastInteractionTime];

    if (shoudlReact) {
        if (sick) { [self.creatureNode reactPositivelySick]; }
        else { [self.creatureNode reactPositively]; }
        [self playAifSoundWithName:@"yay"];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self happinessDidChange:newHappiness.integerValue];
    });

}

- (void)decreaseHappinessWithReaction:(BOOL)shouldReact withSickness:(BOOL)sick {
    if (!self.isAwake) return;
    NSLog(@":( unhappier");
    NSNumber *newHappiness = self.happiness > -3 ? @(self.happiness - 1) : @(-3);
    [[NSUserDefaults standardUserDefaults] setObject:newHappiness forKey:kUserDefaultKeyHappiness];
    [[NSUserDefaults standardUserDefaults] synchronize];

    self.sick = sick;
    self.creatureNode.sick = sick;
    [self updateLastInteractionTime];

    if (shouldReact) {
        if (sick) { [self.creatureNode reactNegativelySick]; }
        else { [self.creatureNode reactNegatively]; }
        
        [self playAifSoundWithName:@"boo"];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self happinessDidChange:newHappiness.integerValue];
    });
}

- (void)happinessDidChange:(NSInteger)newHappy {
    if (!self.isAwake) return;
    [self.creatureNode displayFaceForHappiness:newHappy];
}

- (NSInteger)happiness {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyHappiness] integerValue];
}

- (void)settleMoodSince:(NSTimeInterval)duration {
    if (!self.isAwake) return;
    
    if (duration >= kMoodSettleInterval) {
        if (self.happiness > -1) {
            [self decreaseHappinessWithReaction:NO withSickness:NO];
        } else if (self.happiness < -1) {
            [self increaseHappinessWithReaction:NO withSickness:NO];
        }
    }
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Creature runloop

- (void)evaluate {
//    NSLog(@">>> Evaluating Donny's State <<<");
    NSTimeInterval lastSeen = [[NSDate date] timeIntervalSinceDate:self.lastInteraction];
    
    for (DNYInteraction *interaction in self.interactions) {
        if ([interaction conformsToProtocol:@protocol(DNYEvaluatedInteraction)]) {
            [interaction performSelector:@selector(evaluate)];
        }
    }
    
    [self settleMoodSince:lastSeen];
    
    if (lastSeen >= kNeglectInterval) {
        NSLog(@"Time interval %f", lastSeen);
        [self makeNeglected];
    }
    
    if (rint(fmod([[NSDate date] timeIntervalSince1970], 11)) == 0 || rint(fmod([[NSDate date] timeIntervalSince1970], 7)) == 0) {
        if (arc4random_uniform(2) == 0) {
            NSLog(@"blink");
            [self.creatureNode blink:1];
        } else if (arc4random_uniform(2) == 0) {
            NSLog(@"bounce");
            [self.creatureNode bounceEyebrows];
        }
    }
}


//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Helpers

- (void)playSoundWithName:(NSString *)filename {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"wav"];
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileUrl, &soundId);
    AudioServicesPlaySystemSound(soundId);
//    NSError *error;
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
//    NSLog(@"%@", error);
//    player.volume = 1.0;
//    [player prepareToPlay];
//    [player play];
}

- (void)playAifSoundWithName:(NSString *)filename {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"aif"];
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileUrl, &soundId);
    AudioServicesPlaySystemSound(soundId);
}

- (void)makeTalkWithText:(NSString *)text {
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"ja-JP"];
    utterance.rate = 0.1;
    utterance.pitchMultiplier = 1.2;
    [self.synth speakUtterance:utterance];
}

@end
