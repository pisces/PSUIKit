//
//  UIButton+Extensions.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "UIButton+PSUIKit.h"

#define kResourceDictionary @"kResourceDictionary"

@implementation UIButton (org_apache_PSUIKit_UIButton)

@dynamic resourceDictionary;

// ================================================================================================
//  Properties
// ================================================================================================

- (void)setResourceDictionary:(NSMutableDictionary *)resourceDictionary {
    if ([resourceDictionary isEqual:[self resourceDictionary]])
        return;
    objc_setAssociatedObject(self, kResourceDictionary, resourceDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)resourceDictionary {
    return objc_getAssociatedObject(self, kResourceDictionary);
}

// ================================================================================================
//  Public
// ================================================================================================

- (void)setBackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state {
    [self setBackgroundColor:backgroundColor borderColor:nil borderWidth:0 cornerRadius:cornerRadius forState:state];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state {
    [self setBackgroundImage:[self imageWithColor:backgroundColor borderColor:borderColor borderWidth:borderWidth cornerRadius:cornerRadius] forState:state];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state forViewMetrics:(UIViewMatrics)viewMetrics
{
    if (image)
    {
        if (!self.resourceDictionary)
            self.resourceDictionary = [NSMutableDictionary dictionary];
        
        NSString *key = [@"backgroundImage" stringByAppendingFormat:@"::%zd:%zd", state, viewMetrics];
        [self.resourceDictionary setObject:image forKey:key];
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state forViewMetrics:(UIViewMatrics)viewMetrics
{
    if (color)
    {
        if (!self.resourceDictionary)
            self.resourceDictionary = [NSMutableDictionary dictionary];
        
        NSString *key = [@"color" stringByAppendingFormat:@"::%zd:%zd", state, viewMetrics];
        [self.resourceDictionary setObject:color forKey:key];
    }
}

- (void)updateBackgroundImage
{
    [self updateBackgroundImage:self.window.rootViewController.interfaceOrientation];
}

- (void)updateBackgroundImage:(UIInterfaceOrientation)interfaceOrientation
{
    if (!self.resourceDictionary)
        return;
    
    UIViewMatrics viewMatrics = UIInterfaceOrientationIsLandscape(interfaceOrientation) ? UIViewMatricsLanscape : UIViewMatricsNormal;
    NSString *backgroundImageNormalKey = [@"backgroundImage" stringByAppendingFormat:@"::%zd:%zd", UIControlStateNormal, viewMatrics];
    NSString *backgroundImageHighlightedKey = [@"backgroundImage" stringByAppendingFormat:@"::%zd:%zd", UIControlStateHighlighted, viewMatrics];
    NSString *backgroundImageSelectedKey = [@"backgroundImage" stringByAppendingFormat:@"::%zd:%zd", UIControlStateSelected, viewMatrics];
    NSString *backgroundImageDisabledKey = [@"backgroundImage" stringByAppendingFormat:@"::%zd:%zd", UIControlStateDisabled, viewMatrics];
    
    UIImage *backgroundImageNormal = [self.resourceDictionary objectForKey:backgroundImageNormalKey];
    UIImage *backgroundImageHighlighted = [self.resourceDictionary objectForKey:backgroundImageHighlightedKey];
    UIImage *backgroundImageSelected = [self.resourceDictionary objectForKey:backgroundImageSelectedKey];
    UIImage *backgroundImageDisabled = [self.resourceDictionary objectForKey:backgroundImageDisabledKey];
    
    if (backgroundImageNormal)
        [self setBackgroundImage:backgroundImageNormal forState:UIControlStateNormal];
    
    if (backgroundImageHighlighted)
        [self setBackgroundImage:backgroundImageHighlighted forState:UIControlStateHighlighted];
    
    if (backgroundImageSelected)
        [self setBackgroundImage:backgroundImageSelected forState:UIControlStateSelected];
    
    if (backgroundImageDisabled)
        [self setBackgroundImage:backgroundImageDisabled forState:UIControlStateDisabled];
}

- (void)updateTitleColor
{
    [self updateTitleColor:self.window.rootViewController.interfaceOrientation];
}

- (void)updateTitleColor:(UIInterfaceOrientation)interfaceOrientation
{
    if (!self.resourceDictionary)
        return;
    
    UIViewMatrics viewMatrics = UIInterfaceOrientationIsLandscape(interfaceOrientation) ? UIViewMatricsLanscape : UIViewMatricsNormal;
    NSString *colorNormalKey = [@"color" stringByAppendingFormat:@"::%zd:%zd", UIControlStateNormal, viewMatrics];
    NSString *colorHighlightedKey = [@"color" stringByAppendingFormat:@"::%zd:%zd", UIControlStateHighlighted, viewMatrics];
    NSString *colorSelectedKey = [@"color" stringByAppendingFormat:@"::%zd:%zd", UIControlStateSelected, viewMatrics];
    NSString *colorDisabledKey = [@"color" stringByAppendingFormat:@"::%zd:%zd", UIControlStateDisabled, viewMatrics];
    UIColor *colorNormal = [self.resourceDictionary objectForKey:colorNormalKey];
    UIColor *colorHighlighted = [self.resourceDictionary objectForKey:colorHighlightedKey];
    UIColor *colorSelected = [self.resourceDictionary objectForKey:colorSelectedKey];
    UIColor *colorDisabled = [self.resourceDictionary objectForKey:colorDisabledKey];
    
    if (colorNormal)
        [self setTitleColor:colorNormal forState:UIControlStateNormal];
    
    if (colorHighlighted)
        [self setTitleColor:colorHighlighted forState:UIControlStateHighlighted];
    
    if (colorSelected)
        [self setTitleColor:colorSelected forState:UIControlStateSelected];
    
    if (colorDisabled)
        [self setTitleColor:colorDisabled forState:UIControlStateDisabled];
}

- (void)updateView
{
    [self updateView:self.window.rootViewController.interfaceOrientation];
}

- (void)updateView:(UIInterfaceOrientation)interfaceOrientation
{
    [self updateBackgroundImage:interfaceOrientation];
    [self updateTitleColor:interfaceOrientation];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (UIImage *)imageWithColor:(UIColor *)color borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius {
    UIView *view = [[UIView alloc] initWithColor:color withFrame:self.bounds];
    view.layer.borderWidth = borderWidth;
    view.layer.borderColor = borderColor.CGColor;
    view.layer.cornerRadius = cornerRadius;
    return [view.image stretchableImageWithLeftCapWidth:self.width/2 topCapHeight:self.height/2];
}

@end
