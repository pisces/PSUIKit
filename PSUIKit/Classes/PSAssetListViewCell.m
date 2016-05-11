//
//  PSAssetListViewCell.m
//  PSUIKit
//
//  Created by pisces on 2015. 7. 3..
//  Copyright (c) 2015년 Steve Kim. All rights reserved.
//

#import "PSAssetListViewCell.h"
#import "PSUIKit.h"

@implementation PSAssetListViewCell
{
@private
    __weak IBOutlet UIImageView *overlayImageView;
    
    BOOL allowsOverlayImageShowChanged;
    BOOL assetChanged;
}

// ================================================================================================
//  Overridden: PSCollectionViewCell
// ================================================================================================

#pragma mark - Overridden: PSCollectionViewCell

- (void)commitProperties {
    if (allowsOverlayImageShowChanged) {
        allowsOverlayImageShowChanged = NO;
        overlayImageView.hidden = self.allowsOverlayImageShow ? overlayImageView.hidden : YES;
    }
    
    if (assetChanged) {
        assetChanged = NO;
        
        [self assetChanged];
        [self setNeedsLayout];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (self.allowsOverlayImageShow)
        overlayImageView.hidden = !selected;
}

- (void)setUpSubviews {
    [super setUpSubviews];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    overlayImageView.image = [[UIImage imageNamed:@"PSUIKit.bundle/icon_check_overlay.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    overlayImageView.hidden = YES;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (void)setAllowsOverlayImageShow:(BOOL)allowsOverlayImageShow {
    if (allowsOverlayImageShow == _allowsOverlayImageShow)
        return;
    
    _allowsOverlayImageShow = allowsOverlayImageShow;
    allowsOverlayImageShowChanged = YES;
    
    [self invalidateProperties];
}

- (void)setAsset:(ALAsset *)asset {
    if ([asset isEqual:_asset])
        return;
    
    _asset = asset;
    assetChanged = YES;
    
    [self invalidateProperties];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (void)assetChanged {
    self.imageView.image = [UIImage imageWithCGImage:self.asset.aspectRatioThumbnail];
}

@end
