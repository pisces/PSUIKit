//
//  PSUIKit.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Modified by Steve Kim on 2015. 2. 11..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "PSUIKit.h"

@implementation PSUIKit

// ================================================================================================
//  Public
// ================================================================================================

+ (NSBundle *)bundle {
    return [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"PSUIKit" ofType:@"bundle"]];
}

+ (NSString *)localizedStringWithKey:(NSString *)key {
    return [[self bundle] localizedStringForKey:key value:nil table:@"PSUIKit"];
}

@end