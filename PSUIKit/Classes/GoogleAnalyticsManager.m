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

#import "GoogleAnalyticsManager.h"
#import <objc/runtime.h>

@implementation GANTracker

#pragma mark - Class
// ================================================================================================
//  Class
// ================================================================================================
+ (GANTracker *)sharedTracker
{
    static GANTracker *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GANTracker alloc] init];
    });
    return instance;
}

#pragma mark - Public
// ================================================================================================
//  Public
// ================================================================================================
- (void)startTrackerWithAccountID:(NSString *)accountID dispatchPeriod:(NSTimeInterval)dispatchPeriod delegate:(id)delegate
{
    [[GAI sharedInstance] trackerWithTrackingId:accountID];
    [GAI sharedInstance].dispatchInterval = dispatchPeriod;
}

- (void)stopTracker
{
    // 따로 제공되는 함수가 없음...
}

- (void)trackPageview:(NSString *)viewName withError:(NSError *)error
{
    if (!viewName)
        return;
    
    id tracker = [[GAI sharedInstance] defaultTracker];

    [tracker set:kGAIScreenName value:viewName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [tracker set:kGAIScreenName value:nil];
}

@end

@interface GoogleAnalyticsManager ()

@property (nonatomic, copy) NSString *accountID;
@property (nonatomic, strong) NSDictionary *classMapDictionary;

@end

@implementation GoogleAnalyticsManager

#pragma mark - Class
// ================================================================================================
//  Class
// ================================================================================================
+ (GoogleAnalyticsManager *)sharedManager
{
    static GoogleAnalyticsManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GoogleAnalyticsManager alloc] init];
    });
    return instance;
}

#pragma mark - Overriden
// ================================================================================================
//  Overridden: NSObject
// ================================================================================================
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.classMapDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GAPageKey" ofType:@"plist"]];
    }
    return self;
}

- (void)dealloc
{
    self.accountID = nil;
    self.classMapDictionary = nil;
}

#pragma mark - Public
// ================================================================================================
//  Public
// ================================================================================================
- (void)startTrackerWithAccountID:(NSString *)accountID
{
    self.accountID = accountID;
    
    if (accountID)
        [[GANTracker sharedTracker] startTrackerWithAccountID:accountID dispatchPeriod:10 delegate:nil];
}

- (void)stopTracker
{
    if (self.accountID)
        [[GANTracker sharedTracker] stopTracker];
}

- (NSString *)pageKeyWithController:(id)controller
{
    if (!self.accountID || !self.classMapDictionary)
        return nil;
    
    NSString *className = NSStringFromClass([controller class]);
    NSString *pageKey = self.classMapDictionary[className];
    
    return pageKey;
}

- (void)trackWithController:(id)controller
{
    NSString *pageKey = [self pageKeyWithController:controller];
    
    if (pageKey)
        [[GANTracker sharedTracker] trackPageview:pageKey withError:nil];
}

@end

@implementation GATrackingObject

#pragma mark - Class
// ================================================================================================
//  Class
// ================================================================================================
+ (GATrackingObject *)create:(NSString *)category action:(NSString *)action
{
    return [GATrackingObject create:category action:action event:UIControlEventTouchUpInside];
}

+ (GATrackingObject *)create:(NSString *)category action:(NSString *)action event:(UIControlEvents)event
{
    return [GATrackingObject create:category action:action label:nil value:nil event:event];
}

+ (GATrackingObject *)create:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value event:(UIControlEvents)event
{
    GATrackingObject *obj = [[GATrackingObject alloc] init];
    obj.category = category;
    obj.action = action;
    obj.label = label;
    obj.value = value;
    obj.event = event;
    return obj;
}

+ (void)send:(NSString *)category action:(NSString *)action
{
    return [GATrackingObject send:category action:action label:nil value:nil];
}

+ (void)send:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value
{
    return [[GATrackingObject create:category action:action label:label value:value event:UIControlEventTouchUpInside] send];
}

#pragma mark - Overriden
// ================================================================================================
//  Overriden
// ================================================================================================
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.event = UIControlEventTouchUpInside;
    }
    return self;
}

- (void)dealloc
{
    self.category = nil;
    self.action = nil;
    self.label = nil;
    self.value = nil;
}

#pragma mark - Public
// ================================================================================================
//  Public
// ================================================================================================
- (void)send
{
    if (!self.category || !self.action)
    {
        NSLog(@"category & action is required [%@, %@]", self.category, self.action);
        return;
    }
    
    id tracker = [GAI sharedInstance].defaultTracker;
    
    if (tracker)
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:self.category action:self.action label:self.label value:self.value] build]];
}

@end

static NSString *GAEventTrackingObjectKey = @"com.orcller.app.orcller.ga.eventtrackingobject";

@implementation UIControl (GAEventTracking)

#pragma mark - Public
// ================================================================================================
//  Public
// ================================================================================================
- (void)setTrackingObject:(GATrackingObject *)trackingObject
{
    if (self.trackingObject)
        [self removeTarget:self.trackingObject action:@selector(send) forControlEvents:self.trackingObject.event];
    
    // Set the wrapper as an associated object
    objc_setAssociatedObject(self, (__bridge const void *)GAEventTrackingObjectKey, trackingObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:trackingObject action:@selector(send) forControlEvents:trackingObject.event];
}

- (GATrackingObject *)trackingObject
{
    return objc_getAssociatedObject(self, (__bridge const void *)GAEventTrackingObjectKey);
}

- (void)registerEventTracking:(NSString *)category action:(NSString *)action
{
    [self registerEventTracking:category action:action label:nil value:nil];
}

- (void)registerEventTracking:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value
{
    GATrackingObject *obj = [[GATrackingObject alloc] init];
    obj.category = category;
    obj.action = action;
    obj.label = label;
    obj.value = value;
    
    self.trackingObject = obj;
}

@end