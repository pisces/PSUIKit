//
//  UIViewControllerStack.m
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

#import "UIViewControllerStack.h"

@interface UIViewControllerStack ()
@property (nonatomic, readonly) BOOL pagingEnabled;
@property (nonatomic, readonly) CGPoint contentOffset;
@property (nonatomic, readonly) CGSize contentSize;
@property (nonatomic, readonly) NSInteger scrollIndex;
@property (nonatomic, readonly) CGSize viewSize;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation UIViewControllerStack
{
@private
    UIView *targetView;
    UIViewController *parentViewController;
}

// ================================================================================================
//  Overridden: NSObject
// ================================================================================================

#pragma mark - Overridden: NSObject

- (void)dealloc
{
    [self deselect];
    
    self.scrollView.delegate = nil;
    targetView = nil;
    parentViewController = nil;
    _controllers = nil;
    _selectedViewController = nil;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (void)setControllers:(NSArray *)controllers
{
    if ([controllers isEqual:_controllers])
        return;
    
    _controllers = controllers;
    
    [self controllersChanged];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex == _selectedIndex)
        return;
    
    _selectedIndex = selectedIndex;
    
    [self selectedIndexChanged];
}

#pragma mark - Public methods

- (id)initWithParentViewController:(UIViewController *)controller
{
    return [self initWithParentViewController:controller targetView:controller.view];
}

- (id)initWithParentViewController:(UIViewController *)controller targetView:(UIView *)view
{
    self = [super init];
    
    if (self)
    {
        targetView = view;
        parentViewController = controller;
        self.scrollView.delegate = self;
    }
    
    return self;
}

- (void)layoutSubviews {
    NSInteger i = 0;
    
    for (UIViewController *controller in self.controllers)
    {
        controller.view.frame = [self viewFrameWithIndex:i];
        
        if ([controller isKindOfClass:[PSViewController class]])
            [((PSViewController *) controller) layoutSubviews];
        
        i++;
    }
    
    self.scrollView.contentSize = self.contentSize;
}

- (NSString *)titleWithIndex:(NSInteger)index
{
    if (index >= self.controllers.count)
        return nil;
    return ((UIViewController *) [self.controllers objectAtIndex:index]).title;
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private getter/setter

- (CGSize)contentSize {
    return CGSizeMake(targetView.width * self.controllers.count, self.scrollView.height);
}

- (BOOL)pagingEnabled
{
    return [targetView isKindOfClass:[UIScrollView class]] && ((UIScrollView *) targetView).pagingEnabled;
}

- (CGPoint)contentOffset {
    return CGPointMake((self.viewSize.width + self.horizontalGap) * self.selectedIndex, 0);
}

- (NSInteger)scrollIndex {
    return floorf(self.scrollView.contentOffset.x / (self.viewSize.width + self.horizontalGap));
}

- (UIScrollView *)scrollView{
    if (!_scrollView)
        _scrollView = [targetView isKindOfClass:[UIScrollView class]] ? (UIScrollView *) targetView : nil;
    return _scrollView;
}

- (CGSize)viewSize {
    return CGSizeMake(targetView.width - self.horizontalGap, targetView.height);
}

#pragma mark - Private methods

- (void)addViewsToTargetView
{
    NSInteger i = 0;
    
    for (UIViewController *controller in self.controllers)
    {
        if (self.pagingEnabled)
        {
            controller.view.autoresizingMask = UIViewAutoresizingNone;
            controller.view.frame = [self viewFrameWithIndex:i];
            
            [targetView addSubview:controller.view];
        }
        else
        {
            controller.view.autoresizingMask = UIViewAutoresizingFlexibleAll;
            controller.view.frame = targetView.bounds;
        }
        
        i++;
    }
    
    if (self.pagingEnabled)
    {
        self.scrollView.contentSize = self.contentSize;
        self.scrollView.contentOffset = CGPointZero;
    }
}

- (void)controllersChanged
{
    _selectedIndex = -1;
    
    [self removeViewsFromTargetView];
    [self addViewsToTargetView];
}

- (void)deselect
{
    if (!_selectedViewController)
        return;
    
    if ([_selectedViewController respondsToSelector:@selector(viewWillResigneFirstResponder)])
        [_selectedViewController performSelector:@selector(viewWillResigneFirstResponder)];
    
    [_selectedViewController viewWillDisappear:YES];
    [_selectedViewController viewDidDisappear:YES];
    [_selectedViewController removeFromParentViewController];
    
    if (!self.pagingEnabled)
        [_selectedViewController.view removeFromSuperview];
    
    if ([_selectedViewController respondsToSelector:@selector(viewDidResigneFirstResponder)])
        [_selectedViewController performSelector:@selector(viewDidResigneFirstResponder)];
    
    _selectedViewController = nil;
}

- (void)removeViewsFromTargetView
{
    for (UIViewController *controller in self.controllers)
        [controller.view removeFromSuperview];
}

- (void)selectedIndexChanged
{
    [self deselect];
    [self select];
}

- (void)select
{
    if (_selectedIndex < 0 || _selectedIndex >= _controllers.count)
        return;
    
    _selectedViewController = [self.controllers objectAtIndex:self.selectedIndex];
    
    if ([_selectedViewController respondsToSelector:@selector(viewWillBecomeFirstResponder)])
        [_selectedViewController performSelector:@selector(viewWillBecomeFirstResponder)];
    
    [parentViewController addChildViewController:_selectedViewController];
    
    if (self.pagingEnabled)
    {
        [_selectedViewController viewWillAppear:YES];
        [_selectedViewController viewDidAppear:YES];
        [self.scrollView setContentOffset:self.contentOffset animated:YES];
    }
    else
    {
        [targetView addSubview:_selectedViewController.view];
    }
    
    _selectedViewController.view.frame = [self viewFrameWithIndex:_selectedIndex];
    
    if ([_selectedViewController respondsToSelector:@selector(viewDidBecomeFirstResponder)])
        [_selectedViewController performSelector:@selector(viewDidBecomeFirstResponder)];
}

- (CGRect)viewFrameWithIndex:(NSInteger)index {
    CGSize size = self.viewSize;
    return self.pagingEnabled ? CGRectMake((size.width * index) + (index * self.horizontalGap), 0, size.width, size.height) : targetView.bounds;
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    NSInteger index = self.scrollIndex;
    if (index >= -1 && index < self.controllers.count && index != self.selectedIndex)
    {
        self.selectedIndex = index;
        
        if ([self.delegate respondsToSelector:@selector(stack:didChangeSelectionWithIndex:)])
            [self.delegate stack:self didChangeSelectionWithIndex:self.selectedIndex];
    }
}

@end
