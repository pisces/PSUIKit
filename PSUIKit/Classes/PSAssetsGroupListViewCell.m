//
//  PSAssetsGroupListViewCell.m
//  PSUIKit
//
//  Created by pisces on 2015. 7. 3..
//  Copyright (c) 2015년 Steve Kim. All rights reserved.
//

#import "PSAssetsGroupListViewCell.h"
#import "PSUIKit.h"

@implementation PSAssetsGroupListViewCell
{
@private
    __weak IBOutlet UIImageView *posterImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *countLabel;
    
    BOOL groupChanged;
}

// ================================================================================================
//  Overridden: PSTableViewCell
// ================================================================================================

#pragma mark - Overridden: PSTableViewCell

- (void)commitProperties {
    if (groupChanged) {
        groupChanged = NO;
        
        [self groupChanged];
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    nameLabel.y = (self.height - (nameLabel.height + countLabel.height + 10))/2;
    countLabel.y = nameLabel.bottom + 10;
}

- (void)setUpSubviews {
    [super setUpSubviews];
    
    self.linedBackgroundView.seperatorColors = self.selectedLinedBackgroundView.seperatorColors = @[[UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1]];
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (void)setGroup:(ALAssetsGroup *)group {
    if ([group isEqual:_group])
        return;
    
    _group = group;
    groupChanged = YES;
    
    [self invalidateProperties];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (void)groupChanged {
    [self.group setAssetsFilter:[ALAssetsFilter allPhotos]];
    
    posterImageView.image = [UIImage imageWithCGImage:self.group.posterImage];
    nameLabel.text = [self.group valueForProperty:[PSUIKit localizedStringWithKey:ALAssetsGroupPropertyName]];
    countLabel.text = self.group.numberOfAssets > 0 ? [NSString stringWithFormat:@"%zd", self.group.numberOfAssets] : nil;
    
    [nameLabel sizeToFit];
    [countLabel sizeToFit];
}

@end