//
//  UIViewControllerStack.h
//  PSUIKit
//
//  Created by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

/*
 Copyright 2015 Steve Kim
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "base.h"

@protocol UIViewControllerStackDelegate;

@interface UIViewControllerStack : NSObject <UIScrollViewDelegate>
@property (nonatomic) CGFloat horizontalGap;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *controllers;
@property (nonatomic, readonly) UIViewController *selectedViewController;
@property (nonatomic, weak) id<UIViewControllerStackDelegate> delegate;
- (id)initWithParentViewController:(UIViewController *)controller;
- (id)initWithParentViewController:(UIViewController *)controller targetView:(UIView *)view;
- (void)layoutSubviews;
- (NSString *)titleWithIndex:(NSInteger)index;
@end

@protocol UIViewControllerStackDelegate <NSObject>
@optional
- (void)stack:(UIViewControllerStack *)stack didChangeSelectionWithIndex:(NSInteger)index;
@end

@protocol UIRespondableViewControllerProtocol <NSObject>
@optional
- (void)viewDidBecomeFirstResponder;
- (void)viewDidResigneFirstResponder;
- (void)viewWillBecomeFirstResponder;
- (void)viewWillResigneFirstResponder;
@end