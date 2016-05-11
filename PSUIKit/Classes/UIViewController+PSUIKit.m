//
//  UIViewController+PSUIKit.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "UIViewController+PSUIKit.h"

@implementation UIViewController (org_apache_PSUIKit_UIViewController)

@dynamic dataLoading, firstLoading, relativeController;

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public class methods

+ (instancetype)controller
{
    return [[self class] controllerWithViewName:[NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"Controller" withString:@""]];
}

+ (instancetype)controllerWithBundle:(NSBundle *)bundle
{
    return [[self class] controllerWithViewName:[NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"Controller" withString:@""] bundle:bundle];
}

+ (instancetype)controllerWithViewName:(NSString *)viewName
{
    return [[self class] controllerWithViewName:viewName suffix:"Controller" bundle:[NSBundle mainBundle]];
}

+ (instancetype)controllerWithViewName:(NSString *)viewName bundle:(NSBundle *)bundle
{
    return [[self class] controllerWithViewName:viewName suffix:"Controller" bundle:bundle];
}

+ (instancetype)controllerWithViewName:(NSString *)viewName suffix:(char *)suffix bundle:(NSBundle *)bundle
{
    NSString *controllerName = suffix ? [NSString stringWithFormat:@"%@%s", viewName, suffix] : viewName;
    UIViewController *controller = [[NSClassFromString(controllerName) alloc] initWithNibName:viewName bundle:bundle];
    
    if ([controller respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        controller.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([controller respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)])
        controller.extendedLayoutIncludesOpaqueBars = YES;
    
    return controller;
}

#pragma mark - Public getter/setter

- (void)setDataLoading:(BOOL)dataLoading {
    if (dataLoading == [self dataLoading])
        return;
    
    objc_setAssociatedObject(self, @"dataLoading", @(dataLoading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)dataLoading {
    return [objc_getAssociatedObject(self, @"dataLoading") boolValue];
}

- (void)setFirstLoading:(BOOL)firstLoading {
    if (firstLoading == [self isFirstLoading])
        return;
    
    objc_setAssociatedObject(self, @"firstLoading", @(firstLoading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isFirstLoading {
    id object = objc_getAssociatedObject(self, @"firstLoading");
    return object ? [object boolValue] : YES;
}

- (void)setRelativeController:(UIViewController *)relativeController
{
    if ([relativeController isEqual:[self relativeController]])
        return;
    objc_setAssociatedObject(self, @"relativeControllerKey", relativeController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)relativeController
{
    return objc_getAssociatedObject(self, @"relativeControllerKey");
}

- (CGRect)statusBarFrame
{
    return [UIApplication sharedApplication].statusBarFrame;
}

- (UIViewController *)topMostController
{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topParentViewController {
    UIViewController *target = self;
    
    while (target.parentViewController) {
        target = target.parentViewController;
    }
    
    return target;
}

- (UIWindow *)topWindow
{
    return [UIApplication sharedApplication].windows.lastObject;
}

#pragma mark - Public methods

- (BOOL)close
{
    return [self closeAnimated:YES];
}

- (BOOL)closeAnimated:(BOOL)animated
{
    return [self closeAnimated:animated completion:nil];
}

- (BOOL)closeAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    BOOL canClosed = (!self.presentedViewController.isBeingDismissed && !self.isBeingDismissed);
    
    if (canClosed)
    {
        __weak UIViewController *_self = self;
        
        void (^_completion)(void) = ^void {
            [[NSNotificationCenter defaultCenter] postNotificationName:didCloseViewNotification object:_self];
            
            if (completion)
                completion();
        };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:willCloseViewNotification object:self];
        
        if ([self isKindOfClass:[UINavigationController class]])
        {
            [self dismissViewControllerAnimated:animated completion:_completion];
            
            for (UIViewController *controller in ((UINavigationController *) self).viewControllers)
                [controller closeAnimated:NO];
        }
        else
        {
            NSArray *viewControllers = self.navigationController.viewControllers;
            
            if (viewControllers.count > 1)
            {
                [self.navigationController popViewControllerAnimated:animated];
                _completion();
            }
            else
            {
                if (self.relativeController)
                    [self.relativeController dismissViewControllerAnimated:animated completion:_completion];
                else
                    [self dismissViewControllerAnimated:animated completion:_completion];
            }
        }
    }
    
    return canClosed;
}

- (void)dismissAllModalController
{
    UIViewController *vc = self;
    while (vc)
    {
        UIViewController *temp = vc.presentingViewController;
        if (!temp.presentedViewController)
        {
            [vc closeAnimated:NO];
            break;
        }
        vc =  temp;
    }
}

- (void)endDataLoading {
    if (self.dataLoading) {
        self.dataLoading = NO;
        self.firstLoading = NO;
    }
}

- (BOOL)invalidDataLoading {
    if (self.dataLoading)
        return YES;
    
    self.dataLoading = YES;
    
    return NO;
}

- (void)resetDataLoading {
    self.dataLoading = NO;
    self.firstLoading = YES;
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:[navigationController.viewControllers lastObject]];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

- (void)updateBarButtonItems:(UIInterfaceOrientation)interfaceOrientation
{
    UIButton *button;
    CGRect buttonFrame;
    if ([self.navigationItem getLeftBarButtonItem].customView && [[self.navigationItem getLeftBarButtonItem].customView isKindOfClass:[UIButton class]])
    {
        button = (UIButton *) [self.navigationItem getLeftBarButtonItem].customView;
        [button updateView:interfaceOrientation];
        buttonFrame = button.frame;
        buttonFrame.size.height = button.currentBackgroundImage.size.height;
        button.frame = buttonFrame;
    }
    
    if ([self.navigationItem getRightBarButtonItem].customView && [[self.navigationItem getRightBarButtonItem].customView isKindOfClass:[UIButton class]])
    {
        button = (UIButton *) [self.navigationItem getRightBarButtonItem].customView;
        [button updateView:interfaceOrientation];
        buttonFrame = button.frame;
        buttonFrame.size.height = button.currentBackgroundImage.size.height;
        button.frame = buttonFrame;
    }
}

@end
