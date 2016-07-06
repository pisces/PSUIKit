//
//  PSAlertView.h
//  PSUIKit
//
//  Created by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "PSAttributedDivisionLabel.h"
#import "GraphicsLayout.h"
#import "base.h"
#import "PSButtonBar.h"
#import "PSLinedBackgroundView.h"

@class PSAlertView;
@protocol PSAlertViewDelegate;

typedef void (^PSAlertViewDismission)(PSAlertView *alertView, NSInteger buttonIndex, BOOL cancel);

@interface PSAlertViewButtonBarLineView : PSView
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, weak) PSButtonBar *target;
@end

@interface PSAlertView : PSView <PSButtonBarDelegate>
@property (nonatomic) CGFloat buttonHeight;
@property (nonatomic) CGFloat headerViewHeight;
@property (nonatomic) CGPadding contentPadding;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, readonly) CGFloat contentViewHeight;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, readonly) PSAttributedDivisionLabel *titleLabel;
@property (nonatomic, readonly) UILabel *messageLabel;
@property (nonatomic, readonly) PSButtonBar *buttonBar;
@property (nonatomic, readonly) PSAlertViewButtonBarLineView *buttonBarLineView;
@property (nonatomic, strong) id<PSAlertViewDelegate> delegate;
+ (PSAlertView *)alertViewWithContentView:(UIView *)contentView cancelButtonTitle:(NSString *)cancelButtonTitle dismission:(PSAlertViewDismission)dismission otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles;
+ (PSAlertView *)alertViewWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle dismission:(PSAlertViewDismission)dismission otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles;
+ (PSAlertView *)alertViewWithTitle:(NSString *)title contentView:(UIView *)contentView cancelButtonTitle:(NSString *)cancelButtonTitle dismission:(PSAlertViewDismission)dismission otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles;
+ (PSAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle dismission:(PSAlertViewDismission)dismission otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles;
+ (void)dismissAll;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles;
- (void)show;
- (void)showWithDismission:(PSAlertViewDismission)dismission;
@end

@protocol PSAlertViewDelegate <NSObject>
@optional
- (void)PSAlertView:(PSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)PSAlertViewCancel:(PSAlertView *)alertView;
- (void)willPresentPSAlertView:(PSAlertView *)alertView;
- (void)didPresentPSAlertView:(PSAlertView *)alertView;
- (void)PSAlertView:(PSAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)PSAlertView:(PSAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
- (BOOL)PSAlertViewShouldEnableFirstOtherButton:(PSAlertView *)alertView;
@end

@interface NSString (MD5)
- (NSString*)MD5;
@end