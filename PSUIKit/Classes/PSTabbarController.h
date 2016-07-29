//
//  PSTabbarController.h
//  PSUIKit
//
//  Created by Steve Kim on 7/28/16.
//  Copyright (c) 2016년 Steve Kim. All rights reserved.
//

#import "PSViewController.h"
#import "PSButtonBar.h"

typedef NS_ENUM(NSInteger, PSTabbarPosition) {
    PSTabbarPositionTop = 1,
    PSTabbarPositionBottom
};

@protocol PSTabbarControllerDataSource;
@protocol PSTabbarControllerDelegate;

@interface PSTabbarController : PSViewController
@property (nonatomic) BOOL pagingEnabled;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) CGFloat buttonBarHeight;
@property (nonatomic) PSTabbarPosition tabbarPosition;
@property (nonnull, nonatomic, readonly) PSButtonBar *buttonBar;
@property (nonnull, nonatomic, readonly) UIScrollView *containerView;
@property (nullable, nonatomic, weak) IBOutlet id<PSTabbarControllerDataSource> dataSource;
@property (nullable, nonatomic, weak) IBOutlet id<PSTabbarControllerDelegate> delegate;
@end

@protocol PSTabbarControllerDataSource <NSObject>
- (NSArray<UIViewController *> * _Nonnull)childViewControllersWithController:(PSTabbarController * _Nonnull)controller;
- (void)controller:(PSTabbarController * _Nonnull)controller renderWithTab:(UIButton * _Nonnull)tab tabIndex:(NSInteger)tabIndex;
@end


@protocol PSTabbarControllerDelegate <NSObject>
- (void)didChangeTabIndex:(NSInteger)tabIndex;
@end