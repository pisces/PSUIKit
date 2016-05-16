//
//  PSImagePickerController.h
//  PSUIKit
//
//  Created by pisces on 2015. 7. 3..
//  Copyright (c) 2015년 Steve Kim. All rights reserved.
//

#import "PSTableViewController.h"
#import "PSAssetsGroupListViewController.h"
#import "PSNavigationController.h"

typedef void (^PickerCompletionBlock)(NSArray *results);

@protocol PickerControllerCompletion <NSObject>
@property (nonatomic, copy) PickerCompletionBlock completion;
@end

@interface PSImagePickerController : PSNavigationController <PickerControllerCompletion, PSAssetListViewControllerDelegate>
@property (nonatomic) BOOL allowsMultipleSelection;
@property (nonatomic, copy) PickerCompletionBlock completion;
@property (nonatomic, readonly) PSAssetsGroupListViewController *assetsGroupListViewController;
@end
