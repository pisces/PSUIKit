//
//  UITableView+PSUIKit.h
//  PSUIKit
//
//  Created by Steve Kim on 2015. 5. 14..
//  Copyright (c) 2015 Steve Kim. All rights reserved.
//

#import "PSLinedBackgroundView.h"

@protocol UITableViewHeaderFooterViewProtocol <NSCoding, UIAppearance, UIAppearanceContainer, UIDynamicItem>
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, readonly) UILabel *textLabel;
@end

@interface UITableViewHeaderFooterView (org_apache_PSUIKit_UITableViewHeaderFooterView) <UITableViewHeaderFooterViewProtocol>
@end

@interface UITableViewCell (org_apache_PSUIKit_UITableViewCell) <UITableViewHeaderFooterViewProtocol>
@end

@interface UITableView (org_apache_PSUIKit_UITableView)
@property (nonatomic) CGFloat tableEmtpyFooterViewHeight;
@property (readonly) UIView *tableEmtpyFooterView;
@property (nonatomic) CGFloat tableEmtpyHeaderViewHeight;
@property (readonly) UIView *tableEmtpyHeaderView;
- (UIView *)createBaseHeaderBackgroundView;
- (id<UITableViewHeaderFooterViewProtocol>)baseHeaderView;
@end
