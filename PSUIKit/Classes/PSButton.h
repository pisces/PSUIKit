//
//  PSButton.h
//  PSUIKit
//
//  Created by pisces on 1/5/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSButton : UIButton
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;
- (void)setFont:(UIFont *)font forState:(UIControlState)state;
@end
