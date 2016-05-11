//
//  UIWindow+PSUIKit.m
//  PSUIKit
//
//  Created by pisces on 2015. 7. 17..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "UIWindow+PSUIKit.h"
#include "PSUIKit.h"

@implementation UIWindow (org_apache_PSUIKit_UIWindow)
- (CGSize)scaledSize:(CGSize)size {
    CGFloat scale = self.width/size.width;
    return CGSizeMake(size.width * scale, size.height * scale);
}
@end
