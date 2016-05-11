//
//  PSBadge.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "PSBadge.h"

@implementation PSBadge
{
@private
    BOOL textChanged;
    CGSize maxSize;
    CGSize minSize;
    CGPadding padding;
}

// ================================================================================================
//  Overridden: PSUIView
// ================================================================================================

- (void)dealloc
{
}

- (void)commitProperties
{
    if (textChanged)
    {
        textChanged = NO;
        self.textLabel.text = self.text;
        
        CGSize maximumLabelSize = CGSizeMake(296, 9999);
        CGSize expectedLabelSize = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:maximumLabelSize lineBreakMode:self.textLabel.lineBreakMode];
        CGFloat w = fminf(maxSize.width, fmaxf(minSize.width, expectedLabelSize.width + padding.left + padding.right));
        CGFloat h = fminf(maxSize.height, fmaxf(minSize.height, expectedLabelSize.height + padding.top + padding.bottom));
        self.textLabel.frame = CGRectMake(padding.left, padding.top, w - padding.left - padding.right, h - padding.top - padding.bottom);
        self.imageView.size = CGSizeMake(w, h);
        self.size = CGSizeMake(w, h);
    }
}

// ================================================================================================
//  Public
// ================================================================================================

- (id)initWithBackgroundImage:(UIImage *)image maxSize:(CGSize)_maxSize minSize:(CGSize)_minSize padding:(CGPadding)_padding;
{
    self = [self initWithFrame:CGRectMake(0, 0, _minSize.width, _minSize.height)];
    
    if (self)
    {
        maxSize = _maxSize;
        minSize = _minSize;
        padding = _padding;
        _imageView = [[UIImageView alloc] initWithImage:image];
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_imageView];
        [self addSubview:_textLabel];
    }
    
    return self;
}

- (void)setText:(NSString *)text
{
    if ([text isEqualToString:_text])
        return;
    
    _text = text;
    textChanged = YES;
    
    [self invalidateProperties];
}

@end
