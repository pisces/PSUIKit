//
//  UIView+PSUIKit.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

enum {
	UIViewMatricsNormal,
	UIViewMatricsLanscape
};
typedef Byte UIViewMatrics;

@interface UIView (org_apache_PSUIKit_UIView)
@property (nonatomic, readonly) BOOL dataLoading;
@property (nonatomic, readonly, getter=isFirstLoading) BOOL firstLoading;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic, readonly) CGFloat right;
@property (nonatomic, readonly) CGFloat bottom;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, readonly) UIImage *image;
+ (instancetype)nibBasedInstance;
+ (instancetype)nibBasedInstanceWithBundle:(NSBundle *)bundle;
- (id)initWithColor:(UIColor *)color withFrame:(CGRect)frame;
- (id)initWithColor:(UIColor *)color withFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius;
- (void)drawGradientRect:(CGFloat[])colors;
- (void)endDataLoading;
- (BOOL)invalidDataLoading;
- (void)removeAllSubviews;
- (void)setX:(CGFloat)x y:(CGFloat)y;
- (void)setX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width;
- (void)setX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
- (void)showGuideLines;
@end