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

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

extern NSString *const ApplicationDidBecomeActiveNotification;
extern NSString *const ApplicationDidChangeStatusBarFrameNotification;
extern NSString *const ApplicationDidEnterBackgroundNotification;
extern NSString *const ApplicationDidReceiveRemoteNotification;
extern NSString *const ApplicationDidFinishLaunchingWithOptionsNotification;
extern NSString *const ApplicationDidHandleOpenURLNotification;

@interface UIApplication (org_apache_PSUIKit_UIApplication)
@property (nonatomic, readonly) UIImage *launchImage;
@property (nonatomic, readonly) UIView *keyboardView;
@property (nonatomic, strong) NSString *sourceApplication;
@property (nonatomic, strong) NSURL *url;
- (void)clearProperties;
- (void)registerUserNotificationTypes:(UIRemoteNotificationType)types;
- (UIRemoteNotificationType)enabledUserNotificationTypes;
@end
