//
//  PSImagePickerController.m
//  PSUIKit
//
//  Created by pisces on 2015. 7. 3..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "PSImagePickerController.h"
#import "PSUIKit.h"

@interface PSImagePickerController ()
@end

@implementation PSImagePickerController

// ================================================================================================
//  Overridden: MoveModalNavigationController
// ================================================================================================

#pragma mark - Overridden: MoveModalNavigationController

- (void)dealloc {
}

- (id)init {
    PSAssetsGroupListViewController *rootViewController = [PSAssetsGroupListViewController controllerWithBundle:[PSUIKit bundle]];
    self = [super initWithRootViewController:rootViewController];
    
    if (self) {
        _allowsMultipleSelection = YES;
        rootViewController.allowsMultipleSelection = self.allowsMultipleSelection;
        rootViewController.assetListViewDelegate = self;
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    if (allowsMultipleSelection == _allowsMultipleSelection)
        return;
    
    _allowsMultipleSelection = allowsMultipleSelection;
    self.assetsGroupListViewController.allowsMultipleSelection = allowsMultipleSelection;
}

// ================================================================================================
//  Protocol Implementation
// ================================================================================================

#pragma mark - PSAssetListViewController delegate

- (void)controller:(PSAssetListViewController *)controller didFinishPickingImages:(NSArray *)images {
    self.view.userInteractionEnabled = NO;
    
    if (self.completion) {
        self.completion(images);
        self.completion = nil;
    }
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private getter/setter

- (PSAssetsGroupListViewController *)assetsGroupListViewController {
    return (PSAssetsGroupListViewController *) self.childViewControllers.firstObject;
}

@end