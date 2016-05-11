//
//  DragDropModalNavigationController.m
//  orcller
//
//  Created by pisces on 2015. 9. 22..
//  Copyright (c) 2015년 orcllercorp. All rights reserved.
//

#import "DragDropModalNavigationController.h"
#import "PSUIKit.h"

@interface DragDropModalNavigationController ()
@end

@implementation DragDropModalNavigationController

@synthesize sourceDelegate;

// ================================================================================================
//  Overridden: AbstractModalNavigationController
// ================================================================================================

#pragma mark - Overridden: AbstractModalNavigationController

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    DragDropModalTransitionAnimator *animator = [DragDropModalTransitionAnimator new];
    animator.transitionSource = self.dismissionSource;
    animator.dismissiontImageView = dismissionImageView;
    
    if ([self.childViewControllers.firstObject conformsToProtocol:@protocol(DragDrapModalNavigationControllerDelegate)]) {
        id<DragDrapModalNavigationControllerDelegate> delegate = (id<DragDrapModalNavigationControllerDelegate>) self.childViewControllers.firstObject;
        animator.sourceImage = [delegate sourceImageForDismission];
    }
    
    dismissionImageView = nil;
    
    return animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    DragDropModalTransitionAnimator *animator = [DragDropModalTransitionAnimator new];
    animator.presenting = YES;
    animator.transitionSource = self.presentingSource;
    animator.sourceImage = self.sourceImage;
    return animator;
}

- (void)animateTransitionBegan:(UIPanGestureRecognizer *)gestureRecognizer {
    UIImage *dismissionImage = [self.sourceDelegate respondsToSelector:@selector(sourceImageForDismission)] ? [self.sourceDelegate sourceImageForDismission] : nil;
    
    if (dismissionImage) {
        dismissionImageView = [[UIMaskedImageView alloc] initWithImage:dismissionImage];
        dismissionImageView.contentMode = UIViewContentModeScaleAspectFill;
        dismissionImageView.clipsToBounds = YES;
        
        if ([self.sourceDelegate respondsToSelector:@selector(sourceImageRectForDismission)])
            dismissionImageView.frame = [self.sourceDelegate sourceImageRectForDismission];
        
        originDismissionImageViewPoint = dismissionImageView.origin;
        
        [self.view.window addSubview:dismissionImageView];
    }
    
    self.view.window.backgroundColor = [UIColor blackColor];
    self.presentingViewController.view.transform = CGAffineTransformMakeScale(0.94, 0.94);
}

- (void)animateTransitionCancelled:(UIPanGestureRecognizer *)gestureRecognizer {
    self.view.alpha = 1;
    self.navigationBar.alpha = 1;
    self.presentingViewController.view.alpha = 0;
    self.presentingViewController.view.transform = CGAffineTransformMakeScale(0.94, 0.94);
    dismissionImageView.origin = originDismissionImageViewPoint;
}

- (void)animateTransitionChanged:(UIPanGestureRecognizer *)gestureRecognizer {
    [UIView animateWithDuration:0.15 delay:0 options:animationOptions animations:^{
        self.navigationBar.alpha = 0;
    } completion:nil];
    
    self.presentingViewController.view.hidden = NO;
    CGPoint p = [gestureRecognizer locationInView:self.view.window];
    CGFloat y = originViewPoint.y + (p.y - originPoint.y);
    CGFloat alpha = MIN(0.5, 0.5 * ABS(y) / self.bounceHeight);
    CGFloat scale = MIN(1, 0.94 + ((1 - 0.94) * ABS(y) / self.bounceHeight));
    self.presentingViewController.view.alpha = alpha;
    self.presentingViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
    self.view.alpha = 1 - alpha;
    
    [dismissionImageView setX:originDismissionImageViewPoint.x + (p.x - originPoint.x) y:originDismissionImageViewPoint.y + (p.y - originPoint.y)];
}

- (void)animateTransitionCancelCompleted {
    self.presentingViewController.view.hidden = YES;
    self.presentingViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    originDismissionImageViewPoint = CGPointZero;
    
    [dismissionImageView removeFromSuperview];
}

@end
