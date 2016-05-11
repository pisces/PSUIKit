//
//  PSImageAssetScrollView.h
//  PSUIKit
//
//  Created by pisces on 2015. 7. 3..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "PSScrollView.h"

@protocol PSImageAssetScrollViewGestureDelegate;

@interface PSImageAssetScrollView : PSScrollView <UIScrollViewDelegate>
@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, weak) id<PSImageAssetScrollViewGestureDelegate> gestureDelegate;
- (void)resetZoomScale;
@end

@protocol PSImageAssetScrollViewGestureDelegate <NSObject>
@optional
- (void)didDoubleTapWithImageAssetScrollView:(PSImageAssetScrollView *)view;
- (void)didTapWithImageAssetScrollView:(PSImageAssetScrollView *)view;
@end