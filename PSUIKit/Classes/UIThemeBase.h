//
//  UITheme+Base.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIButton+PSUIKit.h"
#import "UINavigationController+PSUIKit.h"
#import "UIViewController+PSUIKit.h"

@protocol UIThemeProtocol <NSObject>
@required
- (UIBarButtonItem *)backBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (UIImage *)navigationBarBackgroundImage:(UIInterfaceOrientation)interfaceOrientation;
- (UIColor *)navigationBarBarTintColor;
- (UIColor *)navigationBarTintColor;
- (NSDictionary *)navigationBarTitleTextAttributes;
- (BOOL)navigationBarTranslucent;
- (UIBarButtonItem *)closeBarButtonItemWithTarget:(id)target action:(SEL)action;
- (UIBarButtonItem *)homeBarButtonItemWithTarget:(id)target action:(SEL)action;
- (UIBarButtonItem *)leftBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (UIBarButtonItem *)rightBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@optional
- (CGFloat)navigationBarBackgroundAlpha;
@end

@protocol UIThemeClient
@property (nonatomic, strong) id<UIThemeProtocol> theme;
@end

@interface UIApplication (UIThemeBase)
@property (nonatomic, strong) id<UIThemeProtocol> theme;
@end

@interface UIViewController (UIThemeBase)
- (void)navigationBack:(id)sender;
- (UIBarButtonItem *)setBackBarButtonItem;
- (UIBarButtonItem *)setBackBarButtonItemWithTheme:(id<UIThemeProtocol>)theme;
- (UIBarButtonItem *)setBackBarButtonItemWithTitle:(NSString *)title;
- (UIBarButtonItem *)setBackBarButtonItemWithTitle:(NSString *)title withTheme:(id<UIThemeProtocol>)theme;
@end

@interface ImageNameObject : NSObject
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *hightedImageName;
@property (nonatomic, strong) NSString *selectedImageName;
+ (ImageNameObject *)objectWithImageName:(NSString *)imageName hightedImageName:(NSString *)hightedImageName;
+ (ImageNameObject *)objectWithImageName:(NSString *)imageName hightedImageName:(NSString *)hightedImageName selectedImageName:(NSString *)selectedImageName;
@end

@protocol UIThemeBaseProtected
- (UIBarButtonItem *)barButtonItemWithObject:(ImageNameObject *)object target:(id)target action:(SEL)action;
@end

@interface UIThemeBase : NSObject <UIThemeProtocol, UIThemeBaseProtected>
+ (UIThemeBase *)sharedTheme;
- (UIButton *)navigationButton:(NSString *)title imageName:(NSString *)imageName imageNameForLandscape:(NSString *)imageNameForLandscape textColor:(UIColor *)textColor target:(id)target action:(SEL)action;
- (void)updateView:(UIButton *)button taget:(id)target;
@end