//
//  UITheme+Base.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 11..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "UIThemeBase.h"
#import "base.h"
#import "PSUIKit.h"

@implementation UIApplication (UIThemeBase)

@dynamic theme;
- (void)setTheme:(id<UIThemeProtocol>)theme
{
    if (theme == [self theme])
        return;
    objc_setAssociatedObject(self, @"ThemeKey", theme, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIViewController *rootViewController = [[self.windows objectAtIndex:0] rootViewController];
    if (rootViewController)
    {
        if ([rootViewController isKindOfClass:[UITabBarController class]])
        {
            NSArray *viewControllers = ((UITabBarController *) rootViewController).viewControllers;
            for (UIViewController *childController in viewControllers)
            {
                if (childController.navigationController)
                    [childController.navigationController customize];
                else if ([childController isKindOfClass:[UINavigationController class]])
                    [((UINavigationController *) childController) customize];
            }
        }
        else
        {
            if (rootViewController.navigationController)
                [rootViewController.navigationController customize];
            else if ([rootViewController isKindOfClass:[UINavigationController class]])
                [((UINavigationController *) rootViewController) customize];
        }
    }
}

- (id<UIThemeProtocol>)theme
{
    return objc_getAssociatedObject(self, @"ThemeKey");
}
@end

// ================================================================================================
//
//  Category: UIViewController (UIThemeBase)
//
// ================================================================================================

@implementation UIViewController (UIThemeBase)

// ================================================================================================
//  Public
// ================================================================================================

- (UIBarButtonItem *)setBackBarButtonItem
{
    return [self setBackBarButtonItemWithTitle:self.navigationController.previousTitle];
}

- (UIBarButtonItem *)setBackBarButtonItemWithTheme:(id<UIThemeProtocol>)theme
{
    return [self setBackBarButtonItemWithTitle:self.navigationController.previousTitle withTheme:theme];
}

- (UIBarButtonItem *)setBackBarButtonItemWithTitle:(NSString *)title
{
    id<UIThemeProtocol> theme = [self.navigationController respondsToSelector:@selector(setTheme:)] && ((id<UIThemeClient>) self.navigationController).theme ? ((id<UIThemeClient>) self.navigationController).theme : [UIApplication sharedApplication].theme;
    return [self setBackBarButtonItemWithTitle:title withTheme:theme];
}

- (UIBarButtonItem *)setBackBarButtonItemWithTitle:(NSString *)title withTheme:(id<UIThemeProtocol>)theme
{
    UIBarButtonItem *leftBarButtonItem = [theme backBarButtonItemWithTitle:title target:self action:@selector(navigationBack:)];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        self.navigationController.previousViewController.navigationItem.backBarButtonItem = leftBarButtonItem;
    else
        [self.navigationItem addLeftBarButtonItem:leftBarButtonItem];
    return leftBarButtonItem;
}

- (void)navigationBack:(id)sender
{
    if ([self respondsToSelector:@selector(close)])
        [self close];
}

@end

// ================================================================================================
//
//  Implementation: UIThemeBase
//
// ================================================================================================

@implementation UIThemeBase

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public class methods

+ (UIThemeBase *)sharedTheme {
    static UIThemeBase *instance;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

#pragma mark - Public methods

- (UIBarButtonItem *)backBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    NSString *buttonTitle = title ? title : @"";
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        return [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStyleBordered target:target action:action];
    
    UIImage *image = [UIImage imageNamed:@"PSUIKit.bundle/btn_navi_back_flat_normal.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"PSUIKit.bundle/btn_navi_back_flat_selected.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.size = CGSizeMake(150, 30);
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateHighlighted];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6] forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (buttonTitle)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    
    button.size = CGSizeMake(image.size.width + button.imageEdgeInsets.right + button.titleLabel.width, 30);
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIImage *)navigationBarBackgroundImage:(UIInterfaceOrientation)interfaceOrientation
{
    return [UIImage imageWithColor:[self navigationBarBarTintColor]];
}

- (UIColor *)navigationBarBarTintColor
{
    return nil;
}

- (UIColor *)navigationBarTintColor
{
    return nil;
}

- (NSDictionary *)navigationBarTitleTextAttributes
{
    return nil;
}

- (BOOL)navigationBarTranslucent
{
    return YES;
}

- (UIBarButtonItem *)closeBarButtonItemWithTarget:(id)target action:(SEL)action
{
    return [self leftBarButtonItemWithTitle:[PSUIKit localizedStringWithKey:@"Dismiss"] target:target action:action];
}

- (UIBarButtonItem *)homeBarButtonItemWithTarget:(id)target action:(SEL)action
{
    return nil;
}

