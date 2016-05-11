//
//  PSUIKit.h
//  PSUIKit
//
//  Created by Steve Kim on 2015. 4. 8..
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

#import "UIApplication+PSUIKit.h"

NSString *const ApplicationDidBecomeActiveNotification = @"ApplicationDidBecomeActiveNotification";
NSString *const ApplicationDidChangeStatusBarFrameNotification = @"ApplicationDidChangeStatusBarFrameNotification";
NSString *const ApplicationDidEnterBackgroundNotification = @"ApplicationDidEnterBackgroundNotification";
NSString *const ApplicationDidReceiveRemoteNotification = @"ApplicationDidReceiveRemoteNotification";
NSString *const ApplicationDidFinishLaunchingWithOptionsNotification = @"ApplicationDidFinishLaunchingWithOptionsNotification";
NSString *const ApplicationDidHandleOpenURLNotification = @"ApplicationDidHandleOpenURLNotification";

@implementation UIApplication (org_apache_PSUIKit_UIApplication)

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (UIView *)keyboardView
{
    NSArray *windows = [self windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])
    {
        for (UIView *view in [window subviews])
        {
            if (!strcmp(object_getClassName(view), "UIKeyboard"))
                return view;
        }
    }
    
    return nil;
}

- (UIImage *)launchImage
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if( screenHeight < screenWidth )
        screenHeight = screenWidth;
    
    if (screenHeight > 480 && screenHeight < 667)
        return [UIImage imageNamed:@"Default-568h.png"];
    if (screenHeight > 480 && screenHeight < 736)
        return [UIImage imageNamed:@"Default-667h.png"];
    if (screenHeight > 480)
        return [UIImage imageNamed:@"Default-736h.png"];
    return [UIImage imageNamed:@"Default.png"];
}

- (void)setSourceApplication:(NSString *)sourceApplication
{
    if ([sourceApplication isEqual:[self sourceApplication]])
        return;
    objc_setAssociatedObject(self, @"sourceApplication", sourceApplication, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)sourceApplication
{
    return objc_getAssociatedObject(self, @"sourceApplication");
}

- (void)setUrl:(NSURL *)url
{
    if ([url isEqual:[self url]])
        return;
    objc_setAssociatedObject(self, @"url", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSURL *)url
{
    return objc_getAssociatedObject(self, @"url");
}

#pragma mark - Public methods

- (void)clearProperties
{
    self.sourceApplication = nil;
    self.url = nil;
}

- (void)registerUserNotificationTypes:(UIRemoteNotificationType)types
{
    if ([self respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationType)types categories:nil];
        [self registerUserNotificationSettings:settings];
    }

    [self registerForRemoteNotificationTypes:types];
}

- (UIRemoteNotificationType)enabledUserNotificationTypes
{
    if ([self respondsToSelector:@selector(currentUserNotificationSettings)])
    {
        UIUserNotificationSettings *settings = self.currentUserNotificationSettings;
        return self.isRegisteredForRemoteNotifications ? (UIRemoteNotificationType)settings.types : UIRemoteNotificationTypeNone;
    }
    
    return [self enabledRemoteNotificationTypes];
}

@end
