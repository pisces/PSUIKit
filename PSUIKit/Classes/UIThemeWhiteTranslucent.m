//
//  UIThemeWhiteTranslucent.m
//  PSUIKit
//
//  Created by pisces on 1/11/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

#import "UIThemeWhiteTranslucent.h"

@implementation UIThemeWhiteTranslucent

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public class methods

+ (UIThemeWhiteTranslucent *)sharedTheme {
    static UIThemeWhiteTranslucent *instance;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

#pragma mark - Public methods

- (CGFloat)navigationBarBackgroundAlpha {
    return 0.15f;
}

- (BOOL)navigationBarTranslucent {
    return NO;
}

@end
