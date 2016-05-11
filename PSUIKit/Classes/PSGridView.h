//
//  PSGridView.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GraphicsLayout.h"
#import "base.h"
#import "PSGridViewCell.h"

enum {
    UIGridViewItemAlignVertical = 0,
    UIGridViewItemAlignHorizontal = 1
};
typedef NSInteger UIGridViewItemAlign;

enum {
    UIGridViewSubviewTagHeaderView = 1,
    UIGridViewSubviewTagFooterView = 2,
    UIGridViewSubviewTagCellIndicatorView = 3
};
typedef NSInteger UIGridViewSubviewTag;

@protocol UIGridViewDataSource;
@protocol UIGridViewDelegate;

@interface PSGridView : PSView <UIGestureRecognizerDelegate>
@property (nonatomic) BOOL selectable;
@property (nonatomic) UIGridViewItemAlign itemAlign;
@property (nonatomic) int columnCount;
@property (nonatomic) int rowCount;
@property (nonatomic) CGPadding padding;
@property (nonatomic, weak) IBOutlet id<UIGridViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<UIGridViewDelegate, UIScrollViewDelegate> delegate;
@property (nonatomic, readonly) UIScrollView *scrollView;
- (PSGridViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (PSGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (UIView *)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier;
- (void)initProperties;
- (void)reloadData;
- (void)removeSelectionWithIndexPathWillBeSelect:(NSIndexPath *)indexPath;
- (BOOL)setSelectionWithIndexPath:(NSIndexPath *)indexPath;
@end

@protocol UIGridViewDataSource <NSObject>
@required
- (NSInteger)sectionCountInGridView:(PSGridView *)gridView;

@required
- (NSInteger)gridView:(PSGridView *)gridView itemCountInSection:(NSInteger)section;

@required
- (PSGridViewCell *)gridView:(PSGridView *)gridView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (UIView *)gridView:(PSGridView *)gridView headerViewInSection:(NSInteger)section;

@optional
- (UIView *)gridView:(PSGridView *)gridView footerViewInSection:(NSInteger)section;

@optional
- (CGFloat)gridView:(PSGridView *)gridView headerHeightInSection:(NSInteger)section;

@optional
- (CGFloat)gridView:(PSGridView *)gridView headerWidthInSection:(NSInteger)section;

@optional
- (CGFloat)gridView:(PSGridView *)gridView footerHeightInSection:(NSInteger)section;

@optional
- (CGFloat)gridView:(PSGridView *)gridView footerWidthInSection:(NSInteger)section;
@end

@protocol UIGridViewDelegate <NSObject>
@optional
- (void)gridView:(PSGridView *)gridView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)gridView:(PSGridView *)gridView willDisplayCell:(PSGridViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)gridView:(PSGridView *)gridView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section;

@optional
- (void)gridView:(PSGridView *)gridView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section;
@end
