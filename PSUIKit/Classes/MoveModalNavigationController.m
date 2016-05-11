//
//  MoveModalNavigationController.m
//  PSUIKit
//
//  Created by pisces on 2015. 9. 24..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "MoveModalNavigationController.h"

@interface MoveModalNavigationController ()
@end

@implementation MoveModalNavigationController
{
@private
    UIStatusBarStyle originStatusBarStyle;
}

// ================================================================================================
//  Overridden: AbstractModalNavigationController
// ================================================================================================

#pragma mark - Overridden: AbstractModalNavigationController

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [MoveModalTransitionAnimator new];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    MoveModalTransitionAnimator *animator = [MoveModalTransitionAnimator new];
    animator.presenting = YES;
    return animator;
}

- (void)animateTransitionBegan:(UIPanGestureRecognizer *)gestureRecognizer {
    [super animateTransitionBegan:gestureRecognizer];
    
    originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    self.view.window.backgroundColor = [UIColor blackColor];
    self.presentingViewController.view.transform = CGAffineTransformMakeScale(0.94, 0.94);
}

- (void)animateTransitionCancelled:(UIPanGestureRecognizer *)gestureRecognizer {
    self.view.y = 0;
    self.presentingViewController.view.alpha = 0;
    self.presentingViewController.view.transform = CGAffineTransformMakeScale(0.94, 0.94);
    
    [UIApplication sharedApplication].statusBarStyle = self.view.y > self.statusBarFrame.size.height ? UIStatusBarStyleLightContent : originStatusBarStyle;
}

- (void)animateTransitionChanged:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.view.window];
    CGFloat y = originViewPoint.y + (p.y - originPoint.y);
    CGFloat alpha = MIN(0.5, 0.5 * ABS(y) / self.bounceHeight);
    CGFloat scale = MIN(1, 0.94 + ((1 - 0.94) * ABS(y) / self.bounceHeight));
    
    self.view.y = y;
    self.presentingViewController.view.hidden = NO;
    self.presentingViewController.view.alpha = alpha;
    self.presentingViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
    
    [UIApplication sharedApplication].statusBarStyle = self.view.y > self.statusBarFrame.size.height ? UIStatusBarStyleLightContent : originStatusBarStyle;
}

- (void)animateTransitionCancelCompleted {
    self.presentingViewController.view.hidden = YES;
    self.presentingViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.viewControllers.count > 0 ? [self.viewControllers.lastObject supportedInterfaceOrientations] : UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return self.viewControllers.count > 0 ? [self.viewControllers.lastObject shouldAutorotate] : NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.viewControllers.count > 0 ? [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation] : UIInterfaceOrientationPortrait;
}

@end
