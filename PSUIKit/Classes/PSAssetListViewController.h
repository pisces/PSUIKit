//
//  PSAssetListViewController.h
//  PSUIKit
//
//  Created by pisces on 2015. 7. 3..
//  Copyright (c) 2015년 Steve Kim. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "PSViewController.h"
#import "PSAssetListViewCell.h"
#import "PSAssetsGroupViewController.h"

@protocol PSAssetListViewControllerDelegate;

@interface PSAssetListViewController : PSViewController <PSAssetsGroupViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) BOOL allowsMultipleSelection;
@property (nonatomic) CGFloat minSpacing;
@property (nonatomic) NSUInteger numOfColumns;
@property (nonatomic, strong) ALAssetsGroup *group;
@property (nonatomic, weak) id<PSAssetListViewControllerDelegate> delegate;
@end

@protocol PSAssetListViewControllerDelegate <NSObject>
- (void)controller:(PSAssetListViewController *)controller didFinishPickingImages:(NSArray *)images;
@end