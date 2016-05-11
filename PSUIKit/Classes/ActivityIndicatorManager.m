//
//  ActivityIndicatorManager.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "ActivityIndicatorManager.h"

// ================================================================================================
//  Class Variables
// ================================================================================================

static BOOL initialized;
static NSMutableDictionary *dictionary;

// ================================================================================================
//  Class Methods
// ================================================================================================

@implementation ActivityIndicatorManager
+ (void)initialize
{
    if (!initialized)
    {
        dictionary = [NSMutableDictionary dictionary];
        initialized = true;
    }
}

+ (void)activate:(UIView *)view activityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle message:(NSString *)message offset:(CGPoint)offset modal:(BOOL)modal
{
    if ([ActivityIndicatorManager contains: view])
        return;
    
    UIView *modalView = modal ? [[UIView alloc] init] : nil;
    BOOL scrollEnabled = NO;
    if (modalView) {
        modalView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        modalView.autoresizingMask = UIViewAutoresizingFlexibleAll;
        modalView.backgroundColor = [UIColor colorWithRed:248/255.0 green:247/255.0 blue:248/255.0 alpha:1];
        [view addSubview:modalView];
        scrollEnabled = [[self class] setScrollEnabledWithView:view scrollEnabled:NO];
    }
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityIndicatorStyle];
    indicator.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    if (modalView)  [modalView addSubview:indicator];
    else            [view addSubview:indicator];
    
    UILabel *label = message ? [[UILabel alloc] init] : nil;
    if (label) {
        label.backgroundColor = [UIColor clearColor];
        label.opaque = NO;
        label.textColor = [UIColor grayColor];
        label.text = message;
        
        if (modalView)  [modalView addSubview:label];
        else            [view addSubview:label];
    }
    
    [[self class] cache:view indicator:indicator label:label modalView:modalView offset:offset scrollEnabled:scrollEnabled];
    [self layout:view];
    [indicator startAnimating];
}

+ (void)activate:(UIView *)view activityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle message:(NSString *)message modal:(BOOL)modal;
{
    [[self class] activate:view activityIndicatorStyle:activityIndicatorStyle message:message offset:CGPointMake(0, 0) modal:modal];
}

+ (void)activate:(UIView *)view activityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle modal:(BOOL)modal
{
    [[self class] activate:view activityIndicatorStyle:activityIndicatorStyle message:nil offset:CGPointMake(0, 0) modal:modal];
}

+ (void)activate:(UIView *)view modal:(BOOL)modal
{
    [[self class] activate:view activityIndicatorStyle:UIActivityIndicatorViewStyleGray message:nil offset:CGPointMake(0, 0) modal:modal];
}

+ (void)activate:(UIView *)view message:(NSString *)message offset:(CGPoint)offset modal:(BOOL)modal
{
    [[self class] activate:view activityIndicatorStyle:UIActivityIndicatorViewStyleGray message:message offset:offset modal:modal];
}

+ (void)activate:(UIView *)view message:(NSString *)message modal:(BOOL)modal
{
    [[self class] activate:view activityIndicatorStyle:UIActivityIndicatorViewStyleGray message:message offset:CGPointMake(0, 0) modal:modal];
}

+ (void)activate:(UIView *)view offset:(CGPoint)offset modal:(BOOL)modal
{
    [[self class] activate:view activityIndicatorStyle:UIActivityIndicatorViewStyleGray message:nil offset:offset modal:modal];
}

+ (void)cache:(UIView *)view indicator:(UIActivityIndicatorView *)indicator label:(UILabel *)label modalView:(UIView *)modalView offset:(CGPoint)offset scrollEnabled:(BOOL)scrollEnabled
{
    NSMutableDictionary *cache = [NSMutableDictionary dictionary];
    if (indicator)  [cache setObject:indicator forKey:@"indicator"];
    if (label)      [cache setObject:label forKey:@"label"];
    if (modalView)  [cache setObject:modalView forKey:@"modalView"];
    [cache setObject:NSStringFromCGPoint(offset) forKey:@"offset"];
    [cache setObject:[NSNumber numberWithBool:scrollEnabled] forKey:@"scrollEnabled"];
    [dictionary setObject:cache forKey:[NSNumber numberWithInteger:view.hash]];
}

+ (void)layout:(UIView *)view
{
    [[self class] layout:view layoutStyle:ActivityIndicatorLayoutStyleCenter];
}

