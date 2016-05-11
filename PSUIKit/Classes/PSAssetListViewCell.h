//
//  PSAssetListViewCell.h
//  PSUIKit
//
//  Created by pisces on 2015. 7. 3..
//  Copyright (c) 2015년 Steve Kim. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "PSCollectionViewCell.h"

@interface PSAssetListViewCell : PSCollectionViewCell
@property (nonatomic) BOOL allowsOverlayImageShow;
@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@end
