//
//  UILinedBackgroundView.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "PSLinedBackgroundView.h"
#import "PSUIKit.h"

@implementation PSLinedBackgroundView

// ================================================================================================
//  Overridden: UIView
// ================================================================================================

- (void)dealloc
{
    _seperatorColors = nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self initProperties];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initProperties];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIColor *color1 = _seperatorColors.count > 0 ? [_seperatorColors objectAtIndex:0] : [UIColor clearColor];
    UIColor *color2 = _seperatorColors.count > 1 ? [_seperatorColors objectAtIndex:1] : color1;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ((_lineDrawPosition & LineDrawPositionTop) == LineDrawPositionTop)
    {
        CGContextSetStrokeColorWithColor(context, color1.CGColor);
        CGContextSetLineWidth(context, _lineHeight);
        CGContextMoveToPoint(context, _linePadding.left, 0);
        CGContextAddLineToPoint(context, rect.size.width - _linePadding.right, 0);
        CGContextStrokePath(context);
    }
    
    if ((_lineDrawPosition & LineDrawPositionBottom) == LineDrawPositionBottom)
    {
        UIColor *color = _lineDrawPosition == (LineDrawPositionBottom | LineDrawPositionTop) ? color2 : color1;
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, _lineHeight);
        CGContextMoveToPoint(context, _linePadding.left, rect.size.height);
        CGContextAddLineToPoint(context, rect.size.width - _linePadding.right, rect.size.height);
        CGContextStrokePath(context);
    }
}

- (void)setLineDrawPosition:(LineDrawPosition)lineDrawPosition
{
    if (lineDrawPosition == _lineDrawPosition)
        return;
    
    _lineDrawPosition = lineDrawPosition;
    
    [self setNeedsDisplay];
}

- (void)setLineHeight:(CGFloat)lineHeight
{
    if (_lineHeight == lineHeight)
        return;
    
    _lineHeight = lineHeight;
    
    [self setNeedsDisplay];
}

- (void)setLinePadding:(CGPadding)linePadding
{
    if (CGPaddingEquals(_linePadding, linePadding))
        return;
    
    _linePadding = linePadding;
    
    [self setNeedsDisplay];
}

- (void)setSeperatorColors:(NSArray *)seperatorColors {
    if ([seperatorColors isEqualToArray:_seperatorColors])
        return;
    
    _seperatorColors = seperatorColors;
    
    [self setNeedsDisplay];
}

// ================================================================================================
//  Internal
// ================================================================================================

- (void)initProperties
{
    self.clearsContextBeforeDrawing = YES;
    _lineHeight = 1.0f;
    _lineDrawPosition = LineDrawPositionBottom | LineDrawPositionTop;
    _linePadding = CGPaddingMakeHorizontal(0, 0);
    _seperatorColors = @[[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
}
@end
