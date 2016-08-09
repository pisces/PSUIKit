//
//  PSNavigationController.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "base.h"
#import "PSNavigationController.h"

static char const * const PreviousTitleKey = "PreviousTitle";
static char const * const PreviousViewControllerKey = "PreviousViewController";
static char const * const ThemeKey = "Theme";

// ================================================================================================
//
//  Category: UINavigationController (org_apache_PSUIKit_UINavigationController)
//
// ================================================================================================

@implementation UINavigationController (org_apache_PSUIKit_UINavigationController)

@dynamic previousTitle, previousViewController;

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public methods

- (id)newInstanceWithRootViewController:(UIViewController *)controller
{
    UINavigationController *newInstance = [[[self class] alloc] initWithRootViewController:controller];
    newInstance.theme = self.theme;
    return newInstance;
}

#pragma mark - Public getter/setter

- (void)setPreviousTitle:(NSString *)title
{
    if ([title isEqual:[self previousTitle]])
        return;
    
    objc_setAssociatedObject(self, PreviousTitleKey, title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)previousTitle
{
    return objc_getAssociatedObject(self, PreviousTitleKey);
}

- (void)setPreviousViewController:(UIViewController *)previousViewController
{
    if ([previousViewController isEqual:[self previousViewController]])
        return;
    
    objc_setAssociatedObject(self, PreviousViewControllerKey, previousViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)previousViewController
{
    return objc_getAssociatedObject(self, PreviousViewControllerKey);
}

- (void)customize
{
}

- (void)customize:(UIInterfaceOrientation)toInterfaceOrientation
{
}
@end

// ================================================================================================
//
//  Category: UINavigationController (org_apache_PSUIKit_PSUINavigationController)
//
// ================================================================================================

@implementation UINavigationController (org_apache_PSUIKit_PSUINavigationController)

@dynamic theme;

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (void)setTheme:(id<UIThemeProtocol>)theme
{
    if ([((NSObject *) theme) isEqual:[self theme]])
        return;
    
    objc_setAssociatedObject(self, ThemeKey, theme, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self customize];
}

- (UIThemeBase *)theme
{
    return objc_getAssociatedObject(self, ThemeKey);
}

@end

// ================================================================================================
//
//  Category: UINavigationBar (org_apache_PSUIKit_PSUINavigationController)
//
// ================================================================================================

@implementation UINavigationBar (org_apache_PSUIKit_UINavigationBar)
- (UIView *)backgroundView
{
    for (UIView *subview in self.subviews)
    {
        NSString *className = NSStringFromClass([subview class]);
        
        if ([className isEqualToString:@"_UINavigationBarBackground"] || [className isEqualToString:@"UINavigationBarBackground"])
            return subview;
    }
    
    return nil;
}
@end

// ================================================================================================
//
//  Implementation: PSNavigationController
//
// ================================================================================================

@implementation PSNavigationController
{
@private
    UIStatusBarStyle orgStatusBarStyle;
}

// ================================================================================================
//  Overridden: UINavigationController
// ================================================================================================

#pragma mark - Overridden: UINavigationController

- (void)dealloc {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customize];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)])
        self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.interactivePopGestureRecognizer.delegate = self;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.viewControllers.count > 0 ? [self.viewControllers.lastObject supportedInterfaceOrientations] : UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return self.viewControllers.count > 0 ? [self.viewControllers.lastObject shouldAutorotate] : NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return self.viewControllers.count > 0 ? [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation] : UIInterfaceOrientationPortrait;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.viewControllers.count > 1;
}

// ================================================================================================
//  Public
// ================================================================================================

- (void)customize
{
    [self customize:self.interfaceOrientation];
}

- (void)customize:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (!self.isViewLoaded)
        return;
        
    id currentTheme = self.theme ? self.theme : [UIApplication sharedApplication].theme;
    
    if (!currentTheme)
        return;
    
    self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    self.navigationBar.width = self.view.width;
    self.navigationBar.tintColor = [currentTheme navigationBarTintColor];
    self.navigationBar.titleTextAttributes = [currentTheme navigationBarTitleTextAttributes];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationBar.barTintColor = [currentTheme navigationBarBarTintColor];
        self.navigationBar.translucent = [currentTheme navigationBarTranslucent];
    }
    else
    {
        UIImage *backgroundImage = [currentTheme navigationBarBackgroundImage:UIInterfaceOrientationPortrait];
        UIImage *backgroundImageForLandscape = [currentTheme navigationBarBackgroundImage:UIInterfaceOrientationLandscapeLeft];
        
        [self.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setBackgroundImage:backgroundImageForLandscape forBarMetrics:UIBarMetricsLandscapePhone];
    }
    
    if ([currentTheme respondsToSelector:@selector(navigationBarBackgroundAlpha)])
        self.navigationBar.backgroundView.alpha = [currentTheme navigationBarBackgroundAlpha];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self setPreviousTitle:self.visibleViewController.navigationItem.title];
    [self setPreviousViewController:self.visibleViewController];
    
    [super pushViewController:viewController animated:animated];
}

@end
