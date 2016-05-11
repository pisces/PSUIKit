//
//  AbstractModalTransitionAnimator.h
//  PSUIKit
//
//  Created by pisces on 2015. 9. 24..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AbstractModalTransitionAnimatorProtected <NSObject>
- (void)animateTransitionForDismission:(id <UIViewControllerContextTransitioning>)transitionContext;
- (void)animateTransitionForPresenting:(id <UIViewControllerContextTransitioning>)transitionContext;
@end

@interface AbstractModalTransitionAnimator : NSObject <AbstractModalTransitionAnimatorProtected, UIViewControllerAnimatedTransitioning>
{
@protected
    UIViewController *fromViewController;
    UIViewController *toViewController;
}
@property (nonatomic) BOOL presenting;
@end
