//
//  UIAlertView+PSUIKit.h
//  PSUIKit
//
//  Created by Steve Kim on 2014. 8. 24..
//  Copyright (c) 2014년 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (PSUIKit)
+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle completion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex, BOOL cancel))completion;
- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex, BOOL cancel))completion;
@end
