//
//  PSViewController.h
//  PSUIKit
//
//  Created by Steve Kim on 2014. 8. 24..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2014년 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSNavigationController.h"
#import "PSPreloader.h"
#import "UIThemeBase.h"

@import Reachability;

typedef void (^PSViewWillCloseBlock)(void);

@class PSExceptionViewDisplaySequence;

@protocol PSViewControllerProtected <NSObject>
- (void)commitProperties;
- (void)initProperties;
- (void)resetFirstViewAppearence;
- (void)setLeftBarButtonItem;
- (void)setLeftBarButtonItemWithText:(NSString *)text;
- (void)setLeftBarButtonItemWithTheme:(id<UIThemeProtocol>)theme;
- (void)setLeftBarButtonItemWithTheme:(id<UIThemeProtocol>)theme leftBarButtonItemText:(NSString *)text;
- (void)updateWithReachability:(Reachability *)aReachability;
@end

@interface PSViewController : UIViewController <PSViewControllerProtected>
@property (nonatomic, readonly) BOOL hasPresentedViewController;
@property (nonatomic) BOOL immediatelyUpdating;
@property (nonatomic, readonly) BOOL isFirstViewAppearence;
@property (nonatomic, readonly) BOOL isNotReachable;
@property (nonatomic, readonly) BOOL isNotReachableBefore;
@property (nonatomic, readonly) BOOL isViewAppeared;
@property (nonatomic) BOOL navigationBarHidden;
@property (nonatomic, readonly) NSString *gaPageKey;
@property (nonatomic, readonly) UINavigationController *presentedNavigationController;
@property (nonatomic, readonly) PSExceptionViewDisplaySequence *exceptionViewDisplaySequence;
- (void)invalidateProperties;
- (void)layoutSubviews;
- (void)validateProperties;
- (void)willClose:(PSViewWillCloseBlock)close;
@end