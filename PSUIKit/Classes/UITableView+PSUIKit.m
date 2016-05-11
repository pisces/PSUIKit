//
//  UITableView+PSUIKit.m
//  PSUIKit
//
//  Created by Steve Kim on 2015. 5. 14..
//  Copyright (c) 2015 Steve Kim. All rights reserved.
//

#import "UITableView+PSUIKit.h"
#import "PSUIKit.h"

@implementation UITableView (org_apache_PSUIKit_UITableView)

// ================================================================================================
//  Public
// ================================================================================================

- (id<UITableViewHeaderFooterViewProtocol>)baseHeaderView
{
    id<UITableViewHeaderFooterViewProtocol> view = nil;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        static NSString *HeaderReuseIdentifier = @"TableViewSectionHeaderViewIdentifier";
        view = [self dequeueReusableHeaderFooterViewWithIdentifier:HeaderReuseIdentifier];
        
        if (!view)
            view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderReuseIdentifier];
    }
    else
    {
        static NSString *HeaderReuseIdentifier = @"PSUIKitHeaderCell";
        view = (UITableViewCell *)[self dequeueReusableCellWithIdentifier:HeaderReuseIdentifier];
        
        if (!view)
        {
            view = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeaderReuseIdentifier];
            ((UITableViewCell *)view).backgroundColor = [UIColor clearColor];
        }
    }
    
    view.backgroundView = [self createBaseHeaderBackgroundView];
    
    return view;
}

- (UIView *)createBaseHeaderBackgroundView
{
    PSLinedBackgroundView *backgroundView = [[PSLinedBackgroundView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.seperatorColors = @[[UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1]];
    return backgroundView;
}

- (void)setTableEmtpyFooterViewHeight:(CGFloat)tableEmtpyFooterViewHeight
{
    if (tableEmtpyFooterViewHeight)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, tableEmtpyFooterViewHeight)];
        view.tag = self.hash + view.hash;
        view.backgroundColor = [UIColor clearColor];
        self.tableFooterView = view;
    }
    else
        self.tableFooterView = nil;
}

- (CGFloat)tableEmtpyFooterViewHeight
{
    return self.tableEmtpyFooterView.height;
}

- (UIView *)tableEmtpyFooterView
{
    UIView *footerView = self.tableFooterView;
    return (footerView && (footerView.tag == self.hash + footerView.hash)) ? footerView : nil;
}

- (void)setTableEmtpyHeaderViewHeight:(CGFloat)tableEmtpyHeaderViewHeight
{
    if (tableEmtpyHeaderViewHeight)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, tableEmtpyHeaderViewHeight)];
        view.tag = self.hash + view.hash;
        view.backgroundColor = [UIColor clearColor];
        self.tableHeaderView = view;
    }
    else
        self.tableHeaderView = nil;
}

- (CGFloat)tableEmtpyHeaderViewHeight
{
    return self.tableEmtpyHeaderView.height;
}

- (UIView *)tableEmtpyHeaderView
{
    UIView *headerView = self.tableHeaderView;
    return (headerView && (headerView.tag == self.hash + headerView.hash)) ? headerView : nil;
}

@end
