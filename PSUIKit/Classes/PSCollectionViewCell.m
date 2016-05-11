//
//  PSCollectionViewCell.m
//  PSUIKit
//
//  Created by Steve Kim on 2015. 4. 11..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "PSCollectionViewCell.h"

@implementation PSCollectionViewCell
{
@private
    BOOL initializedSubviews;
    NSString *identifier;
}

// ================================================================================================
//  Class
// ================================================================================================

+ (CGFloat)heightWithTableView:(UITableView *)tableView object:(id)object
{
    return tableView.rowHeight;
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

// ================================================================================================
//  Overridden: UICollectionViewCell
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

// ================================================================================================
//  Public
// ================================================================================================

- (void)invalidateProperties
{
    if (self.superview || self.immediatelyUpdating)
        [self commitProperties];
}

- (void)setAllowsBackgroundViewFit:(BOOL)allowsBackgroundViewFit
{
    if (_allowsBackgroundViewFit == allowsBackgroundViewFit)
        return;
    
    _allowsBackgroundViewFit = allowsBackgroundViewFit;
    
    [self setNeedsLayout];
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
