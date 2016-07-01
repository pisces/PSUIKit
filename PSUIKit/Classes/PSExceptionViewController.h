//
//  PSExceptionViewController.m
//  PSUIKit
//
//  Created by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2015년 hh963103@gmail.com. All rights reserved.
//

#import "base.h"

@protocol PSExceptionViewControllerDelegate;

enum {
    PSExceptionViewImagePositionTop,
    PSExceptionViewImagePositionBottom
};
typedef NSInteger PSExceptionViewImagePosition;

@interface PSExceptionViewController : PSViewController
@property (nonatomic) NSInteger id;
@property (nonatomic) CGPadding padding;
@property (nonatomic) PSExceptionViewImagePosition imagePosition;
@property (nonatomic, strong) NSString *buttonTitleText;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak, readonly) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak, readonly) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak, readonly) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet PSLinedBackgroundView *backgroundView;
@property (nonatomic, weak) IBOutlet UIButton *actionButton;
@property (nonatomic, weak) id<PSExceptionViewControllerDelegate> delegate;
- (id)initWithSuperview:(UIView *)superview;
- (id)initWithSuperview:(UIView *)superview offset:(CGPoint)offset;
- (BOOL)checkVisibility;
@end

@protocol PSExceptionViewControllerDelegate <NSObject>

@required
- (BOOL)exceptionViewShouldShowWithController:(PSExceptionViewController *)controller;

@optional
- (void)controller:(PSExceptionViewController *)controller buttonClicked:(id)sender;
- (void)controller:(PSExceptionViewController *)controller willDisplayView:(UIView *)view;

@end