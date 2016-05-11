//
//  PSButton.m
//  PSUIKit
//
//  Created by pisces on 1/5/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

#import "PSButton.h"

@implementation PSButton
{
@private
    UIColor *nativeBackgroundColor;
}

// ================================================================================================
//  Overridden: UIButton
// ================================================================================================

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    if (!self.highlighted)
        nativeBackgroundColor = backgroundColor;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (self.highlightedBackgroundColor) {
        if (highlighted)
            self.backgroundColor = self.highlightedBackgroundColor;
        else
            self.backgroundColor = nativeBackgroundColor;
    }
}

@end
