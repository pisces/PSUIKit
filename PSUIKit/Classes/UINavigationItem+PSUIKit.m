//
//  UINavigationItem+PSUIKit.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "UINavigationItem+PSUIKit.h"

@implementation UINavigationItem (org_apache_PSUIKit_UINavigationItem)
- (UIBarButtonItem *)getLeftBarButtonItem
{
    return [self higherThanIOS7] ?
    (self.leftBarButtonItems.count > 1 ? (UIBarButtonItem *) [self.leftBarButtonItems objectAtIndex:1] : self.leftBarButtonItem) :
    self.leftBarButtonItem;
}

- (UIBarButtonItem *)getRightBarButtonItem
{
    return [self higherThanIOS7] ?
    (self.rightBarButtonItems.count > 1 ? (UIBarButtonItem *) [self.rightBarButtonItems objectAtIndex:1] : self.rightBarButtonItem) :
    self.rightBarButtonItem;
}

- (void)addActivitiIndicatorBarButtonItemWithPosition:(BarButtonItemPosition)position
{
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    if (position == BarButtonItemPositionLeft)
        [self addLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView]];
    else
        [self addRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView]];
    
    [activityIndicatorView startAnimating];
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    [self setLeftBarButtonItem:leftBarButtonItem];
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    [self setRightBarButtonItem:rightBarButtonItem];
}

- (void)removeLeftBarButtonItem
{
    self.leftBarButtonItem = nil;
    self.leftBarButtonItems = nil;
}

- (void)removeRightBarButtonItem
{
    self.rightBarButtonItem = nil;
    self.rightBarButtonItems = nil;
}

- (BOOL)higherThanIOS7
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
}

@end
