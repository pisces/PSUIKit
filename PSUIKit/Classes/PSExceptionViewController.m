//
//  PSExceptionViewController.m
//  PSUIKit
//
//  Created by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2015년 hh963103@gmail.com. All rights reserved.
//

#import "PSExceptionViewController.h"
#import "PSUIKit.h"

@interface PSExceptionViewController ()
@property (nonatomic, readonly) UIView *superview;
@end

@implementation PSExceptionViewController
{
@private
    BOOL buttonTitleTextChanged;
    BOOL descriptionTextChanged;
    BOOL imageChanged;
    BOOL isViewNeedsLayout;
    BOOL titleTextChanged;
}

// ================================================================================================
//  Overridden: PSViewController
// ================================================================================================

#pragma mark - Overridden: PSViewController

- (void)commitProperties
{
    if (buttonTitleTextChanged)
    {
        buttonTitleTextChanged = NO;
        _actionButton.hidden = !_buttonTitleText;
        
        [_actionButton setTitle:_buttonTitleText forState:UIControlStateNormal];
        [_actionButton.titleLabel sizeToFit];
        
        _actionButton.width = MAX(120, self.actionButton.titleLabel.width + 40);
    }
    
    if (descriptionTextChanged)
    {
        descriptionTextChanged = NO;
        _descriptionLabel.text = self.descriptionText;
    }
    
    if (imageChanged)
    {
        imageChanged = NO;
        _imageView.image = _image;
        _imageView.size = _image.size;
        _imageView.hidden = _image == nil;
        
        [self layoutSubviews];
    }
    
    if (titleTextChanged)
    {
        titleTextChanged = NO;
        _titleLabel.text = _titleText;
    }
    
    if (isViewNeedsLayout)
    {
        isViewNeedsLayout = NO;
        
        [self layoutSubviews];
    }
}

- (void)dealloc
{
    _superview = nil;
}

- (void)initProperties {
    [super initProperties];
    
    _imagePosition = PSExceptionViewImagePositionBottom;
    _padding = CGPaddingMake(15, 24, 15, 0);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.size = [_titleLabel sizeThatFits:CGSizeMake(self.view.width - _padding.left - _padding.right, 0)];
    _descriptionLabel.size = [_descriptionLabel sizeThatFits:CGSizeMake(self.view.width - _padding.left - _padding.right, 0)];
    
    _titleLabel.x = (self.view.width - _titleLabel.width)/2;
    _descriptionLabel.x = (self.view.width - _descriptionLabel.width)/2;
    _imageView.x = (self.view.width - _imageView.width)/2;
    _actionButton.x = (self.view.width - _actionButton.width)/2;
    
    if (_imagePosition == PSExceptionViewImagePositionTop) {
        _imageView.y = _padding.top;
        _titleLabel.y = _imageView.image ? _imageView.bottom + 10 : _padding.top;
        _descriptionLabel.y = _titleText ? _titleLabel.bottom + 8 : _titleLabel.bottom;
        _actionButton.y = _descriptionLabel.bottom + 15;
    } else if (_imagePosition == PSExceptionViewImagePositionBottom) {
        _titleLabel.y = _padding.top;
        _descriptionLabel.y = _titleText ? _titleLabel.bottom + 8 : _titleLabel.bottom;
        _imageView.y = _descriptionLabel.bottom + 10;
        _actionButton.y = (_imageView.image ? _imageView.bottom : _descriptionLabel.bottom) + 15;
    }
    
    _backgroundView.frame = self.view.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backgroundView.lineHeight = 0;
    _actionButton.hidden = !_buttonTitleText;
    _imageView.hidden = _image == nil;
    _descriptionLabel.text = _descriptionText;
    _titleLabel.text = _titleText;
    
    [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_actionButton setBackgroundColor:[UIColor colorWithRed:0.0 green:150/255.0 blue:1.0 alpha:1] cornerRadius:3 forState:UIControlStateNormal];
    [_actionButton setBackgroundColor:[UIColor colorWithRed:0.0 green:180/255.0 blue:1.0 alpha:1] cornerRadius:3 forState:UIControlStateHighlighted];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (self.parentViewController)
        return [self.parentViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (self.parentViewController)
        return [self.parentViewController supportedInterfaceOrientations];
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    if (self.parentViewController)
        return [self.parentViewController shouldAutorotate];
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (self.parentViewController)
        return [self.parentViewController preferredInterfaceOrientationForPresentation];
    return UIInterfaceOrientationPortrait;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - getter/setter

- (void)setButtonTitleText:(NSString *)buttonTitleText
{
    if ([buttonTitleText isEqualToString:_buttonTitleText])
        return;
    
    _buttonTitleText = buttonTitleText;
    buttonTitleTextChanged = YES;
    
    [self invalidateProperties];
}

- (void)setDelegate:(id<PSExceptionViewControllerDelegate>)delegate
{
    if ([delegate isEqual:_delegate])
        return;
    
    _delegate = delegate;
    
    [self invalidateProperties];
}

- (void)setDescriptionText:(NSString *)descriptionText
{
    if ([descriptionText isEqualToString:_descriptionText])
        return;
    
    _descriptionText = descriptionText;
    descriptionTextChanged = isViewNeedsLayout = YES;
    
    [self invalidateProperties];
}

- (void)setPadding:(CGPadding)padding
{
    if (CGPaddingEquals(padding, _padding))
        return;
    
    _padding = padding;
    isViewNeedsLayout = YES;
    
    [self invalidateProperties];
}

- (void)setTitleText:(NSString *)titleText
{
    if ([titleText isEqualToString:_titleText])
        return;
    
    _titleText = titleText;
    titleTextChanged = isViewNeedsLayout = YES;
    
    [self invalidateProperties];
}

- (void)setImage:(UIImage *)image
{
    if ([image isEqual:_image])
        return;
    
    _image = image;
    imageChanged = isViewNeedsLayout = YES;
    
    [self invalidateProperties];
}

#pragma mark - Public methods

- (BOOL)checkVisibility
{
    if ([_delegate respondsToSelector:@selector(exceptionViewShouldShowWithController:)] &&
        ![_delegate exceptionViewShouldShowWithController:self])
    {
        [self.view removeFromSuperview];
        return NO;
    }
    
    self.view.frame = CGRectMake(0, 0, self.superview.width, self.superview.height);
    
    if ([_delegate respondsToSelector:@selector(controller:willDisplayView:)])
        [_delegate controller:self willDisplayView:self.view];
    
    [self.superview addSubview:self.view];
    
    return YES;
}

- (id)initWithSuperview:(UIView *)superview
{
    return [self initWithSuperview:superview offset:CGPointZero];
}

- (id)initWithSuperview:(UIView *)superview offset:(CGPoint)offset
{
    self = [[PSExceptionViewController class] controllerWithBundle:[PSUIKit bundle]];
    
    if (self)
    {
        _superview = superview;
        
        [self.view setX:offset.x y:offset.y];
    }
    
    return self;
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Button selector

- (IBAction)buttonClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(controller:buttonClicked:)])
        [_delegate controller:self buttonClicked:sender];
}

@end
