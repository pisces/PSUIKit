//
//  ScaleModalTransitionAnimator.m
//  orcller
//
//  Created by pisces on 2015. 9. 22..
//  Copyright (c) 2015년 orcllercorp. All rights reserved.
//

#import "DragDropModalTransitionAnimator.h"
#import "PSUIKit.h"

@implementation DragDropModalTransitionSource

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public methods

- (void)clear {
    self.from = nil;
    self.to = nil;
    self.completion = nil;
}

- (DragDropModalTransitionSource *)from:(DragDropModalTransitionSourceBlock)from to:(DragDropModalTransitionSourceBlock)to completion:(DragDropModalTransitionCompletionBlock)completion {
    self.from = from;
    self.to = to;
    self.completion = completion;
    return self;
}

@end

@implementation DragDropModalTransitionAnimator

// ================================================================================================
//  Overridden: AbstractModalTransitionAnimator
// ================================================================================================

#pragma mark - Overridden: AbstractModalTransitionAnimator

- (void)animateTransitionForDismission:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIImageView *imageView = self.dismissiontImageView ? self.dismissiontImageView : [self createImageView];
    
    [toViewController viewWillAppear:YES];
    
    if (!self.dismissiontImageView)
        [fromViewController.view.window addSubview:imageView];
    
    toViewController.view.hidden = NO;
    CGRect to = self.transitionSource.to();
    toViewController.view.window.backgroundColor = [UIColor blackColor];
    
    if (toViewController.view.alpha <= 0)
        toViewController.view.transform = CGAffineTransformMakeScale(0.94, 0.94);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:animationOptions animations:^{
        imageView.frame = to;
        fromViewController.view.alpha = 0;
        toViewController.view.alpha = 1;
        toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    } completion:^(BOOL finished) {
        toViewController.view.userInteractionEnabled = YES;
        toViewController.view.window.backgroundColor = [UIColor whiteColor];
        
        [imageView removeFromSuperview];
        [fromViewController.view removeFromSuperview];
        [toViewController viewDidAppear:YES];
        [transitionContext completeTransition:YES];
        
        self.transitionSource.completion();
        
        [self clear];
    }];
}

- (void)animateTransitionForPresenting:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIImageView *imageView = [self createImageView];
    
    fromViewController.view.userInteractionEnabled = NO;
    fromViewController.view.window.backgroundColor = [UIColor blackColor];
    
    [fromViewController.view.window addSubview:imageView];
    [transitionContext.containerView addSubview:toViewController.view];
    [fromViewController viewWillDisappear:YES];
    [toViewController viewWillAppear:YES];
    
    toViewController.view.alpha = 0;
    toViewController.view.frame = fromViewController.view.bounds;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:animationOptions animations:^{
        imageView.frame = self.transitionSource.to();
        toViewController.view.alpha = 1;
        fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        fromViewController.view.transform = CGAffineTransformMakeScale(0.94, 0.94);
    } completion:^(BOOL finished) {
        [fromViewController viewDidDisappear:YES];
        [toViewController viewDidAppear:YES];
        [transitionContext completeTransition:YES];
        
        fromViewController.view.hidden = YES;
        fromViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [imageView removeFromSuperview];
            
            self.transitionSource.completion();
            
            [self clear];
        });
    }];
}

// ================================================================================================
//  Protected
// ================================================================================================

#pragma mark - Protected methods

- (void)clear {
    [self.transitionSource clear];
    
    self.transitionSource = nil;
}

- (UIMaskedImageView *)createImageView {
    UIMaskedImageView *imageView = [[UIMaskedImageView alloc] initWithFrame:self.transitionSource.from()];
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = self.sourceImage;
    return imageView;
}
                                     
@end