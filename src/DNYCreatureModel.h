//
//  DNYCreatureModel.h
//  Donny
//
//  Created by Alex Belliotti on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNYCreatureViewController.h"

@interface DNYCreatureModel : NSObject

@property (weak, nonatomic) DNYCreatureViewController *controller;

- (void)makeAlive;

@end
