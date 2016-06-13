//
//  PSAlertView.m
//  PSUIKit
//
//  Created by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "PSAlertView.h"

#define defaultLineColor [UIColor colorWithRed:223/255.0 green:224/255.0 blue:229/255.0 alpha:1]

// ================================================================================================
//
//  PSAlertViewButtonBarLineView
//
// ================================================================================================

@interface PSAlertViewButtonBarLineView : PSView
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, weak) PSButtonBar *target;
@end

@implementation PSAlertViewButtonBarLineView
{
@private
    BOOL canUpdateDisplayList;
}

// ================================================================================================
//  Overridden: PSView
// ================================================================================================

#pragma mark - Overridden: PSView

- (void)commitProperties
{
    if (canUpdateDisplayList)
    {
        canUpdateDisplayList = NO;
        
        [self setNeedsDisplay];
    }
}

- (void)dealloc
{
    _color = nil;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat *rgb = (CGFloat *) CGColorGetComponents(self.color.CGColor);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, rgb[0], rgb[1], rgb[2], rgb[3]);
    CGContextMoveToPoint(context, 0.0, 1.0);
    CGContextAddLineToPoint(context, rect.size.width, 1.0);
    CGContextStrokePath(context);
    
    for (NSInteger i=1; i<self.target.numOfButtons; i++)
    {
        CGFloat x = i * self.target.buttonWidth;
        CGContextMoveToPoint(context, x, 1.0);
        CGContextAddLineToPoint(context, x, self.target.buttonHeight);
        CGContextStrokePath(context);
    }
}

- (id)initWithTarget:(PSButtonBar *)target
{
    self = [super init];
    
    if (self)
        self.target = target;
    
    return self;
}

- (void)initProperties
{
    self.color = defaultLineColor;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (void)setColor:(UIColor *)color
{
    if ([color isEqual:_color])
        return;
    
    _color = color;
    canUpdateDisplayList = YES;
    
    [self invalidateProperties];
}

- (void)setTarget:(PSButtonBar *)target
{
    if ([target isEqual:_target])
        return;
    
    _target = target;
    canUpdateDisplayList = YES;
    
    [self invalidateProperties];
}

@end

// ================================================================================================
//
//  PSAlertViewDelegateObject
//
// ================================================================================================

@interface PSAlertViewDelegateObject : NSObject <PSAlertViewDelegate>
@property (nonatomic, copy) PSAlertViewDismission dismissionBlock;
@end

@implementation PSAlertViewDelegateObject

- (void)dealloc
{
    self.dismissionBlock = NULL;
}

- (void)PSAlertView:(PSAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.dismissionBlock)
        self.dismissionBlock(alertView, buttonIndex, buttonIndex < 1);
    
    objc_removeAssociatedObjects(alertView);
}

@end

// ================================================================================================
//
//  PSAlertView
//
// ================================================================================================

@interface PSAlertView ()
@property (nonatomic, readonly) PSAlertView *lastAlertView;
@property (nonatomic, readonly) NSString *instanceKey;
@property (nonatomic, strong) PSButtonBar *buttonBar;
@property (nonatomic, readonly) UIWindow *window;
@end

@implementation PSAlertView
{
@private
    CGSize maximumMessageTextSize;
    NSMutableArray *buttonTitles;
    PSAlertViewButtonBarLineView *buttonBarLineView;
}

static const CGFloat contentViewMinHeight = 50.0;
static NSMutableDictionary *repeatTestMap;
static NSMutableArray *alertViewStack;
static UIView *modalView;

// ================================================================================================
//  Overridden: PSView
// ================================================================================================

#pragma mark - Overridden: PSView

