//
//  AbstractModalNavigationController.m
//  PSUIKit
//
//  Created by pisces on 2015. 9. 24..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "AbstractModalNavigationController.h"
#import "PSUIKit.h"

@interface AbstractModalNavigationController ()

@end

@implementation AbstractModalNavigationController
{
@private
    BOOL keyboardShowing;
}

// ================================================================================================
//  Overridden: PSNavigationController
// ================================================================================================

#pragma mark -  Overridden: PSNavigationController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allowsGestureTransitions = YES;
    self.bounceHeight = 100;
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    
    [self.view addGestureRecognizer:gestureRecognizer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

// ================================================================================================
//  Protocol Implementation
// ================================================================================================

#pragma mark - UIViewControllerTransitioning delegate

- (void)animateTransitionForDismission:(id<UIViewControllerContextTransitioning>)transitionContext {
}

- (void)animateTransitionForPresenting:(id<UIViewControllerContextTransitioning>)transitionContext {
}

// ================================================================================================
//  Protected
// ================================================================================================

#pragma mark - Protected methods

/**
 * @abstract
 */
- (void)animateTransitionBegan:(UIPanGestureRecognizer *)gestureRecognizer {
}

/**
 * @abstract
 */
- (void)animateTransitionCancelled:(UIPanGestureRecognizer *)gestureRecognizer {
}

/**
 * @abstract
 */
- (void)animateTransitionChanged:(UIPanGestureRecognizer *)gestureRecognizer {
}

/**
 * @abstract
 */
- (void)animateTransitionCancelCompleted {
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark -  UIGestureRecognizer selector

- (void)panned:(UIPanGestureRecognizer *)gestureRecognizer {
    if (!self.allowsGestureTransitions)
            return;
    
    if (gestureRecognizer.numberOfTouches > 1 ||
        keyboardShowing ||
        ([self.sourceDelegate respondsToSelector:@selector(shouldRequireTransitionFailure)] && ![self.sourceDelegate shouldRequireTransitionFailure]))
        return;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        originPoint = [gestureRecognizer locationInView:self.view.window];
        originViewPoint = self.view.origin;
        
        [self animateTransitionBegan:gestureRecognizer];
        [self.sourceDelegate didBeginTransition];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [self animateTransitionChanged:gestureRecognizer];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
               gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        CGPoint p = [gestureRecognizer locationInView:self.view.window];
        CGFloat y = originViewPoint.y + (p.y - originPoint.y);
        
        if (ABS(y) > self.bounceHeight) {
            [self closeAnimated:YES completion:^{
                [self.sourceDelegate didEndTransition];
            }];
        } else {
            [UIView animateWithDuration:0.15 delay:0 options:animationOptions animations:^{
                [self animateTransitionCancelled:gestureRecognizer];
            } completion:^(BOOL finished) {
                [self animateTransitionCancelCompleted];
                [self.sourceDelegate didEndTransition];
            }];
        }
    }
}

#pragma mark - Notification selector

- (void)keyboardWillShow:(NSNotification *)notification {
    keyboardShowing = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    keyboardShowing = NO;
}

@end

@implementation UINavigationController (AbstractModalNavigationController)

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark -  Public getter/setter

- (BOOL)allowsGestureTransitions {
    return [objc_getAssociatedObject(self, @"kAllowsGestureTransitions") boolValue];
}

- (void)setAllowsGestureTransitions:(BOOL)allowsGestureTransitions {
    if (allowsGestureTransitions == [self allowsGestureTransitions])
        return;
    
    objc_setAssociatedObject(self, @"kAllowsGestureTransitions", @(allowsGestureTransitions), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end