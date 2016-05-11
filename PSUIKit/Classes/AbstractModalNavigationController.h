//
//  AbstractModalNavigationController.h
//  PSUIKit
//
//  Created by pisces on 2015. 9. 24..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "PSNavigationController.h"
#import <objc/runtime.h>

@protocol AbstractModalNavigationControllerProtected <NSObject>
- (void)animateTransitionBegan:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)animateTransitionCancelled:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)animateTransitionChanged:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)animateTransitionCancelCompleted;
@end

@protocol ModalNavigationControllerDelegate;

@interface AbstractModalNavigationController : PSNavigationController <AbstractModalNavigationControllerProtected, UIViewControllerTransitioningDelegate>
{
@protected
    CGPoint originPoint;
    CGPoint originViewPoint;
}

@property (nonatomic) CGFloat bounceHeight;
@property (nonatomic, weak) id<ModalNavigationControllerDelegate> sourceDelegate;
@end

@protocol ModalNavigationControllerDelegate <NSObject>
@optional
- (void)didBeginTransition;
- (void)didEndTransition;
- (BOOL)shouldRequireTransitionFailure;
@end

@interface UINavigationController (AbstractModalNavigationController)
@property (nonatomic) BOOL allowsGestureTransitions;
@end