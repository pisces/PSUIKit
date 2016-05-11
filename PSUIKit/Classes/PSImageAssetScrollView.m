//
//  PSImageAssetScrollView.m
//  PSUIKit
//
//  Created by pisces on 2015. 7. 3..
//  Copyright (c) 2015년 Steve Kim. All rights reserved.
//

#import "PSImageAssetScrollView.h"
#import "PSUIKit.h"

@implementation PSImageAssetScrollView
{
@private
    BOOL assetChanged;
}

- (void)commitProperties {
    if (assetChanged) {
        assetChanged = NO;
        
        [self assetChanged];
    }
}

- (void)dealloc {
}

- (void)setUpSubviews {
    [super setUpSubviews];
    
    self.delegate = self;
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleAll;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.clipsToBounds = YES;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    doubleTapGestureRecognizer.numberOfTouchesRequired = 1;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    
    [self addSubview:self.imageView];
    [self addGestureRecognizer:doubleTapGestureRecognizer];
    [self addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (void)setAsset:(ALAsset *)asset {
    if ([asset isEqual:_asset])
        return;
    
    _asset = asset;
    assetChanged = YES;
    
    [self invalidateProperties];
}

#pragma mark - Public methods

- (void)resetZoomScale {
    self.zoomScale = self.minimumZoomScale;
    
    [self setNeedsLayout];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (void)assetChanged {
    self.imageView.image = [UIImage imageWithCGImage:self.asset.defaultRepresentation.fullScreenImage];
    [self layoutViews];
}

- (void)centerScrollViewContents {
    CGSize boundsSize = CGSizeMake(MAX(self.width, self.contentSize.width), MAX(self.height, self.contentSize.height));
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width)
        contentsFrame.origin.x = floorf((boundsSize.width - contentsFrame.size.width) / 2.0f);
    else
        contentsFrame.origin.x = 0.0f;
    
    if (contentsFrame.size.height < boundsSize.height)
        contentsFrame.origin.y = floorf((boundsSize.height - contentsFrame.size.height) / 2.0f);
    else
        contentsFrame.origin.y = 0.0f;
    
    self.imageView.frame = contentsFrame;
}

- (void)layoutImageView {
    if (self.imageView.image) {
        CGSize size = self.imageView.image.size;
        CGFloat scale = self.width / size.width;
        
        self.minimumZoomScale = scale;
        self.maximumZoomScale = scale * 3.0f;
        self.zoomScale = scale;
        
        self.imageView.frame = CGRectMake(0.0f, 0.0f, size.width * scale, size.height * scale);
        self.contentSize = CGSizeMake(size.width * scale, size.height * scale);
    } else {
        self.minimumZoomScale = self.maximumZoomScale = 1.0f;
        self.zoomScale = 1.0f;
        
        self.imageView.frame = self.bounds;
        self.contentSize = self.bounds.size;
    }
    
    self.contentInset = UIEdgeInsetsZero;
}

- (void)layoutViews {
    [self layoutImageView];
    [self centerScrollViewContents];
}

#pragma mark - UIScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollViewContents];
}

#pragma mark - UITapGestureRecognizer selector

- (void)doubleTapped:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [gestureRecognizer locationInView:self.imageView];
        CGFloat newZoomScale = self.zoomScale > (self.maximumZoomScale / 2) ? self.minimumZoomScale : self.maximumZoomScale;
        CGSize scrollViewSize = self.bounds.size;
        CGFloat w = scrollViewSize.width / newZoomScale;
        CGFloat h = scrollViewSize.height / newZoomScale;
        CGFloat x = point.x - (w / 2.0f);
        CGFloat y = point.y - (h / 2.0f);
        CGRect rectToZoomTo = CGRectMake(x, y, w, h);
        
        [self zoomToRect:rectToZoomTo animated:YES];
        
        if ([self.gestureDelegate respondsToSelector:@selector(didDoubleTapWithImageAssetScrollView:)])
            [self.gestureDelegate didDoubleTapWithImageAssetScrollView:self];
    }
}

- (void)tapped:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded &&
        [self.gestureDelegate respondsToSelector:@selector(didTapWithImageAssetScrollView:)])
        [self.gestureDelegate didTapWithImageAssetScrollView:self];
}

@end
