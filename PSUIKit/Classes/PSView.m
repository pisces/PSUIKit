//
//  PSView.m
//  PSUIKit
//
//  Created by Steve Kim on 2014. 8. 24..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2014년 Steve Kim. All rights reserved.
//

#import "PSView.h"

@implementation PSView
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