//
//  UIMaskedImageView.m
//  PSUIKit
//
//  Created by pisces on 2015. 8. 11..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "UIMaskedImageView.h"

@implementation UIMaskedImageView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CAAnimation* animation = [self.layer animationForKey:@"bounds"];
    if (animation) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:animation.duration];
    }
    
    self.layer.mask.bounds = self.layer.bounds;
    if (animation) {
        [CATransaction commit];
    }
}

@end
