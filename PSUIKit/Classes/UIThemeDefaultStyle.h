//
//  UIThemeDefaultStyle.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "PSUIKit.h"

@interface UIThemeDefaultStyle : UIThemeBase
+ (UIThemeDefaultStyle *)sharedTheme;
- (UIBarButtonItem *)backArrowBarButtonItemWithTarget:(id)target action:(SEL)action;
- (UIBarButtonItem *)backCollectionBarButtonItemWithTarget:(id)target action:(SEL)action;
- (UIBarButtonItem *)blueBackArrowBarButtonItemWithTarget:(id)target action:(SEL)action;
- (UIBarButtonItem *)closeBarButtonItemWithTarget:(id)target action:(SEL)action;
@end