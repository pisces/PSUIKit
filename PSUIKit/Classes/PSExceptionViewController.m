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
        self.actionButton.hidden = !self.buttonTitleText;
        
        [self.actionButton setTitle:self.buttonTitleText forState:UIControlStateNormal];
        [self.actionButton.titleLabel sizeToFit];
        
        self.actionButton.width = MAX(120, self.actionButton.titleLabel.width + 40);
    }
    
    if (descriptionTextChanged)
    {
        descriptionTextChanged = NO;
        descriptionLabel.text = self.descriptionText;
    }
    
    if (imageChanged)
    {
        imageChanged = NO;
        imageView.image = self.image;
        imageView.size = self.image.size;
        
        [self layoutSubviews];
    }
    
    if (titleTextChanged)
    {
        titleTextChanged = NO;
        titleLabel.text = self.titleText;
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
    
    _padding = CGPaddingMake(15, 24, 15, 0);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    titleLabel.size = [titleLabel sizeThatFits:CGSizeMake(self.view.width - self.padding.left - self.padding.right, 0)];
    descriptionLabel.size = [descriptionLabel sizeThatFits:CGSizeMake(self.view.width - self.padding.left - self.padding.right, 0)];
    titleLabel.x = (self.view.width - titleLabel.width)/2;
    titleLabel.y = self.padding.top;
    descriptionLabel.x = (self.view.width - descriptionLabel.width)/2;
    descriptionLabel.y = titleLabel.y + titleLabel.height + 10;
    imageView.x = (self.view.width - imageView.width)/2;
    imageView.y = descriptionLabel.y + descriptionLabel.height + 10;
    self.actionButton.x = (self.view.width - self.actionButton.width)/2;
    self.actionButton.y = (imageView.image ? imageView.y + imageView.height : imageView.y) + 10;
    self.backgroundView.frame = self.view.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundView.lineHeight = 0;
    self.actionButton.hidden = !self.buttonTitleText;
    descriptionLabel.text = self.descriptionText;
    titleLabel.text = self.titleText;
    
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionButton setBackgroundColor:[UIColor colorWithRed:0.0 green:150/255.0 blue:1.0 alpha:1] cornerRadius:3 forState:UIControlStateNormal];
    [self.actionButton setBackgroundColor:[UIColor colorWithRed:0.0 green:180/255.0 blue:1.0 alpha:1] cornerRadius:3 forState:UIControlStateHighlighted];
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
    if ([self.delegate respondsToSelector:@selector(exceptionViewShouldShowWithController:)] &&
        ![self.delegate exceptionViewShouldShowWithController:self])
    {
        [self.view removeFromSuperview];
        return NO;
    }
    
    self.view.frame = CGRectMake(0, 0, self.superview.width, self.superview.height);
    
    if ([self.delegate respondsToSelector:@selector(controller:willDisplayView:)])
        [self.delegate controller:self willDisplayView:self.view];
    
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
    if ([self.delegate respondsToSelector:@selector(controller:buttonClicked:)])
        [self.delegate controller:self buttonClicked:sender];
}

@end
