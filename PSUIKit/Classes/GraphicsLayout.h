//
//  GraphicsLayout.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef PSUIKit_GraphicsLayout_h
#define PSUIKit_GraphicsLayout_h

typedef struct {
    unsigned int left;
    unsigned int top;
    unsigned int right;
    unsigned int bottom;
} CGPadding;

CGPadding CGPaddingMake(unsigned int left, unsigned int top, unsigned int right, unsigned int bottom);
CGPadding CGPaddingMakeAll(unsigned int value);
CGPadding CGPaddingMakeHorizontal(unsigned int left, unsigned int right);
CGPadding CGPaddingMakeVertical(unsigned int top, unsigned int bottom);
BOOL CGPaddingEquals(CGPadding padding1, CGPadding padding2);
BOOL CGPaddingZero(CGPadding padding);

#endif

@interface GraphicsLayout : NSObject
+ (void)fitByText:(UILabel *)target;
+ (void)fitByText:(UILabel *)target maxSize:(CGSize)maxSize;
+ (void)heightFitByText:(UILabel *)target;
+ (void)heightFitByText:(UILabel *)target maxWidth:(CGFloat)maxWidth;
+ (void)widthFitByText:(UILabel *)target;
+ (void)widthFitByText:(UILabel *)target maxHeight:(CGFloat)maxHeight;
+ (CGSize)heightFitSizeWithText:(NSString *)text font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode maxWidth:(CGFloat)maxWidth;
+ (CGSize)widthFitSizeWithText:(NSString *)text font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode maxHeight:(CGFloat)maxHeight;
@end
