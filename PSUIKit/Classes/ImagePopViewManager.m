//
//  ImagePopViewManager.m
//  PSUIKit
//
//  Created by Steve Kim on 2015. 6. 23..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "ImagePopViewManager.h"
#import "PSUIKit.h"
#import "UIMaskedImageView.h"

@implementation ImagePopViewManager
{
@private
    UIView *targetView;
    UIImageView *tempImageView;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public class methods

+ (ImagePopViewManager *)sharedManager {
    static ImagePopViewManager *instance;
    static dispatch_once_t precated;
    
    dispatch_once(&precated, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

#pragma mark - Public methods

- (void)hide
{
    [self removeTempImageView];
    
    targetView = nil;
    _showing = NO;
}

- (void)hideWithTarget:(UIImageView *)target from:(CGRect)from to:(CGRect)to {
    [self hideWithTarget:target from:from to:to completion:nil];
}

- (void)hideWithTarget:(UIImageView *)target from:(CGRect)from to:(CGRect)to completion:(void (^)(void))completion {
    [self hideWithTarget:target from:from to:to animated:YES completion:completion];
}

- (void)hideWithTarget:(UIImageView *)target from:(CGRect)from to:(CGRect)to animated:(BOOL)animated {
    [self hideWithTarget:target from:from to:to animated:animated completion:nil];
}

- (void)hideWithTarget:(UIImageView *)target from:(CGRect)from to:(CGRect)to animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!self.showing)
        return;
    
    if (animated) {
        tempImageView.image = target.image;
        tempImageView.frame = from;
        tempImageView.alpha = 1;
        tempImageView.hidden = NO;
        tempImageView.clipsToBounds = YES;
        
        [UIView animateWithDuration:0.5 delay:0 options:animationOptions animations:^{
            tempImageView.frame = to;
        } completion:^(BOOL finished) {
            [self hide];
            
            if (completion)
                completion();
        }];
    } else {
        [self hide];
        
        if (completion)
            completion();
    }
}

- (void)showInView:(UIView *)view source:(CGImageRef)source from:(CGRect)from to:(CGRect)to animations:(void (^)(UIImageView *))animations completion:(void (^)(UIImageView *))completion {
    if (!source)
        return;
    
    if (self.showing)
        [self hide];
    
    _showing = YES;
    targetView = view;
    
    tempImageView = [[UIMaskedImageView alloc] initWithFrame:from];
    tempImageView.clipsToBounds = YES;
    tempImageView.backgroundColor = [UIColor clearColor];
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    tempImageView.image = [UIImage imageWithCGImage:source];
    
    [view.window addSubview:tempImageView];
    [UIView animateWithDuration:0.5 delay:0 options:animationOptions animations:^{
        tempImageView.frame = to;
        
        if (animations)
            animations(tempImageView);
    } completion:^(BOOL finished) {
        if (completion)
            completion(tempImageView);
    }];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (void)removeTempImageView {
    [tempImageView removeFromSuperview];
    
    tempImageView = nil;
}

@end