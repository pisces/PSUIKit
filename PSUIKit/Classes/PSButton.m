//
//  PSButton.m
//  PSUIKit
//
//  Created by pisces on 1/5/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

#import "PSButton.h"

@interface PSButton ()
@property(nonnull, strong) NSMutableDictionary *fontDictionary;
@property(nonnull, readonly) UIFont *disabledFont;
@property(nonnull, readonly) UIFont *highlightedFont;
@property(nonnull, readonly) UIFont *normalFont;
@property(nonnull, readonly) UIFont *selectedFont;
@end

@implementation PSButton
{
@private
    UIColor *nativeBackgroundColor;
}

// ================================================================================================
//  Overridden: UIButton
// ================================================================================================

#pragma mark - Overridden: UIButton

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    if (!self.highlighted) {
        nativeBackgroundColor = backgroundColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (self.highlightedBackgroundColor) {
        if (highlighted) {
            self.backgroundColor = self.highlightedBackgroundColor;
        } else {
            self.backgroundColor = nativeBackgroundColor;
        }
    }
}

- (void)layoutSubviews {
    NSUInteger state = self.state;
    
    switch (state) {
        case UIControlStateNormal:
            self.titleLabel.font = self.normalFont;
            break;
            
        case UIControlStateHighlighted:
            self.titleLabel.font = self.highlightedFont;
            break;
            
        case UIControlStateSelected:
            self.titleLabel.font = self.selectedFont;
            break;
            
        case UIControlStateDisabled:
            self.titleLabel.font = self.disabledFont;
            break;
            
        default:
            self.titleLabel.font = self.normalFont;
            break;
    }
    
    [super layoutSubviews];
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public methods

- (void)setFont:(UIFont *)font forState:(UIControlState)state {
    self.fontDictionary[@(state)] = font;
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private getter/setter

- (UIFont *)disabledFont {
    return self.fontDictionary[@(UIControlStateDisabled)] ? self.fontDictionary[@(UIControlStateDisabled)] : self.titleLabel.font;
}

- (UIFont *)highlightedFont {
    return self.fontDictionary[@(UIControlStateHighlighted)] ? self.fontDictionary[@(UIControlStateHighlighted)] : self.titleLabel.font;
}

- (UIFont *)normalFont {
    return self.fontDictionary[@(UIControlStateNormal)] ? self.fontDictionary[@(UIControlStateNormal)] : self.titleLabel.font;
}

- (UIFont *)selectedFont {
    return self.fontDictionary[@(UIControlStateSelected)] ? self.fontDictionary[@(UIControlStateSelected)] : self.titleLabel.font;
}

- (NSMutableDictionary *)fontDictionary {
    if (!_fontDictionary) {
        _fontDictionary = [NSMutableDictionary dictionaryWithCapacity:4];
    }
    return _fontDictionary;
}

@end
