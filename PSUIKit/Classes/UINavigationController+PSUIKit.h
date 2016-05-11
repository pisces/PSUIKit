//
//  UINavigationController+PSUIKit.h
//  PSUIKit
//
//  Created by Steve Kim on 2014. 1. 8..
//  Copyright (c) 2014년 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (org_apache_PSUIKit_UINavigationController)
@property (nonatomic, readonly, strong) UIViewController *previousViewController;
@property (nonatomic, readonly, strong) NSString *previousTitle;
- (void)customize;
- (void)customize:(UIInterfaceOrientation)toInterfaceOrientation;
@end
