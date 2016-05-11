//
//  PSAttributedDivisionLabel.m
//  PSUIKit
//
//  Created by Steve Kim on 2014. 8. 13..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2014년 hh963103@naver.com. All rights reserved.
//

#import "PSAttributedDivisionLabel.h"

@implementation PSAttributedDivisionLabel
{
@private
    BOOL initialized;
    BOOL textChanged;
}

// ================================================================================================
//  Overridden: OHAttributedLabel
// ================================================================================================

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self initProperties];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self initProperties];
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (!initialized)
    {
        initialized = YES;
        
        [self textChanged];
    }
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - getter/setter

- (void)setColors:(NSArray *)colors
{
    if ([colors isEqualToArray:_colors])
        return;
    
    _colors = colors;
    textChanged = YES;
    
    [self textChanged];
}

- (void)setFonts:(NSArray *)fonts
{
    if ([fonts isEqualToArray:_fonts])
        return;
    
    _fonts = fonts;
    textChanged = YES;
    
    [self textChanged];
}

// ================================================================================================
//  Private
// ================================================================================================

- (void)setText:(NSString *)text
{
    if ([text isEqualToString:super.text])
        return;
    
    super.text = text;
    textChanged = YES;
    
    [self textChanged];
}

- (void)textChanged
{
    if (self.superview && textChanged)
    {
        textChanged = NO;
        
        NSMutableAttributedString *attributedText = [NSMutableAttributedString attributedStringWithString:self.text];
        NSArray *array = [self.text componentsSeparatedByString:self.divider];
        
        for (NSUInteger i=0; i<array.count; i++)
        {
            NSString *pattern = [array objectAtIndex:i];
            NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionIgnoreMetacharacters error:NULL];
            NSArray *matches = [expression matchesInString:self.text options:0 range:NSMakeRange(0, self.text.length)];
            UIColor *color = i < self.colors.count ? [self.colors objectAtIndex:i] : [self.colors objectAtIndex:self.colors.count - 1];
            UIFont *font = i < self.fonts.count ? [self.fonts objectAtIndex:i] : [self.fonts objectAtIndex:self.fonts.count - 1];
            
            
            for (NSTextCheckingResult *match in matches)
            {
                [attributedText setTextColor:color range:match.range];
                [attributedText setFont:font range:match.range];
            }
        }
        
        if (self.paragraphStyle)
            [attributedText setParagraphStyle:self.paragraphStyle range:(NSRange) {0, self.text.length}];
        
        self.attributedText = attributedText;
    }
}

- (void)initProperties
{
    _divider = @"\n";
    _colors  = @[[UIColor colorWithRed:108/255.0 green:112/255.0 blue:125/255.0 alpha:1], [UIColor colorWithRed:30/255.0 green:40/255.0 blue:50/255.0 alpha:1], [UIColor colorWithRed:108/255.0 green:112/255.0 blue:125/255.0 alpha:1]];
    
    _fonts  = @[[UIFont systemFontOfSize:13], [UIFont systemFontOfSize:36], [UIFont systemFontOfSize:14]];
}

@end
