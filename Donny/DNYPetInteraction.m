//
//  DNYPetInteraction.m
//  Donny
//
//  Created by Ben Cullen-Kerney on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYPetInteraction.h"

@interface DNYCreatureModel (DNYPetInteractionBehavior)

-(void) dny_PetInteractionPetNose;

@end

@implementation DNYCreatureModel (DNYPetInteractionBehavior)

-(void) dny_PetInteractionPetNose
{
    NSLog(@"Petted on nose");
}

@end

@interface DNYPetInteraction()

-(void)touchEventReceived;

@end

@implementation DNYPetInteraction

- (instancetype)initWithCreature:(DNYCreatureModel *)creature {
    self = [super initWithCreature:creature];
    if (self) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self
                               selector:@selector(touchEventReceived)
                                   name:@"touchedNose"
                                 object:nil];
    }
    return self;
}

-(void)touchEventReceived
{
    [self.creature dny_PetInteractionPetNose];
}

-(void)dealloc
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

@end