+ (void)layout:(UIView *)view layoutStyle:(ActivityIndicatorLayoutStyle)layoutStyle
{
    if (![ActivityIndicatorManager contains:view])
        return;
    
    NSNumber *key = [NSNumber numberWithInteger:view.hash];
    NSDictionary *cache = [dictionary objectForKey:key];
    UIActivityIndicatorView *indicator = [cache objectForKey:@"indicator"];
    UILabel *label = [cache objectForKey:@"label"];
    CGPoint offset = CGPointFromString([cache objectForKey:@"offset"]);
    CGFloat horizontalGap = 3, addendX = 0, addendY = 0, ix = 0, iy = 0, lx = 0, ly = 0;
    
    if ([view isKindOfClass:[UIScrollView class]])
    {
        addendX = ((UIScrollView *) view).contentOffset.x;
        addendY = ((UIScrollView *) view).contentOffset.y;
    }
    
    if (label)
    {
        [[self class] widthFitByText:label];
        [[self class] heightFitByText:label];
    }
    
    CGRect labelFrame = label.frame;
    
    if (layoutStyle == ActivityIndicatorLayoutStyleTop)
    {
        lx = (view.frame.size.width - labelFrame.size.width)/2;
        ly = 15;
        ix = (view.frame.size.width - indicator.frame.size.width)/2;
        iy = ly + labelFrame.size.height + 15;
    }
    else
    {
        ix = (view.frame.size.width - (indicator.frame.size.width + labelFrame.size.width + horizontalGap))/2 + offset.x + addendX;
        iy = (view.frame.size.height - indicator.frame.size.height)/2 + offset.y + addendY;
        lx = ix + indicator.frame.size.width + horizontalGap;
        ly = iy + (indicator.frame.size.height - labelFrame.size.height)/2;
    }
    
    labelFrame.origin.x = lx;
    labelFrame.origin.y = ly;
    indicator.frame = CGRectMake(ix, iy, indicator.frame.size.width, indicator.frame.size.height);
    label.frame = labelFrame;
}

+ (void)setMessage:(UIView *)view text:(NSString *)text
{
    [[self class] setMessage:view text:text layoutStyle:ActivityIndicatorLayoutStyleCenter];
}

+ (void)setMessage:(UIView *)view text:(NSString *)text layoutStyle:(ActivityIndicatorLayoutStyle)layoutStyle
{
    UILabel *label = [[self class] label:view];
    if (label) {
        label.text = text;
        [self layout:view layoutStyle:layoutStyle];
    }
}

+ (BOOL)contains:(UIView *)view
{
    [ActivityIndicatorManager initialize];
    
    if (view) {
        NSNumber *key = [NSNumber numberWithInteger:view.hash];
        return [dictionary objectForKey:key] != nil;
    }
    return false;
}

+ (void)deactivate:(UIView *)view
{
    if (![ActivityIndicatorManager contains:view])
        return;
    
    NSNumber *key = [NSNumber numberWithInteger:view.hash];
    NSDictionary *object = [dictionary objectForKey:key];
    UIActivityIndicatorView *indicator = [object objectForKey:@"indicator"];
    UILabel *label = [object objectForKey:@"label"];
    UIView *modalView = [object objectForKey:@"modalView"];
    BOOL scrollEnabled = [[object objectForKey:@"scrollEnabled"] boolValue];
    
    [dictionary removeObjectForKey:key];
    
    if (indicator)
    {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
    if (label)
    {
        [label removeFromSuperview];
    }
    if (modalView)
    {
        [modalView removeFromSuperview];
        [[self class] setScrollEnabledWithView:view scrollEnabled:scrollEnabled];
    }
}

+ (BOOL)setScrollEnabledWithView:(UIView *)view scrollEnabled:(BOOL)scrollEnabled
{
    BOOL orgScrollEnabled = NO;
    if ([view isKindOfClass:[UIScrollView class]])
    {
        orgScrollEnabled = ((UIScrollView *) view).scrollEnabled;
        ((UIScrollView *) view).scrollEnabled = scrollEnabled;
    }
    return orgScrollEnabled;
}

+ (UIView *)modalView:(UIView *)view
{
    NSNumber *key = [NSNumber numberWithInteger:view.hash];
    NSDictionary *currentDictionary = [dictionary objectForKey:key];
    return currentDictionary ? [currentDictionary objectForKey:@"modalView"] : nil;
}

+ (UILabel *)label:(UIView *)view
{
    NSNumber *key = [NSNumber numberWithInteger:view.hash];
    NSDictionary *currentDictionary = [dictionary objectForKey:key];
    return currentDictionary ? [currentDictionary objectForKey:@"label"] : nil;
}

+ (UIActivityIndicatorView *)indicator:(UIView *)view
{
    NSNumber *key = [NSNumber numberWithInteger:view.hash];
    NSDictionary *currentDictionary = [dictionary objectForKey:key];
    return currentDictionary ? [currentDictionary objectForKey:@"indicator"] : nil;   
}

+ (void)heightFitByText:(UILabel *)target
{
    CGSize maximumLabelSize = CGSizeMake(296,9999);
    CGSize expectedLabelSize = [target.text sizeWithFont:target.font constrainedToSize:maximumLabelSize lineBreakMode:target.lineBreakMode];
    target.frame = CGRectMake(target.frame.origin.x, target.frame.origin.y, target.frame.size.width, expectedLabelSize.height);
    target.numberOfLines = 0;
}

+ (void)widthFitByText:(UILabel *)target
{
    CGSize maximumLabelSize = CGSizeMake(296,9999);
    CGSize expectedLabelSize = [target.text sizeWithFont:target.font constrainedToSize:maximumLabelSize lineBreakMode:target.lineBreakMode];
    target.frame = CGRectMake(target.frame.origin.x, target.frame.origin.y, expectedLabelSize.width, target.frame.size.height);
}

@end
