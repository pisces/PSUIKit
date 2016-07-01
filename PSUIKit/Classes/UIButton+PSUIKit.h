//
//  UIButton+PSUIKit.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UIView+PSUIKit.h"
#import "UIViewController+PSUIKit.h"

@interface UIButton (org_apache_PSUIKit_UIButton)
@property (nonatomic, readonly) NSMutableDictionary *fontDictionary;
@property (nonatomic, readonly) NSMutableDictionary *resourceDictionary;
- (void)setBackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state;
- (void)setBackgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state forViewMetrics:(UIViewMatrics)viewMetrics;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state forViewMetrics:(UIViewMatrics)viewMetrics;
- (void)updateView;
- (void)updateView:(UIInterfaceOrientation)interfaceOrientation;
- (void)updateBackgroundImage;
- (void)updateBackgroundImage:(UIInterfaceOrientation)interfaceOrientation;
- (void)updateTitleColor;
- (void)updateTitleColor:(UIInterfaceOrientation)interfaceOrientation;
@end
