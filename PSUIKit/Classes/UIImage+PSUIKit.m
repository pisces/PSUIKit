//
//  UIImage+PSUIKit.m
//  PSUIKit
//
//  Created by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2015년 Steve Kim. All rights reserved.
//

#import "UIImage+PSUIKit.h"

@implementation UIImage (org_apache_PSUIKit_UIImage)

+ (UIImage *)imageNamedForScreen:(NSString *)name
{
    name = [name stringByReplacingOccurrencesOfString:@".(png|jpg|jpeg|gif)" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, name.length)];
    NSString *suffix = @"";
    CGFloat sh = [UIScreen mainScreen].bounds.size.height;
    
    if (sh >= 736)
        suffix = @"-736h";
    else if (sh >= 667)
        suffix = @"-667h";
    else if (sh >= 568)
        suffix = @"-568h";
    
    UIImage *image = [UIImage imageNamed:[name stringByAppendingString:suffix]];
    
    if (!image)
        image = [UIImage imageNamed:name];
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)applyTintColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0f, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, self.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [color setFill];
    CGContextFillRect(context, rect);
    
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImage;
}

- (UIImage *)crop:(CGRect)rect
{
    rect = CGRectMake(rect.origin.x * self.scale, rect.origin.y * self.scale, rect.size.width * self.scale, rect.size.height * self.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (UIImage *)scale:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext() , kCGInterpolationHigh);
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)scaleAndCrop:(CGSize)size {
    CGFloat scale = (float) MIN(size.width, size.height) / MIN(self.size.width, self.size.height);
    NSInteger w = self.size.width * scale;
    NSInteger h = self.size.height * scale;
    CGRect rect = CGRectMake(0, 0, w, h);
    CGRect cropRect = CGRectMake((w - size.width)/2, (h - size.height)/2, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return image;
}

- (UIImage *)WBHighlightImage
{
    const CGSize  size = self.size;
    const CGRect  bnds = CGRectMake(0.0, 0.0, size.width, size.height);
    UIColor*      colr = nil;
    UIImage*      copy = nil;
    CGContextRef  ctxt = NULL;
    
    colr = [[UIColor alloc] initWithWhite:0 alpha:0.25];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    ctxt = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(ctxt, 0.0, bnds.size.height);
    CGContextScaleCTM(ctxt, 1.0, -1.0);
    
    CGContextDrawImage(ctxt, bnds, self.CGImage);
    
    CGContextClipToMask(ctxt, bnds, self.CGImage);
    CGContextSetFillColorWithColor(ctxt, colr.CGColor);
    CGContextFillRect(ctxt, bnds);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

@end
