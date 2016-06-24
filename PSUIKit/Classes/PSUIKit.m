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

+ (UIImage *)imageWithName:(NSString *)name {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".(png|jpg|jpeg)" options:0 error:nil];
    NSTextCheckingResult *matche = [regex firstMatchInString:name options:0 range:(NSRange) {0, name.length}];
    
    if (matche) {
        NSString *filename = [name substringWithRange:(NSRange) {0, matche.range.location}];
        NSString *ext = [name substringWithRange:(NSRange) {matche.range.location + 1, matche.range.length - 1}];
        return [UIImage imageNamed:[[PSUIKit bundle] pathForResource:filename ofType:ext]];
    }
    
    return nil;
}

+ (NSString *)localizedStringWithKey:(NSString *)key {
    return [[self bundle] localizedStringForKey:key value:nil table:@"PSUIKit"];
}

@end