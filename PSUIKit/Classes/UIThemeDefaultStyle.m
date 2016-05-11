//
//  UIThemeDefaultStyle.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "UIThemeDefaultStyle.h"

@implementation UIThemeDefaultStyle

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public class methods

+ (UIThemeDefaultStyle *)sharedTheme {
    static UIThemeDefaultStyle *instance;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

- (CGFloat)navigationBarBackgroundAlpha {
    return 1.0f;
}

- (UIColor *)navigationBarBarTintColor {
    return [UIColor whiteColor];
}

#pragma mark - Public methods

- (UIBarButtonItem *)backArrowBarButtonItemWithTarget:(id)target action:(SEL)action
{
    return [self barButtonItemWithObject:[ImageNameObject objectWithImageName:@"PSUIKit.bundle/icon_navi_back_white_normal" hightedImageName:nil] target:target action:action];
}

- (UIBarButtonItem *)backCollectionBarButtonItemWithTarget:(id)target action:(SEL)action
{
    return [self barButtonItemWithObject:[ImageNameObject objectWithImageName:@"PSUIKit.bundle/icon_navi_collection_back_normal" hightedImageName:nil] target:target action:action];
}

- (UIBarButtonItem *)blueBackArrowBarButtonItemWithTarget:(id)target action:(SEL)action
{
    return [self barButtonItemWithObject:[ImageNameObject objectWithImageName:@"PSUIKit.bundle/icon_navi_back_blue_normal" hightedImageName:nil] target:target action:action];
}

- (UIBarButtonItem *)closeBarButtonItemWithTarget:(id)target action:(SEL)action
{
    return [self barButtonItemWithObject:[ImageNameObject objectWithImageName:@"PSUIKit.bundle/icon_navi_close_normal" hightedImageName:nil] target:target action:action];
}

@end