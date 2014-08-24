//
//  DNYTickleInteraction.h
//  Donny
//
//  Created by Dave Shanley on 8/23/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import "DNYInteraction.h"
#import "DNYTickleGestureRecognizer.h"

@interface DNYTickleInteraction : DNYInteraction <UIGestureRecognizerDelegate>

- (void)handleTickle:(DNYTickleGestureRecognizer *)recognizer;

@end
