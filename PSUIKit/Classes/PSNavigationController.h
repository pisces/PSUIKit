//
//  PSNavigationController.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import <objc/runtime.h>
#import "GraphicsLayout.h"
#import "UIButton+PSUIKit.h"
#import "UIThemeBase.h"

@interface UINavigationController (org_apache_PSUIKit_PSUINavigationController)
@property (nonatomic, strong) id<UIThemeProtocol> theme;
@end

@interface UINavigationBar (org_apache_PSUIKit_UINavigationBar)
@property (nonatomic, readonly) UIView *backgroundView;
@end

@interface PSNavigationController : UINavigationController <UIGestureRecognizerDelegate>
@end