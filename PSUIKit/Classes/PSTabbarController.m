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
@property (nonatomic, readonly) CGFloat buttonBarYPos;
@property (nonatomic, readonly) CGFloat containerViewYPos;
@property (nullable, nonatomic, strong) NSArray<UIViewController *> *controllers;
@end

@implementation PSTabbarController
{
    BOOL controllersChanged;
    BOOL dataSourceChanged;
    BOOL pagingEnabledChanged;
    BOOL selectedIndexChanged;
    BOOL shouldUpdateLayout;
    UIViewControllerStack *controllerStack;
}

#pragma mark - Overridden: PSViewController

- (void)commitProperties {
    if (pagingEnabledChanged) {
        pagingEnabledChanged = NO;
        _containerView.pagingEnabled = _pagingEnabled;
    }
    
    if (shouldUpdateLayout) {
        shouldUpdateLayout = NO;
        [self updateLayout];
    }
    
    if (controllersChanged) {
        controllersChanged = NO;
        controllerStack.controllers = _controllers;
        controllerStack.selectedIndex = _selectedIndex;
        _buttonBar.numOfButtons = _controllers.count;
        _buttonBar.selectedIndex = _selectedIndex;
    }
    
    if (dataSourceChanged) {
        dataSourceChanged = NO;
        [self realoadData];
    }
    
    if (selectedIndexChanged) {
        selectedIndexChanged = NO;
        controllerStack.selectedIndex = _selectedIndex;
        _buttonBar.selectedIndex = _selectedIndex;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _selectedIndex = 0;
    _tabbarPosition = PSTabbarPositionTop;
    
    _buttonBar = [[PSButtonBar alloc] init];
    _buttonBar.delegate = self;
    _buttonBar.height = _buttonBarHeight;
    _buttonBar.toggle = YES;
    
    _containerView = [[UIScrollView alloc] init];
    
    controllerStack = [[UIViewControllerStack alloc] initWithParentViewController:self targetView:_containerView];
    controllerStack.delegate = self;
    
    [self.view addSubview:_buttonBar];
    [self.view addSubview:_containerView];
    
    self.buttonBarHeight = 40;
}

#pragma mark - Public getter/setter

- (void)setButtonBarHeight:(CGFloat)buttonBarHeight {
    if (buttonBarHeight == _buttonBarHeight) {
        return;
    }
    
    _buttonBarHeight = buttonBarHeight;
    shouldUpdateLayout = YES;
    
    [self invalidateProperties];
}

- (void)setDataSource:(id<PSTabbarControllerDataSource>)dataSource {
    if ([dataSource isEqual:_dataSource]) {
        return;
    }
    
    _dataSource = dataSource;
    dataSourceChanged = YES;
    
    [self invalidateProperties];
}

- (void)setPagingEnabled:(BOOL)pagingEnabled {
    if (pagingEnabled == _pagingEnabled) {
        return;
    }
    
    _pagingEnabled = pagingEnabled;
    pagingEnabledChanged = YES;
    
    [self invalidateProperties];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex == _selectedIndex) {
        return;
    }
    
    _selectedIndex = selectedIndex;
    selectedIndexChanged = YES;
    
    [self invalidateProperties];
}

- (void)setTabbarPosition:(PSTabbarPosition)tabbarPosition {
    if (tabbarPosition == _tabbarPosition) {
        return;
    }
    
    _tabbarPosition = tabbarPosition;
    shouldUpdateLayout = YES;
    
    [self invalidateProperties];
}

#pragma mark - PSButtonBar delegate

- (void)buttonBar:(PSButtonBar *)buttonBar buttonRender:(UIButton *)button buttonIndex:(NSInteger)buttonIndex {
    button.font = [UIFont systemFontOfSize:13];
    
    [button setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1] cornerRadius:0 forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor] cornerRadius:0 forState:UIControlStateHighlighted];
    [button setBackgroundColor:[UIColor whiteColor] cornerRadius:0 forState:UIControlStateSelected];
    [button setTitle:_controllers[buttonIndex].title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if ([_dataSource respondsToSelector:@selector(controller:renderWithTab:tabIndex:)]) {
        [_dataSource controller:self renderWithTab:button tabIndex:buttonIndex];
    }
}

- (void)buttonBar:(PSButtonBar *)buttonBar buttonSelected:(UIButton *)button buttonIndex:(NSInteger)buttonIndex {
    controllerStack.selectedIndex = buttonIndex;
    
    if ([_delegate respondsToSelector:@selector(didChangeTabIndex:)]) {
        [_delegate didChangeTabIndex:buttonIndex];
    }
}

#pragma mark - UIViewControllerStack delegate

- (void)stack:(UIViewControllerStack *)stack didChangeSelectionWithIndex:(NSInteger)index {
    _buttonBar.selectedIndex = index;
    
    if ([_delegate respondsToSelector:@selector(didChangeTabIndex:)]) {
        [_delegate didChangeTabIndex:index];
    }
}

#pragma mark - Private getter/setter

- (CGFloat)buttonBarYPos {
    return _tabbarPosition == PSTabbarPositionBottom ? self.view.height - _buttonBarHeight : 0;
}

- (CGFloat)containerViewYPos {
    return _tabbarPosition == PSTabbarPositionBottom ? 0 : _buttonBarHeight;
}

- (void)setControllers:(NSArray<UIViewController *> *)controllers {
    if ([controllers isEqual:_controllers]) {
        return;
    }
    
    _controllers = controllers;
    controllersChanged = YES;
    
    [self invalidateProperties];
}

#pragma mark - Private methods

- (void)realoadData {
    if (_dataSource && [_dataSource respondsToSelector:@selector(childViewControllersWithController:)]) {
        self.controllers = [_dataSource childViewControllersWithController:self];
        _buttonBar.numOfButtons = _controllers.count;
    }
}

- (void)updateLayout {
    [_buttonBar setX:0 y:self.buttonBarYPos width:self.view.width height:_buttonBarHeight];
    [_containerView setX:0 y:self.containerViewYPos width:self.view.width height:self.view.height - _buttonBarHeight];
}

@end
