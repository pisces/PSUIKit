//
//  PSViewController.m
//  PSUIKit
//
//  Created by Steve Kim on 2014. 8. 24..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2014년 Steve Kim. All rights reserved.
//

#import "PSViewController.h"
#import "PSUIKit.h"
#import "Reachability+PSUIKit.h"

@interface PSViewController () <PSExceptionViewControllerDelegate>
@property (nonatomic, strong) PSExceptionViewDisplaySequence *exceptionViewDisplaySequence;
@end

@implementation PSViewController
{
@private
    BOOL shouldResetFirstViewAppearence;
    id<UIThemeProtocol> origineTheme;
    PSViewWillCloseBlock closeBlock;
}

// ================================================================================================
//  Overridden: UIViewController
// ================================================================================================

#pragma mark - Overridden: UIViewController

- (BOOL)closeAnimated:(BOOL)animated completion:(void (^)(void))completion {
    BOOL canClosed = (!self.presentedViewController.isBeingDismissed && !self.isBeingDismissed);
    
    if (canClosed && closeBlock) {
        closeBlock();
        closeBlock = nil;
    }
    
    return [super closeAnimated:animated completion:completion];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self initProperties];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        [self initProperties];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)])
        self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self layoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:YES];
    [self updateWithReachability:[Reachability defaultReachability]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _isViewAppeared = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [self invalidateProperties];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _hasPresentedViewController = self.presentedViewController != nil;
    
    [self endDataLoading];
    [[PSPreloader sharedInstance] hideWithStatus:PSPreloaderStatusCompletion animated:NO completion:NULL];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (!shouldResetFirstViewAppearence)
        _isFirstViewAppearence = NO;
    
    shouldResetFirstViewAppearence = NO;
    _isViewAppeared = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public methods

- (void)invalidateProperties
{
    if (self.isViewLoaded || self.immediatelyUpdating)
        [self commitProperties];
}

- (void)layoutSubviews
{
}

- (void)validateProperties
{
    [self commitProperties];
}

- (void)willClose:(PSViewWillCloseBlock)close {
    closeBlock = close;
}

// ================================================================================================
//  Protected
// ================================================================================================

- (void)commitProperties {
}

- (void)initProperties
{
    _isFirstViewAppearence = YES;
    
    [self updateWithReachability:[Reachability defaultReachability]];
}

- (void)resetFirstViewAppearence {
    _isFirstViewAppearence = YES;
    shouldResetFirstViewAppearence = YES;
}

- (void)setLeftBarButtonItem
{
    [self setLeftBarButtonItemWithTheme:self.navigationController.theme ? self.navigationController.theme : [UIApplication sharedApplication].theme];
}

- (void)setLeftBarButtonItemWithText:(NSString *)text
{
    [self setLeftBarButtonItemWithTheme:self.navigationController.theme ? self.navigationController.theme : [UIApplication sharedApplication].theme leftBarButtonItemText:text];
}

- (void)setLeftBarButtonItemWithTheme:(id<UIThemeProtocol>)theme
{
    [self setLeftBarButtonItemWithTheme:theme otherLeftBarButtonItem:[theme closeBarButtonItemWithTarget:self action:@selector(close)]];
}

- (void)setLeftBarButtonItemWithTheme:(id<UIThemeProtocol>)theme leftBarButtonItemText:(NSString *)text
{
    [self setLeftBarButtonItemWithTheme:theme otherLeftBarButtonItem:[theme leftBarButtonItemWithTitle:text target:self action:@selector(close)]];
}

- (void)updateWithReachability:(Reachability *)aReachability
{
    _isNotReachableBefore = _isNotReachable;
    _isNotReachable = aReachability.currentReachabilityStatus == NotReachable;
}

#pragma mark - PSExceptionViewController delegate

- (BOOL)exceptionViewShouldShowWithController:(PSExceptionViewController *)controller {
    return NO;
}

- (void)controller:(PSExceptionViewController *)controller buttonClicked:(id)sender {
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private getter/setter

- (PSExceptionViewDisplaySequence *)exceptionViewDisplaySequence {
    if (!_exceptionViewDisplaySequence)
        _exceptionViewDisplaySequence = [[PSExceptionViewDisplaySequence alloc] initWithDelegate:self];
    return _exceptionViewDisplaySequence;
}

#pragma mark - Private methods

- (void)setLeftBarButtonItemWithTheme:(id<UIThemeProtocol>)theme otherLeftBarButtonItem:(UIBarButtonItem *)otherItem
{
    if (self.navigationController.viewControllers.count > 1) {
        [self setBackBarButtonItemWithTitle:@"" withTheme:theme];
    } else if (![self.navigationItem getLeftBarButtonItem]) {
        [self.navigationItem addLeftBarButtonItem:otherItem];
    }
}

#pragma mark - Notification selector

- (void)reachabilityChanged:(NSNotification *)notification
{
    [self updateWithReachability:notification.userInfo[@"object"]];
}

@end