- (void)dealloc
{
    [self.buttonBar removeFromSuperview];
    [self.headerView removeFromSuperview];
    [self.contentView removeFromSuperview];
    [self.messageLabel removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [buttonBarLineView removeFromSuperview];
    
    buttonBarLineView = nil;
    buttonTitles = nil;
    _buttonBar = nil;
    _headerView = nil;
    _contentView = nil;
    _messageLabel = nil;
    _titleLabel = nil;
    _message = nil;
    _title = nil;
    _delegate = nil;
}

- (void)initProperties
{
    if (!repeatTestMap)
         repeatTestMap = [NSMutableDictionary dictionary];
    
    if (!alertViewStack)
        alertViewStack = [NSMutableArray array];
    
    if (!modalView)
    {
        modalView = [[UIView alloc] init];
        modalView.backgroundColor = [UIColor blackColor];
    }
    
    buttonTitles = [NSMutableArray array];
    _contentPadding = CGPaddingMake(10, 10, 10, 10);
    _buttonHeight = 44;
    _headerViewHeight = 64;
    _buttonBar = [[PSButtonBar alloc] init];
    _headerView = [[PSLinedBackgroundView alloc] init];
    _contentView = [[UIView alloc] init];
    _titleLabel = [[PSAttributedDivisionLabel alloc] init];
    _messageLabel = [[UILabel alloc] init];
    buttonBarLineView = [[PSAlertViewButtonBarLineView alloc] initWithTarget:self.buttonBar];
    
    [self setProperties];
    [self.headerView addSubview:self.titleLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.buttonBar addSubview:buttonBarLineView];
    [self addSubview:self.headerView];
    [self addSubview:self.contentView];
    [self addSubview:self.buttonBar];
}

- (void)setUpSubviews
{
    [super setUpSubviews];
    
    CGFloat alertViewWidth = self.window.width - 50;
    
    maximumMessageTextSize = CGSizeMake(alertViewWidth - _contentPadding.left - _contentPadding.right, self.superview.height - 30 - self.headerViewHeight - self.buttonHeight);
    
    if (self.messageLabel)
        [GraphicsLayout heightFitByText:self.messageLabel maxWidth:maximumMessageTextSize.width];
    
    self.messageLabel.width = maximumMessageTextSize.width;
    self.headerView.width = self.buttonBar.width = alertViewWidth;
    self.headerView.height = self.headerViewHeight;
    self.contentView.width = self.messageLabel ? maximumMessageTextSize.width : (self.contentView.width > 0 ? self.contentView.width : maximumMessageTextSize.width);
    self.contentView.height = self.messageLabel.height = self.contentViewHeight;
    self.contentView.x = self.contentPadding.left;
    self.contentView.y = self.headerView.height + self.contentPadding.top;
    self.buttonBar.height = self.buttonHeight;
    self.buttonBar.y = self.contentView.y + self.contentView.height + self.contentPadding.bottom;
    buttonBarLineView.frame = self.buttonBar.bounds;
    
    self.size = CGSizeMake(alertViewWidth, self.headerView.height + self.contentView.height + self.contentPadding.top + self.contentPadding.bottom + self.buttonBar.height);
    self.center = self.superview.center;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public class methods

+ (PSAlertView *)alertViewWithContentView:(UIView *)contentView cancelButtonTitle:(NSString *)cancelButtonTitle dismission:(PSAlertViewDismission)dismission otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    return [[self class] alertViewWithTitle:nil contentView:contentView cancelButtonTitle:cancelButtonTitle dismission:dismission otherButtonTitles:otherButtonTitles, nil];
}

+ (PSAlertView *)alertViewWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle dismission:(PSAlertViewDismission)dismission otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    return [[self class] alertViewWithTitle:nil message:message cancelButtonTitle:cancelButtonTitle dismission:dismission otherButtonTitles:otherButtonTitles, nil];
}

+ (PSAlertView *)alertViewWithTitle:(NSString *)title contentView:(UIView *)contentView cancelButtonTitle:(NSString *)cancelButtonTitle dismission:(PSAlertViewDismission)dismission otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    PSAlertViewDelegateObject *delegate = [[PSAlertViewDelegateObject alloc] init];
    delegate.dismissionBlock = dismission;
    
    PSAlertView *alertView = [[PSAlertView alloc] initWithTitle:title message:nil delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    alertView.contentView = contentView;
    
    [alertView show];
    
    return alertView;
}

