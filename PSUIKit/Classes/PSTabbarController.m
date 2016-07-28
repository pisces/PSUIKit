//
//  PSTabbarController.m
//  PSUIKit
//
//  Created by Steve Kim on 7/28/16.
//  Copyright (c) 2016년 Steve Kim. All rights reserved.
//

#import "PSTabbarController.h"
#import "UIViewControllerStack.h"

@interface PSTabbarController () <PSButtonBarDelegate, UIViewControllerStackDelegate>
@property (nullable, nonatomic, strong) NSArray<UIViewController *> *controllers;
@end

@implementation PSTabbarController
{
    BOOL buttonBarHeightChanged;
    BOOL controllersChanged;
    UIViewControllerStack *controllerStack;
}

#pragma mark - Overridden: PSViewController

- (void)commitProperties {
    if (buttonBarHeightChanged) {
        buttonBarHeightChanged = NO;
        
        [self layoutSubviews];
    }
    
    if (controllersChanged) {
        controllersChanged = NO;
        controllerStack.controllers = _controllers;
        _buttonBar.numOfButtons = _controllers.count;
    }
}

- (void)layoutSubviews {
    _buttonBar.size = CGSizeMake(self.view.width, _buttonBarHeight);
    
    [_containerView setX:0 y:_buttonBarHeight width:self.view.width height:self.view.height - _buttonBarHeight];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _buttonBarHeight = 40;
    
    _buttonBar = [[PSButtonBar alloc] init];
    _buttonBar.delegate = self;
    
    _containerView = [[UIView alloc] init];
    
    controllerStack = [[UIViewControllerStack alloc] initWithParentViewController:self targetView:_containerView];
    controllerStack.delegate = self;
    
    [self.view addSubview:_buttonBar];
    [self.view addSubview:_containerView];
}

#pragma mark - Public getter/setter

- (void)setButtonBarHeight:(CGFloat)buttonBarHeight {
    if (buttonBarHeight == _buttonBarHeight) {
        return;
    }
    
    _buttonBarHeight = buttonBarHeight;
    buttonBarHeightChanged = YES;
    
    [self invalidateProperties];
}

#pragma mark - Public methods

- (void)realoadData {
    if ([_dataSource respondsToSelector:@selector(childViewControllersWithController:)]) {
        self.controllers = [_dataSource childViewControllersWithController:self];
    }
}

#pragma mark - Private getter/setter

- (void)setControllers:(NSArray<UIViewController *> *)controllers {
    if ([controllers isEqual:_controllers]) {
        return;
    }
    
    _controllers = controllers;
    controllersChanged = YES;
    
    [self invalidateProperties];
}

#pragma mark - PSButtonBar delegate

- (void)buttonBar:(PSButtonBar *)buttonBar buttonClicked:(UIButton *)button buttonIndex:(NSInteger)buttonIndex {
    if ([_delegate respondsToSelector:@selector(didChangeTabIndex:)]) {
        [_delegate didChangeTabIndex:buttonIndex];
    }
}

- (void)buttonBar:(PSButtonBar *)buttonBar buttonRender:(UIButton *)button buttonIndex:(NSInteger)buttonIndex {
    button.font = [UIFont systemFontOfSize:13];
    
    [button setTitle:_controllers[buttonIndex].title forState:UIControlStateNormal];
    
    if ([_dataSource respondsToSelector:@selector(controller:renderWithTab:tabIndex:)]) {
        [_dataSource controller:self renderWithTab:button tabIndex:buttonIndex];
    }
}

#pragma mark - UIViewControllerStack delegate

- (void)stack:(UIViewControllerStack *)stack didChangeSelectionWithIndex:(NSInteger)index {
    if ([_delegate respondsToSelector:@selector(didChangeTabIndex:)]) {
        [_delegate didChangeTabIndex:index];
    }
}

@end
