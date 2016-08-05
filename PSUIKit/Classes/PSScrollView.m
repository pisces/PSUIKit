//
//  PSScrollView.m
//  PSUIKit
//
//  Created by pisces on 2015. 4. 11..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "PSScrollView.h"

@implementation PSScrollView
{
@private
    BOOL initializedSubviews;
}

// ================================================================================================
//  Overridden: UIScrollView
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

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer
{
    return _allowShouldRecognizeSimultaneously;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (_allowsTouchesOutsideSubview) {
        for (UIView *subview in self.subviews) {
            CGPoint pointInSubview = [subview convertPoint:point fromView:self];
            if ([subview pointInside:pointInSubview withEvent:event]) {
                return YES;
            }
        }
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

// ================================================================================================
//  Public
// ================================================================================================

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