+ (PSAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle dismission:(void(^)(PSAlertView *alertView, NSInteger buttonIndex, BOOL cancel))dismission otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    PSAlertViewDelegateObject *delegate = [[PSAlertViewDelegateObject alloc] init];
    delegate.dismissionBlock = dismission;
    
    PSAlertView *alertView = [[PSAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    [alertView show];
    
    return alertView;
}

+ (void)dismissAll
{
    for (NSString *key in repeatTestMap)
        [repeatTestMap[key] dismissWithClickedButtonIndex:0 animated:NO];
}

#pragma mark - Public getter/setter

- (CGFloat)contentViewHeight
{
    CGFloat innerHeight = self.messageLabel ? self.messageLabel.height : self.contentView.height;
    return MIN(maximumMessageTextSize.height, MAX(contentViewMinHeight, self.contentPadding.top + innerHeight + self.contentPadding.bottom));
}

- (void)setContentView:(UIView *)contentView
{
    if ([contentView isEqual:_contentView])
        return;
    
    if (_contentView)
    {
        _messageLabel = nil;
        [_contentView removeFromSuperview];
    }
    
    _contentView = contentView;
    
    [self addSubview:_contentView];
}

#pragma mark - Public methods

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    modalView.alpha = 0.3;
    self.alpha = 1;
    self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    if ([self.delegate respondsToSelector:@selector(PSAlertView:willDismissWithButtonIndex:)])
        [self.delegate PSAlertView:self willDismissWithButtonIndex:buttonIndex];
    
    [alertViewStack removeObject:self];
    [repeatTestMap removeObjectForKey:self.instanceKey];
    
    void (^dismiss)(void) = ^void {
        if ([self.delegate respondsToSelector:@selector(PSAlertView:didDismissWithButtonIndex:)])
            [self.delegate PSAlertView:self didDismissWithButtonIndex:buttonIndex];
        
        if (alertViewStack.count < 1)
            [modalView removeFromSuperview];
        
        [self showLastAlertView];
        [self removeFromSuperview];
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.15 delay:0 options:animationOptions animations:^(void){
            if (alertViewStack.count < 1)
                modalView.alpha = 0;
            
            self.alpha = 0;
            self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished){
            dismiss();
        }];
    }
    else
    {
        dismiss();
    }
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    
    if (self)
    {
        self.title = title;
        self.message = message;
        
        if (cancelButtonTitle)
            [buttonTitles addObject:cancelButtonTitle];
        
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *arg=otherButtonTitles; arg!=nil; arg=va_arg(args, NSString*))
        {
            if (arg)
                [buttonTitles addObject:arg];
        }
        va_end(args);
        
        self.delegate = delegate;
        self.buttonBar.numOfButtons = buttonTitles.count;
    }
    
    return self;
}

- (void)show
{
    NSString *key = self.instanceKey;
    
    if (repeatTestMap[key])
        return;
    
    [self hideAlertViews];
    
    if (!self.title)
    {
        [self.headerView removeFromSuperview];
        self.headerView = nil;
    }
    
    if (buttonTitles.count < 1)
    {
        [buttonBarLineView removeFromSuperview];
        [self.buttonBar removeFromSuperview];
        self.buttonBar = nil;
        buttonBarLineView = nil;
    }
    
    self.messageLabel.text = self.message;
    self.titleLabel.text = self.title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.alpha = 0;
    
    if ([self.delegate respondsToSelector:@selector(PSAlertViewShouldEnableFirstOtherButton:)] &&
        self.buttonBar.numOfButtons > 1)
        ((UIButton *) [self.buttonBar.buttons objectAtIndex:1]).enabled = [self.delegate PSAlertViewShouldEnableFirstOtherButton:self];
    
    if (alertViewStack.count < 1)
    {
        modalView.alpha = 0;
        modalView.frame = self.window.bounds;
        
        [self.window addSubview:modalView];
    }
    
    [self.window addSubview:self];
    [alertViewStack addObject:self];
    [repeatTestMap setObject:self forKey:key];
    
    if ([self.delegate respondsToSelector:@selector(willPresentPSAlertView:)])
        [self.delegate willPresentPSAlertView:self];
    
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    [UIView animateWithDuration:0.3 animations:^{
        modalView.alpha = 0.3;
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(didPresentPSAlertView:)])
            [self.delegate didPresentPSAlertView:self];
    }];
}

