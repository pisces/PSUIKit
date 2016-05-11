//
//  UIImage+PSUIKit.h
//  PSUIKit
//
//  Created by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2015년 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (org_apache_PSUIKit_UIImage)
+ (UIImage *)imageNamedForScreen:(NSString *)name;
+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)applyTintColor:(UIColor *)color;
- (UIImage *)crop:(CGRect)rect;
- (UIImage *)scale:(CGSize)size;
- (UIImage *)scaleAndCrop:(CGSize)size;
- (UIImage *)WBHighlightImage;
@end
