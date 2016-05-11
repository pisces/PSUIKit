//
//  UIViewController+PSUIKit.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UIButton+PSUIKit.h"
#import "UINavigationItem+PSUIKit.h"

#define didCloseViewNotification @"didCloseViewNotification"
#define willCloseViewNotification @"willCloseViewNotification"

@interface UIViewController (org_apache_PSUIKit_UIViewController)
@property (nonatomic, readonly) BOOL dataLoading;
@property (nonatomic, readonly, getter=isFirstLoading) BOOL firstLoading;
@property (nonatomic, strong) UIViewController *relativeController;
@property (nonatomic, readonly) CGRect statusBarFrame;
@property (nonatomic, readonly) UIWindow *topWindow;
+ (instancetype)controller;
+ (instancetype)controllerWithBundle:(NSBundle *)bundle;
+ (instancetype)controllerWithViewName:(NSString *)viewName;
+ (instancetype)controllerWithViewName:(NSString *)viewName bundle:(NSBundle *)bundle;
+ (instancetype)controllerWithViewName:(NSString *)viewName suffix:(char *)suffix bundle:(NSBundle *)bundle;
- (BOOL)close;
- (BOOL)closeAnimated:(BOOL)animated;
- (BOOL)closeAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissAllModalController;
- (void)endDataLoading;
- (BOOL)invalidDataLoading;
- (void)resetDataLoading;
- (UIViewController *)topMostController;
- (UIViewController *)topParentViewController;
- (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController;
- (void)updateBarButtonItems:(UIInterfaceOrientation)interfaceOrientation;
@end
