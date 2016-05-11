//
//  PSTableViewCell.h
//  PSUIKit
//
//  Created by Steve Kim on 2014. 8. 24..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2014년 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSLinedBackgroundView.h"

@protocol PSUITableViewCellProtectedMethods <NSObject>
- (void)commitProperties;
- (void)initProperties;
- (void)setUpSubviews;
@end

@interface PSTableViewCell : UITableViewCell <PSUITableViewCellProtectedMethods>
@property (nonatomic, assign) BOOL allowsBackgroundViewFit;
@property (nonatomic) BOOL immediatelyUpdating;
@property (nonatomic, readonly) PSLinedBackgroundView *linedBackgroundView;
@property (nonatomic, readonly) PSLinedBackgroundView *selectedLinedBackgroundView;
+ (NSString *)reuseIdentifier;
+ (PSTableViewCell *)sharedInstance;
- (void)invalidateProperties;
- (CGFloat)heightWithSuperview:(UIView *)superview object:(id)object;
@end