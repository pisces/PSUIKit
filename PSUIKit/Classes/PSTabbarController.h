//
//  PSTabbarController.h
//  PSUIKit
//
//  Created by Steve Kim on 7/28/16.
//  Copyright (c) 2016년 Steve Kim. All rights reserved.
//

#import "PSViewController.h"
#import "PSButtonBar.h"

@class PSTabbarController;

@protocol PSTabbarControllerDataSource <NSObject>
- (NSArray<UIViewController *> * _Nonnull)childViewControllersWithController:(PSTabbarController * _Nonnull)controller;
- (void)controller:(PSTabbarController * _Nonnull)controller renderWithTab:(UIButton * _Nonnull)tab tabIndex:(NSInteger)tabIndex;
@end


@protocol PSTabbarControllerDelegate <NSObject>
- (void)didChangeTabIndex:(NSInteger)tabIndex;
@end

@interface PSTabbarController : PSViewController
@property (nonatomic) CGFloat buttonBarHeight;
@property (nonnull, nonatomic, readonly) PSButtonBar *buttonBar;
@property (nonnull, nonatomic, readonly) UIView *containerView;
@property (nullable, nonatomic, weak) IBOutlet id<PSTabbarControllerDataSource> dataSource;
@property (nullable, nonatomic, weak) IBOutlet id<PSTabbarControllerDelegate> delegate;
- (void)reloadData;
@end