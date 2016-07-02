//
//  GraphicsLayout.c
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "GraphicsLayout.h"

CGPadding CGPaddingMake(CGFloat left, CGFloat top, CGFloat right, CGFloat bottom)
{
    CGPadding padding = {
        .left = left,
        .top = top,
        .right = right,
        .bottom = bottom
    };
    return padding;
}

CGPadding CGPaddingMakeAll(CGFloat value)
{
    return CGPaddingMake(value, value, value, value);
}

CGPadding CGPaddingMakeHorizontal(CGFloat left, CGFloat right)
{
    return CGPaddingMake(left, 0, right, 0);
}

CGPadding CGPaddingMakeVertical(CGFloat top, CGFloat bottom)
{
    return CGPaddingMake(0, top, 0, bottom);
}

BOOL CGPaddingEquals(CGPadding padding1, CGPadding padding2)
{
    return padding1.left == padding2.left && padding1.top == padding2.top && padding1.right == padding2.right && padding1.bottom == padding2.bottom;
}

BOOL CGPaddingZero(CGPadding padding)
{
    return padding.left == 0 && padding.top == 0 && padding.right == 0 && padding.bottom == 0;
}

// ================================================================================================
//
//  Implemetation
//
// ================================================================================================

@implementation GraphicsLayout

// ================================================================================================
//  Public Instance Methods
// ================================================================================================

+ (void)fitByText:(UILabel *)target
{
    [[self class] widthFitByText:target];
    [[self class] heightFitByText:target];
}

+ (void)fitByText:(UILabel *)target maxSize:(CGSize)maxSize
{
    [[self class] widthFitByText:target maxHeight:maxSize.height];
    [[self class] heightFitByText:target maxWidth:maxSize.width];
}

+ (void)heightFitByText:(UILabel *)target
{
    [[self class] heightFitByText:target maxWidth:(target.frame.size.width > 0 ? target.frame.size.width : 296)];
}

+ (void)heightFitByText:(UILabel *)target maxWidth:(CGFloat)maxWidth
{
    BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedDescending;
    CGSize maximumLabelSize = CGSizeMake(maxWidth, MAXFLOAT);
    CGSize expectedLabelSize = [target.text sizeWithFont:target.font constrainedToSize:maximumLabelSize lineBreakMode:target.lineBreakMode];
    target.frame = CGRectMake(target.frame.origin.x, target.frame.origin.y, target.frame.size.width, expectedLabelSize.height + (iOS7 ? 2 : 0));
    target.numberOfLines = 0;
}

+ (void)widthFitByText:(UILabel *)target
{
    [[self class] widthFitByText:target maxHeight:MAXFLOAT];
}

+ (void)widthFitByText:(UILabel *)target maxHeight:(CGFloat)maxHeight
{
    CGSize maximumLabelSize = CGSizeMake(296, maxHeight);
    CGSize expectedLabelSize = [target.text sizeWithFont:target.font constrainedToSize:maximumLabelSize lineBreakMode:target.lineBreakMode];
    target.frame = CGRectMake(target.frame.origin.x, target.frame.origin.y, expectedLabelSize.width, target.frame.size.height);
}

+ (CGSize)heightFitSizeWithText:(NSString *)text font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode maxWidth:(CGFloat)maxWidth
{
    CGSize maximumLabelSize = CGSizeMake(maxWidth, MAXFLOAT);
    return [text sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:lineBreakMode];
}

+ (CGSize)widthFitSizeWithText:(NSString *)text font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode maxHeight:(CGFloat)maxHeight
{
    CGSize maximumLabelSize = CGSizeMake(296, maxHeight);
    return [text sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:lineBreakMode];
}

@end