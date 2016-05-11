//
//  ActivityIndicatorManager.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "base.h"

typedef NS_ENUM(int, ActivityIndicatorLayoutStyle) {
    ActivityIndicatorLayoutStyleCenter,
    ActivityIndicatorLayoutStyleTop
};

@interface ActivityIndicatorManager : NSObject
+ (void)activate:(UIView *)view activityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle message:(NSString *)message offset:(CGPoint)offset modal:(BOOL)modal;
+ (void)activate:(UIView *)view message:(NSString *)message offset:(CGPoint)offset modal:(BOOL)modal;
+ (void)activate:(UIView *)view activityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle message:(NSString *)message modal:(BOOL)modal;
+ (void)activate:(UIView *)view message:(NSString *)message modal:(BOOL)modal;
+ (void)activate:(UIView *)view offset:(CGPoint)offset modal:(BOOL)modal;
+ (void)activate:(UIView *)view activityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle modal:(BOOL)modal;
+ (void)activate:(UIView *)view modal:(BOOL)modal;
+ (BOOL)contains:(UIView *)view;
+ (void)deactivate:(UIView *)view;
+ (void)initialize;
+ (UILabel *)label:(UIView *)view;
+ (UIActivityIndicatorView *)indicator:(UIView *)view;
+ (UIView *)modalView:(UIView *)view;
+ (void)layout:(UIView *)view;
+ (void)layout:(UIView *)view layoutStyle:(ActivityIndicatorLayoutStyle)layoutStyle;
+ (void)setMessage:(UIView *)view text:(NSString *)text;
+ (void)setMessage:(UIView *)view text:(NSString *)text layoutStyle:(ActivityIndicatorLayoutStyle)layoutStyle;
@end