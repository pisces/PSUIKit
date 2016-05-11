//
//  UIAlertView+PSUIKit.m
//  PSUIKit
//
//  Created by Steve Kim on 2014. 8. 24..
//  Copyright (c) 2014년 Steve Kim. All rights reserved.
//

#import "UIAlertView+PSUIKit.h"

#import <objc/runtime.h>

static NSString *UIAlertViewASSKey      = @"org.apache.PSUIKit.UIAlertView";

@interface UIAlertViewDelegate : NSObject <UIAlertViewDelegate>
@property (copy) void(^completionBlock)(UIAlertView *alertView, NSInteger buttonIndex, BOOL cancel);
@end

@implementation UIAlertViewDelegate

#pragma mark - UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.completionBlock)
    {
        self.completionBlock(alertView, buttonIndex, buttonIndex == alertView.cancelButtonIndex);
    }
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView
{
    // Just simulate a cancel button click
    if (self.completionBlock)
    {
        self.completionBlock(alertView, alertView.cancelButtonIndex, YES);
    }
}

@end


@implementation UIAlertView (org_apache_PSUIKit_UIActionSheet)

- (void)dealloc
{
    self.delegate                       = nil;
    objc_setAssociatedObject(self, (__bridge const void *)UIAlertViewASSKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle completion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex, BOOL cancel))completion
{
    UIAlertView *alertView              = [[UIAlertView alloc] initWithTitle:title
                                                                     message:message
                                                                    delegate:nil
                                                           cancelButtonTitle:cancelButtonTitle
                                                           otherButtonTitles:otherButtonTitle, nil];
    [alertView showWithCompletion:completion];
}

- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex, BOOL cancel))completion
{
    UIAlertViewDelegate *delegate       = [[UIAlertViewDelegate alloc] init];
    delegate.completionBlock            = completion;
    self.delegate                       = delegate;
    
    // Set the wrapper as an associated object
    objc_setAssociatedObject(self, (__bridge const void *)UIAlertViewASSKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self show];
}
@end