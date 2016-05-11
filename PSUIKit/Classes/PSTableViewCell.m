//
//  PSTableViewCell.m
//  PSUIKit
//
//  Created by Steve Kim on 2014. 8. 24..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2014년 Steve Kim. All rights reserved.
//

#import "PSTableViewCell.h"
#import "PSUIKit.h"

@implementation PSTableViewCell
{
@private
    BOOL initializedSubviews;
    NSString *identifier;
}

// ================================================================================================
//  Class
// ================================================================================================

+ (PSTableViewCell *)sharedInstance
{
    return nil;
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

// ================================================================================================
//  Overridden: UITableViewCell
// ================================================================================================

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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
        [self initProperties];
    return self;
}

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.allowsBackgroundViewFit)
    {
        self.backgroundView.frame = self.bounds;
        self.selectedBackgroundView.frame = self.bounds;
    }
}

- (NSString *)reuseIdentifier
{
    if (identifier)
        return identifier;
    
    identifier = [[self class] reuseIdentifier];
    return identifier;
}

- (void)setNeedsLayout {
    if ([self isEqual:[[self class] sharedInstance]])
        [self layoutSubviews];
    else
        [super setNeedsLayout];
}

// ================================================================================================
//  Public
// ================================================================================================

- (void)invalidateProperties
{
    if (self.superview || self.immediatelyUpdating)
        [self commitProperties];
}

- (CGFloat)heightWithSuperview:(UIView *)superview object:(id)object {
    return self.height;
}

- (void)setAllowsBackgroundViewFit:(BOOL)allowsBackgroundViewFit
{
    if (_allowsBackgroundViewFit == allowsBackgroundViewFit)
        return;
    
    _allowsBackgroundViewFit = allowsBackgroundViewFit;
    
    [self setNeedsLayout];
}

- (PSLinedBackgroundView *)linedBackgroundView {
    return (PSLinedBackgroundView *) self.backgroundView;
}

- (PSLinedBackgroundView *)selectedLinedBackgroundView {
    return (PSLinedBackgroundView *) self.selectedBackgroundView;
}

// ================================================================================================
//  Protected
// ================================================================================================

- (void)commitProperties
{
}

- (void)initProperties
{
    _allowsBackgroundViewFit = YES;
}

- (void)setUpSubviews
{
}

@end