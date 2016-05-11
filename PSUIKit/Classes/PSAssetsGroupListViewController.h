//
//  PSAssetsGroupListViewController.h
//  PSUIKit
//
//  Created by pisces on 2015. 7. 3..
//  Copyright (c) 2015년 Steve Kim. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "PSTableViewController.h"
#import "PSAssetsGroupListViewCell.h"
#import "PSAssetListViewController.h"

@interface PSAssetsGroupListViewController : PSTableViewController
@property (nonatomic) BOOL allowsMultipleSelection;
@property (nonatomic, weak) id<PSAssetListViewControllerDelegate> assetListViewDelegate;
@property (nonatomic, readonly) ALAssetsLibrary *assetLibrary;
@end
