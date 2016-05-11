//
//  Reachability+PSUIKit.m
//  PSUIKit
//
//  Created by pisces on 2015. 8. 13..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "Reachability+PSUIKit.h"

@implementation Reachability (org_apache_PSUIKit_Reachability)
+ (Reachability *)defaultReachability {
    static Reachability *instance;
    static dispatch_once_t precate;
    
    dispatch_once(&precate, ^{
        instance = [Reachability reachabilityForInternetConnection];
    });
    
    return instance;
}
@end
