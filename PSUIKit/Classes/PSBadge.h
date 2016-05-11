//
//  PSBadge.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "PSView.h"
#import "GraphicsLayout.h"
#import "UIView+PSUIKit.h"

@interface PSBadge : PSView
@property(nonatomic, strong) NSString *text;
@property(nonatomic, readonly) UILabel *textLabel;
@property(nonatomic, readonly) UIImageView *imageView;
- (id)initWithBackgroundImage:(UIImage *)image maxSize:(CGSize)_maxSize minSize:(CGSize)_minSize padding:(CGPadding)_padding;
@end