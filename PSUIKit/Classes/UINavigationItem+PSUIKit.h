//
//  UINavigationItem+PSUIKit.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BarButtonItemPositionLeft = 1,
    BarButtonItemPositionRight = 2
} BarButtonItemPosition;

@interface UINavigationItem (org_apache_PSUIKit_UINavigationItem)
- (UIBarButtonItem *)getLeftBarButtonItem;
- (UIBarButtonItem *)getRightBarButtonItem;
- (void)addActivitiIndicatorBarButtonItemWithPosition:(BarButtonItemPosition)position;
- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;
- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;
- (void)removeLeftBarButtonItem;
- (void)removeRightBarButtonItem;
@end
