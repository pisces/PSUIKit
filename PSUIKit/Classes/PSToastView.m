//
//  PSToastView.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "PSToastView.h"
#import "PSUIKit.h"

@implementation PSToastView
{
@private
    UIView *targetView;
}

// ================================================================================================
//  Overridden: PSView
// ================================================================================================

#pragma mark - Overridden: PSView

- (void)dealloc
{
    [_backgroundView removeFromSuperview];
    [_textLabel removeFromSuperview];
    
    _backgroundView = nil;
    _textLabel = nil;
}

- (void)initProperties
{
    [super initProperties];
    
    self.backgroundView = [[PSToastViewBackgroundView alloc] initWithFrame:self.bounds];
    _hideTimeInterval = 3.0;
    _padding = CGPaddingMake(8, 9, 8, 16);
    _position = PSToastViewPostionTop;
    _textLabel = [[UILabel alloc] init];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
}

- (void)setUpSubviews {
    [super setUpSubviews];
    
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont systemFontOfSize:13];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.numberOfLines = 0;
    
    [self addSubview:self.textLabel];
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public class methods

+ (PSToastView *)sharedToastView {
    static PSToastView *instance;
    static dispatch_once_t precate;
    
    dispatch_once(&precate, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

#pragma mark - Public getter/setter

- (void)setBackgroundView:(UIView *)backgroundView
{
    if ([backgroundView isEqual:_backgroundView])
        return;
    
    if (_backgroundView) {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
    }
    
    _backgroundView = backgroundView;
    
    if (_backgroundView) {
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleAll;
        _backgroundView.frame = self.bounds;
        
        [self insertSubview:_backgroundView atIndex:0];
        [self setNeedsLayout];
    }
}

- (void)setPosition:(PSToastViewPostion)position {
    if (position == _position)
        return;
    
    _position = position;
    self.backgroundView.transform = CGAffineTransformMakeScale(1.0, position == PSToastViewPostionTop ? 1.0 : -1.0);
}

#pragma mark - Public methods

- (void)hide
{
    [self hideWithAnimated:YES];
}

- (void)hideWithAnimated:(BOOL)animated
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:self];

    if (animated) {
        CGPoint point = [targetView.superview convertPoint:targetView.origin toView:targetView.window];
        CGFloat y = self.position == PSToastViewPostionTop ? point.y : point.y + targetView.height - self.height/2;
        
        [UIView animateWithDuration:0.15 delay:0 options:animationOptions animations:^(void){
            self.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.center = CGPointMake(point.x + targetView.width/2, y);
            self.alpha = 0;
        } completion:^(BOOL finished){
            targetView = nil;
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [self removeFromSuperview];
        }];
    } else {
        targetView = nil;
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [self removeFromSuperview];
    }
}

- (void)showWithView:(UIView *)view message:(NSString *)message {
    [self showWithView:view message:message position:PSToastViewPostionTop];
}

- (void)showWithView:(UIView *)view message:(NSString *)message position:(PSToastViewPostion)position {
    [self hideWithAnimated:NO];
    
    targetView = view;
    self.textLabel.text = message;
    self.hidden = YES;
    self.position = position;
    
    [view.window addSubview:self];
    
    CGSize textLabelSize = [self.textLabel sizeThatFits:CGSizeMake(targetView.window.width - 30, 0)];
    
    [self.textLabel setX:self.padding.left y:self.padding.top + (self.position == PSToastViewPostionTop ? 0 : 9) width:textLabelSize.width height:textLabelSize.height];
    
    self.size = CGSizeMake(textLabelSize.width + self.padding.left + self.padding.right, MAX(textLabelSize.height + self.padding.top + self.padding.bottom, 45));
    CGPoint point = [targetView.superview convertPoint:targetView.origin toView:targetView.window];
    CGFloat y = self.position == PSToastViewPostionTop ? point.y : point.y + targetView.height;
    self.center = CGPointMake(point.x + targetView.width/2, y);
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.alpha = 0;
    self.hidden = NO;
    
    [UIView animateWithDuration:0.2 delay:0 options:animationOptions animations:^(void){
        CGFloat y = self.position == PSToastViewPostionTop ? point.y - self.height/2 + 2 : point.y + targetView.height + self.height/2 - 2;
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.center = CGPointMake(point.x + targetView.width/2, y);
        self.alpha = 1;
    } completion:^(BOOL finished){
    }];
    
    [self performSelector:@selector(hide) withObject:self afterDelay:self.hideTimeInterval];
}

@end


@implementation PSToastViewBackgroundView
{
@private
    UIImageView *centerImageView;
    UIImageView *leftImageView;
    UIImageView *rightImageView;
}

// ================================================================================================
//  Overridden: PSView
// ================================================================================================

#pragma mark - Overridden: PSView

- (void)initProperties {
    [super initProperties];
    
    centerImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"PSUIKit.bundle/bg_toast_center_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 9, 0)]];
    leftImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"PSUIKit.bundle/bg_toast_left_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 18, 0)]];
    rightImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"PSUIKit.bundle/bg_toast_right_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 0, 18, 9)]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [centerImageView setX:(self.width - centerImageView.width)/2 y:0 width:centerImageView.width height:self.height];
    [rightImageView setX:centerImageView.right y:0 width:self.width - centerImageView.right height:self.height];
    leftImageView.size = CGSizeMake(centerImageView.x, self.height);
}

- (void)setUpSubviews {
    [super setUpSubviews];
    
    [self addSubview:centerImageView];
    [self addSubview:leftImageView];
    [self addSubview:rightImageView];
}

@end