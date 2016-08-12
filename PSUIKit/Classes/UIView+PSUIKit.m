//
//  UIView+PSUIKit.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "UIView+PSUIKit.h"

#define bubbleKey @"bubbleKey"

@implementation UIView (org_apache_PSUIKit_UIView)

@dynamic dataLoading, firstLoading, origin, size;

+ (instancetype)nibBasedInstance
{
    return [[self class] nibBasedInstanceWithBundle:[NSBundle mainBundle]];
}

+ (instancetype)nibBasedInstanceWithBundle:(NSBundle *)bundle
{
    NSArray *views = [bundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    
    for (UIView *view in views)
        if ([view isKindOfClass:[self class]])
            return view;
    
    return [views firstObject];
}

- (id)initWithColor:(UIColor *)color withFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    
    if (self)
        self.backgroundColor = color;
    
    return self;
}

- (id)initWithColor:(UIColor *)color withFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius
{
    self = [self initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = color;
        self.layer.cornerRadius = cornerRadius;
    }
    
    return self;
}

// ================================================================================================
//  Public
// ================================================================================================

- (void)setDataLoading:(BOOL)dataLoading {
    if (dataLoading == [self dataLoading])
        return;
    
    objc_setAssociatedObject(self, @"dataLoading", @(dataLoading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)dataLoading {
    return [objc_getAssociatedObject(self, @"dataLoading") boolValue];
}

- (void)setFirstLoading:(BOOL)firstLoading {
    if (firstLoading == [self isFirstLoading])
        return;
    
    objc_setAssociatedObject(self, @"firstLoading", @(firstLoading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isFirstLoading {
    id object = objc_getAssociatedObject(self, @"firstLoading");
    return object ? [object boolValue] : YES;
}

- (CGFloat)right
{
    return self.x + self.width;
}

- (CGFloat)bottom
{
    return self.y + self.height;
}

- (CGFloat)x
{
    return CGRectGetMinX(self.frame);
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setX:(CGFloat)x y:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    frame.origin.y = y;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    self.frame = CGRectMake(x, y, width, height);
}

- (CGFloat)y
{
    return CGRectGetMinY(self.frame);
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width
{
    return CGRectGetWidth(self.bounds);
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return CGRectGetHeight(self.bounds);
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)drawGradientRect:(CGFloat[])colors
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, colors, locations, num_locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
}

- (void)removeAllSubviews
{
    for (UIView *subview in self.subviews)
        [subview removeFromSuperview];
}

- (UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    if (CGPointEqualToPoint(origin, self.origin))
        return;
    
    [self setX:origin.x y:origin.y];
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    if (CGSizeEqualToSize(size, self.size))
        return;
    
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

- (void)showGuideLines
{
    NSUInteger value = [[NSDate date] timeIntervalSince1970] + self.hash;
    CGFloat r = (value % 255) / 255.0f;
    CGFloat g = ((value / 255) % 255) / 255.0f;
    CGFloat b = (self.hash % 255) / 255.0f;
    
    self.layer.borderColor = [[UIColor colorWithRed:r green:g blue:b alpha:1.0f] CGColor];
    self.layer.borderWidth = 1.0f;
    
    for (UIView *sv in self.subviews)
        [sv showGuideLines];
}

@end
