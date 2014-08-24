//
//  DNYInteraction.h
//  Donny
//
//  Created by Ben Cullen-Kerney on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNYCreatureModel.h"

@protocol DNYEvaluatedInteraction;

@interface DNYInteraction : NSObject

@property DNYCreatureModel* creature;

- (instancetype)initWithCreature:(DNYCreatureModel *)creature;

@end

@protocol DNYEvaluatedInteraction <NSObject>

- (void)evaluate;

@end
