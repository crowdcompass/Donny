//
//  DNYCreatureViewController.h
//  Donny
//
//  Created by Alex Belliotti on 8/22/14.
//  Copyright (c) 2014 CrowdCompass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DNYCreatureModel.h"

//@class DNYCreatureModel;

@interface DNYCreatureViewController : UIViewController

@property (weak, nonatomic) SKView *skView;
@property (strong, nonatomic) DNYCreatureModel *creatureModel;

@end
