//
//  UIColor+RGB.m
//  Hood
//
//  Created by Alexander Belliotti on 3/11/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "UIColor+RGB.h"

@implementation UIColor (RGB)

+ (UIColor *)colorWithR:(int)r G:(int)g B:(int)b {
    
    return [UIColor colorWithRed:r/255.f
                           green:g/255.f
                            blue:b/255.f
                           alpha:1.f];
}

@end
