//
//  PSAssetsGroupListViewCell.h
//  PSUIKit
//
//  Created by pisces on 2015. 7. 3..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "PSTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PSAssetsGroupListViewCell : PSTableViewCell
@property (nonatomic, strong) ALAssetsGroup *group;
@end