- (UIButton *)navigationButton:(NSString *)title imageName:(NSString *)imageName imageNameForLandscape:(NSString *)imageNameForLandscape textColor:(UIColor *)textColor target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal.png", imageName]] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *buttonPressedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected.png", imageName]] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *buttonDisabledImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_disabled.png", imageName]] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UIImage *buttonImageLandscape = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_landscape_normal.png", imageNameForLandscape]] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *buttonPressedImageLandscape = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_landscape_selected.png", imageNameForLandscape]] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *buttonDisabledImageLandscape = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_landscape_disabled.png", imageNameForLandscape]] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    CGFloat fontSize = 13.0;
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    
    [button setTitleColor:textColor forState:UIControlStateNormal forViewMetrics:UIViewMatricsNormal];
    [button setTitleColor:textColor forState:UIControlStateHighlighted forViewMetrics:UIViewMatricsNormal];
    [button setTitleColor:textColor forState:UIControlStateSelected forViewMetrics:UIViewMatricsNormal];
    [button setTitleColor:textColor forState:UIControlStateDisabled forViewMetrics:UIViewMatricsNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal forViewMetrics:UIViewMatricsLanscape];
    [button setTitleColor:textColor forState:UIControlStateHighlighted forViewMetrics:UIViewMatricsLanscape];
    [button setTitleColor:textColor forState:UIControlStateSelected forViewMetrics:UIViewMatricsLanscape];
    [button setTitleColor:textColor forState:UIControlStateDisabled forViewMetrics:UIViewMatricsLanscape];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal forViewMetrics:UIViewMatricsNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted forViewMetrics:UIViewMatricsNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected forViewMetrics:UIViewMatricsNormal];
    [button setBackgroundImage:buttonDisabledImage forState:UIControlStateDisabled forViewMetrics:UIViewMatricsNormal];
    [button setBackgroundImage:buttonImageLandscape forState:UIControlStateNormal forViewMetrics:UIViewMatricsLanscape];
    [button setBackgroundImage:buttonPressedImageLandscape forState:UIControlStateHighlighted forViewMetrics:UIViewMatricsLanscape];
    [button setBackgroundImage:buttonPressedImageLandscape forState:UIControlStateSelected forViewMetrics:UIViewMatricsLanscape];
    [button setBackgroundImage:buttonDisabledImageLandscape forState:UIControlStateDisabled forViewMetrics:UIViewMatricsLanscape];
    
    [self updateView:button taget:target];
    
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = fmaxf(40, [title sizeWithFont:[UIFont boldSystemFontOfSize:fontSize]].width + fontSize*2);
    buttonFrame.size.height = button.currentBackgroundImage.size.height;
    [button setFrame:buttonFrame];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIBarButtonItem *)leftBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:target action:action];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.size = CGSizeMake(150, 30);
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6] forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    button.size = button.titleLabel.size;
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIBarButtonItem *)rightBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:target action:action];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.size = CGSizeMake(150, 30);
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6] forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    button.size = button.titleLabel.size;
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)updateView:(UIButton *)button taget:(id)target
{
    if ([target isKindOfClass:[UIViewController class]])
    {
        UIViewController *viewController = (UIViewController *) target;
        [button updateView:viewController.interfaceOrientation];
    }
    else
    {
        [button updateView];
    }
}

// ================================================================================================
//  Protected
// ================================================================================================

#pragma mark - Protected methods

- (UIBarButtonItem *)barButtonItemWithObject:(ImageNameObject *)object target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = object.imageName ? [UIImage imageNamed:object.imageName] : nil;
    UIImage *highlightedBackgroundImage = object.hightedImageName ? [UIImage imageNamed:object.hightedImageName] : nil;
    UIImage *selectedBackgroundImage = object.selectedImageName ? [UIImage imageNamed:object.selectedImageName] : nil;
    button.size = buttonImage.size;
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end

// ================================================================================================
//
//  ImageNameObject
//
// ================================================================================================

@implementation ImageNameObject
+ (ImageNameObject *)objectWithImageName:(NSString *)imageName hightedImageName:(NSString *)hightedImageName
{
    ImageNameObject *object = [[ImageNameObject alloc] init];
    object.imageName = imageName;
    object.hightedImageName = hightedImageName;
    return object;
}

+ (ImageNameObject *)objectWithImageName:(NSString *)imageName hightedImageName:(NSString *)hightedImageName selectedImageName:(NSString *)selectedImageName
{
    ImageNameObject *object = [[ImageNameObject alloc] init];
    object.imageName = imageName;
    object.hightedImageName = hightedImageName;
    object.selectedImageName = selectedImageName;
    return object;
}

- (void)dealloc
{
    _imageName = nil;
    _hightedImageName = nil;
}
@end