- (void)showWithDismission:(PSAlertViewDismission)dismission
{
    PSAlertViewDelegateObject *delegate = [[PSAlertViewDelegateObject alloc] init];
    delegate.dismissionBlock = dismission;
    self.delegate = delegate;
    
    objc_setAssociatedObject(self, (__bridge const void *) @(delegate.hash), delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self show];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private getter/setter

- (NSString *)instanceKey
{
    return [(self.message ? self.message : @"").MD5 stringByAppendingFormat:@"::%@", self.title.MD5];
}

- (PSAlertView *)lastAlertView
{
    return alertViewStack.lastObject;
}

- (UIWindow *)window
{
    return [UIApplication sharedApplication].windows.lastObject;
}

#pragma mark - Private methods

- (void)hideAlertViews
{
    for (PSAlertView *alertView in alertViewStack)
        alertView.hidden = YES;
}

- (void)showLastAlertView
{
    self.lastAlertView.alpha = 0;
    self.lastAlertView.hidden = NO;
    self.lastAlertView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lastAlertView.alpha = 1;
        self.lastAlertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)setProperties
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 6.0f;
    self.buttonBar.delegate = self;
    buttonBarLineView.frame = self.buttonBar.bounds;
    
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _titleLabel.colors = @[[UIColor colorWithRed:30/255.0 green:40/255.0 blue:50/255.0 alpha:1]];
    _titleLabel.fonts = @[[UIFont systemFontOfSize:14]];
    _titleLabel.frame = _headerView.bounds;
    _titleLabel.centerVertically = YES;
    _titleLabel.textAlignment = _messageLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.font = _titleLabel.fonts.lastObject;
    _messageLabel.numberOfLines = 0;
    _messageLabel.textColor = _titleLabel.colors.lastObject;
    _headerView.backgroundColor = [UIColor colorWithRed:244/255.0 green:246/255.0 blue:250/255.0 alpha:1];
    
    ((PSLinedBackgroundView *) _headerView).seperatorColors = @[defaultLineColor];
    ((PSLinedBackgroundView *) _headerView).lineDrawPosition = LineDrawPositionBottom;
}

#pragma mark - UIButtonBar delegate

- (void)buttonBar:(PSButtonBar *)buttonBar buttonClicked:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex
{
    if ([self.delegate respondsToSelector:@selector(PSAlertView:clickedButtonAtIndex:)])
        [self.delegate PSAlertView:self clickedButtonAtIndex:buttonIndex];
    
    if (buttonIndex == 0 && [self.delegate respondsToSelector:@selector(PSAlertViewCancel:)])
        [self.delegate PSAlertViewCancel:self];
    
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)buttonBar:(PSButtonBar *)buttonBar buttonRender:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex
{
    button.titleLabel.font = buttonIndex > 0 ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:16];
    
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:244/255.0 green:246/255.0 blue:250/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [button setTitle:[buttonTitles objectAtIndex:buttonIndex] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:40/255.0 green:161/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [buttonBar bringSubviewToFront:buttonBarLineView];
}

@end

// ================================================================================================
//
//  Category: NSString (MD5)
//  Copyright iOSDeveloperTips.com All rights reserved.
//
// ================================================================================================

@implementation NSString (MD5)
- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 bytes MD5 hash value, store in buffer
    CC_MD5(ptr, (unsigned int) strlen(ptr), md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}
@end
