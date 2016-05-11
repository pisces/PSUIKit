//
//  PSCollectionViewCell.h
//  PSUIKit
//
//  Created by Steve Kim on 2015. 4. 11..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSCollectionViewCellProtectedMethods <NSObject>
- (void)commitProperties;
- (void)initProperties;
- (void)setUpSubviews;
@end

@interface PSCollectionViewCell : UICollectionViewCell <PSCollectionViewCellProtectedMethods>
@property (nonatomic, assign) BOOL allowsBackgroundViewFit;
@property (nonatomic) BOOL immediatelyUpdating;
+ (CGFloat)heightWithTableView:(UITableView *)tableView object:(id)object;
+ (NSString *)reuseIdentifier;
- (void)invalidateProperties;
@end
