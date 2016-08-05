//
//  PSLabel.m
//  PSUIKit
//
//  Created by Steve Kim on 2016. 7. 22..
//  Copyright (c) 2016년 Steve Kim. All rights reserved.
//

#import "PSLabel.h"

@implementation PSLabel
{
@private
    BOOL initializedSubviews;
}

// ================================================================================================
//  Overridden: UIView
// ================================================================================================

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (!initializedSubviews)
    {
        initializedSubviews = YES;
        
        [self setUpSubviews];
    }
    
    [self invalidateProperties];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    _appeared = self.window != nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self initProperties];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self initProperties];
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_allowTouchHighlighted) {
        self.highlighted = YES;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
}

// ================================================================================================
//  Public
// ================================================================================================

- (void)setAllowTouchHighlighted:(BOOL)allowTouchHighlighted {
    if (allowTouchHighlighted == _allowTouchHighlighted)
        return;
    
    _allowTouchHighlighted = allowTouchHighlighted;
    
    if (allowTouchHighlighted) {
        self.userInteractionEnabled = allowTouchHighlighted;
    }
}

- (void)invalidateProperties
{
    if (self.superview || self.immediatelyUpdating)
        [self commitProperties];
}

- (void)validateProperties
{
    [self commitProperties];
}

// ================================================================================================
//  Protected
// ================================================================================================

- (void)commitProperties
{
}

- (void)initProperties
{
}

- (void)setUpSubviews
{
}

@end