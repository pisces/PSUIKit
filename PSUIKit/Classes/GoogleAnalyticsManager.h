//
//  PSUIKit.h
//  PSUIKit
//
//  Created by pisces on 2015. 4. 8..
//  Copyright (c) 2015년 orcllercorp. All rights reserved.
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
 limitations under the License.ls
 */

#import <Google/Analytics.h>

@interface GANTracker : NSObject
+ (GANTracker *)sharedTracker;
- (void)startTrackerWithAccountID:(NSString *)accountID dispatchPeriod:(NSTimeInterval)dispatchPeriod delegate:(id)delegate;
- (void)stopTracker;
- (void)trackPageview:(NSString *)viewName withError:(NSError *)error;
@end

@interface GoogleAnalyticsManager : NSObject
+ (GoogleAnalyticsManager *)sharedManager;
- (void)startTrackerWithAccountID:(NSString *)accountID;
- (void)stopTracker;
- (NSString *)pageKeyWithController:(id)controller;
- (void)trackWithController:(id)controller;
@end

@interface GATrackingObject : NSObject
@property (nonatomic) UIControlEvents event;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *label;
+ (GATrackingObject *)create:(NSString *)category action:(NSString *)action;
+ (GATrackingObject *)create:(NSString *)category action:(NSString *)action event:(UIControlEvents)event;
+ (GATrackingObject *)create:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value event:(UIControlEvents)event;
+ (void)send:(NSString *)category action:(NSString *)action;
+ (void)send:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;
- (void)send;
@end

@interface UIControl (GAEventTracking)
@property (nonatomic, strong) GATrackingObject *trackingObject;
- (void)registerEventTracking:(NSString *)category action:(NSString *)action;
- (void)registerEventTracking:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;
@end