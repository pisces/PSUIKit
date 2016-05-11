//
//  AbstractModalTransitionAnimator.m
//  PSUIKit
//
//  Created by pisces on 2015. 9. 24..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "AbstractModalTransitionAnimator.h"

@implementation AbstractModalTransitionAnimator

// ================================================================================================
//  Protocol Implementation
// ================================================================================================

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.presenting) {
        [self animateTransitionForPresenting:transitionContext];
    } else {
        [self animateTransitionForDismission:transitionContext];
    }
}

// ================================================================================================
//  Protected
// ================================================================================================

#pragma mark - Protected methods

- (void)animateTransitionForDismission:(id<UIViewControllerContextTransitioning>)transitionContext {
}

- (void)animateTransitionForPresenting:(id<UIViewControllerContextTransitioning>)transitionContext {
}

@end
