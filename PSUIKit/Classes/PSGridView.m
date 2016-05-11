//
//  PSGridView.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "PSGridView.h"

#define UIViewAutoResizingAll UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight

@implementation PSGridView
{
@private
    BOOL needsLayout;
    BOOL delegateChanged;
    NSMutableDictionary *dictionaryOfQueue;
    NSIndexPath *selectedIndexPath;
    UITapGestureRecognizer *tapGestureRecognizer;
}

// ================================================================================================
//  Overridden: PSView
// ================================================================================================

#pragma mark - Overridden: PSView

- (void)commitProperties
{
    if (needsLayout)
    {
        needsLayout = NO;
        
        [self setNeedsLayout];
    }
    
    if (delegateChanged)
    {
        delegateChanged = NO;
        _scrollView.delegate = _delegate;
    }
}

- (void)dealloc
{
    [dictionaryOfQueue removeAllObjects];
    [_scrollView removeGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer removeTarget:self action:@selector(tapGestureRecognized:)];
    
    tapGestureRecognizer = nil;
    dictionaryOfQueue = nil;
    _scrollView = nil;
}

- (void)initProperties
{
    [super initProperties];
    
    dictionaryOfQueue = [NSMutableDictionary dictionary];
    self.selectable = YES;
    self.itemAlign = UIGridViewItemAlignVertical;
    self.padding = CGPaddingMake(10, 10, 10, 10);
    self.columnCount = 3;
    self.rowCount = 3;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.width = self.width;
    _scrollView.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
    _scrollView.layer.rasterizationScale = 2.0f;
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    tapGestureRecognizer.delegate = self;
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    
    [self insertSubview:_scrollView atIndex:0];
    [_scrollView addGestureRecognizer:tapGestureRecognizer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutScrollView];
    [self layoutSectionViews];
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (void)setColumnCount:(int)columnCount
{
    if (columnCount == _columnCount)
        return;
    
    _columnCount = columnCount;
    
    [self invalidateProperties];
}

- (void)setDataSource:(id<UIGridViewDataSource>)dataSource
{
    if ([dataSource isEqual:_dataSource])
        return;
    
    _dataSource = dataSource;
    
    [self invalidateProperties];
}

- (void)setDelegate:(id<UIGridViewDelegate, UIScrollViewDelegate>)delegate
{
    if ([delegate isEqual:_delegate])
        return;
    
    _delegate = delegate;
    delegateChanged = YES;
    
    [self invalidateProperties];
}

- (void)setItemAlign:(UIGridViewItemAlign)itemAlign
{
    if (itemAlign == _itemAlign)
        return;
    
    _itemAlign = itemAlign;
    
    [self invalidateProperties];
}

- (void)setPadding:(CGPadding)padding
{
    if (CGPaddingEquals(padding, _padding))
        return;
    
    _padding = padding;
    
    [self invalidateProperties];
}

- (void)setRowCount:(int)rowCount
{
    if (rowCount == _rowCount)
        return;
    
    _rowCount = rowCount;
    
    [self invalidateProperties];
}

#pragma mark - Public methods

- (PSGridViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_scrollView.subviews.count > indexPath.section)
    {
        UIView *cellIndicator = [((UIView *) [_scrollView.subviews objectAtIndex:indexPath.section]) viewWithTag:UIGridViewSubviewTagCellIndicatorView];
        return cellIndicator.subviews.count > indexPath.row ? [cellIndicator.subviews objectAtIndex:indexPath.row] : nil;
    }
    
    return nil;
}

- (PSGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    NSMutableArray *queue = [dictionaryOfQueue objectForKey:identifier];
    if (queue && queue.count <= self.columnCount * self.rowCount * _scrollView.subviews.count)
    {
        PSGridViewCell *cell = queue.firstObject;
        [queue removeObjectAtIndex:0];
        return cell;
    }
    return nil;
}

- (UIView *)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier
{
    NSMutableArray *queue = [dictionaryOfQueue objectForKey:identifier];
    if (queue && queue.count >= _scrollView.subviews.count)
    {
        UIView *cell = queue.firstObject;
        [queue removeObjectAtIndex:0];
        return cell;
    }
    return nil;
}

- (void)reloadData
{
    [self removeItems];
    
    if (self.dataSource)
        [self createItems];
    
    [self layoutScrollView];
    
    if (selectedIndexPath)
        [[self cellForRowAtIndexPath:selectedIndexPath] setSelected:YES animated:YES];
}

- (void)removeItems
{
    for (UIView *subview in _scrollView.subviews)
        [subview removeFromSuperview];
}

- (void)removeSelectionWithIndexPathWillBeSelect:(NSIndexPath *)indexPath
{
    NSInteger numOfItems = [self.dataSource gridView:self itemCountInSection:indexPath.section];
    for (int i=0; i<numOfItems; i++)
    {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        
        if (ip.row != indexPath.row)
            [[self cellForRowAtIndexPath:ip] setSelected:NO];
    }
    
    if (selectedIndexPath.row == indexPath.row && selectedIndexPath.section == indexPath.section)
        selectedIndexPath = nil;
}

- (BOOL)setSelectionWithIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndexPath && indexPath.row == selectedIndexPath.row && indexPath.section == selectedIndexPath.section)
        return NO;
    
    [self removeSelectionWithIndexPathWillBeSelect:indexPath];
    [[self cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];
    
    selectedIndexPath = indexPath;
    
    return YES;
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (void)createItems
{
    NSInteger numOfSection = [self.dataSource sectionCountInGridView:self];
    
    for (int i=0; i<numOfSection; i++)
    {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(i*self.width, 0, self.width, self.height)];
        UIView *headerView = [self.dataSource respondsToSelector:@selector(gridView:headerViewInSection:)] ? [self.dataSource gridView:self headerViewInSection:i] : nil;
        UIView *footerView = [self.dataSource respondsToSelector:@selector(gridView:footerViewInSection:)] ? [self.dataSource gridView:self footerViewInSection:i] : nil;
        CGFloat headerHeight = headerView && [self.dataSource respondsToSelector:@selector(gridView:headerHeightInSection:)] ? [self.dataSource gridView:self headerHeightInSection:i] : 0;
        CGFloat headerWidth = headerView && [self.dataSource respondsToSelector:@selector(gridView:headerWidthInSection:)] ? [self.dataSource gridView:self headerWidthInSection:i] : 0;
        CGFloat footerHeight = footerView && [self.dataSource respondsToSelector:@selector(gridView:footerHeightInSection:)] ? [self.dataSource gridView:self footerHeightInSection:i] : 0;
        CGFloat footerWidth = footerView && [self.dataSource respondsToSelector:@selector(gridView:footerWidthInSection:)] ? [self.dataSource gridView:self footerWidthInSection:i] : 0;
        
        if (headerView)
        {
            headerView.frame = self.itemAlign == UIGridViewItemAlignVertical ?
            CGRectMake(0, 0, self.width, headerHeight) :
            CGRectMake(0, 0, headerWidth, self.height);
            headerView.tag = UIGridViewSubviewTagHeaderView;
            
            [sectionView addSubview:headerView];
            
            if ([_delegate respondsToSelector:@selector(gridView:willDisplayHeaderView:forSection:)])
                [_delegate gridView:self willDisplayHeaderView:headerView forSection:i];
        }
        
        if (footerView)
        {
            footerView.frame = self.itemAlign == UIGridViewItemAlignVertical ?
            CGRectMake(0, self.height - footerHeight, self.width, footerHeight) :
            CGRectMake(self.width - footerWidth, 0, footerWidth, self.height);
            footerView.tag = UIGridViewSubviewTagFooterView;
            
            [sectionView addSubview:footerView];
            
            if ([_delegate respondsToSelector:@selector(gridView:willDisplayFooterView:forSection:)])
                [_delegate gridView:self willDisplayFooterView:footerView forSection:i];
        }
        
        CGFloat cellIndicatorLeft = headerWidth + self.padding.left;
        CGFloat cellIndicatorTop = headerHeight + self.padding.top;
        CGFloat cellIndicatorWidth = self.width - headerWidth - footerWidth - self.padding.left - self.padding.right;
        CGFloat cellIndicatorHeight = self.height - headerHeight - footerHeight - self.padding.top - self.padding.bottom;
        CGFloat itemWidth = self.itemAlign == UIGridViewItemAlignVertical ?
        (self.width - self.padding.left - self.padding.right)/self.columnCount :
        cellIndicatorWidth/self.columnCount;
        CGFloat itemHeight = self.itemAlign == UIGridViewItemAlignVertical ?
        cellIndicatorHeight/self.rowCount :
        (self.height - self.padding.top - self.padding.bottom)/self.rowCount;
        UIView *cellIndicator = [[UIView alloc] initWithFrame:CGRectMake(cellIndicatorLeft, cellIndicatorTop, cellIndicatorWidth, cellIndicatorHeight)];
        cellIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cellIndicator.tag = UIGridViewSubviewTagCellIndicatorView;
        
        NSInteger numOfItems = [self.dataSource gridView:self itemCountInSection:i];
        
        for (int j=0; j<numOfItems; j++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            PSGridViewCell *cell = [self.dataSource gridView:self cellForRowAtIndexPath:indexPath];
            if (cell)
            {
                CGFloat x = (j%self.columnCount) * itemWidth;
                CGFloat y = floorf(j/self.columnCount) * itemHeight;
                cell.frame = CGRectMake(x, y, itemWidth, itemHeight);
                
                if ([_delegate respondsToSelector:@selector(gridView:willDisplayCell:forRowAtIndexPath:)])
                    [_delegate gridView:self willDisplayCell:cell forRowAtIndexPath:indexPath];
                
                [cellIndicator addSubview:cell];
                
                NSString *identifier = NSStringFromClass([cell class]);
                NSMutableArray *queue = [dictionaryOfQueue objectForKey:identifier];
                
                if (!queue)
                {   queue = [NSMutableArray array];
                    
                    [dictionaryOfQueue setObject:queue forKey:identifier];
                }
                
                if (![queue containsObject:cell])
                    [queue addObject:cell];
            }
        }
        
        [sectionView addSubview:cellIndicator];
        [_scrollView addSubview:sectionView];
    }
}

- (void)layoutScrollView
{
    NSInteger numOfSection = self.dataSource ? [self.dataSource sectionCountInGridView:self] : 1;
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(self.width*numOfSection, self.height);
}

- (void)layoutSectionViews
{
    for (int i=0; i<_scrollView.subviews.count; i++)
    {
        UIView *sectionView = [_scrollView.subviews objectAtIndex:i];
        UIView *headerView = [sectionView viewWithTag:UIGridViewSubviewTagHeaderView];
        UIView *footerView = [sectionView viewWithTag:UIGridViewSubviewTagFooterView];
        UIView *cellIndicatorView = [sectionView viewWithTag:UIGridViewSubviewTagCellIndicatorView];
        CGFloat headerHeight = headerView && [self.dataSource respondsToSelector:@selector(gridView:headerHeightInSection:)] ? [self.dataSource gridView:self headerHeightInSection:i] : 0;
        CGFloat headerWidth = headerView && [self.dataSource respondsToSelector:@selector(gridView:headerWidthInSection:)] ? [self.dataSource gridView:self headerWidthInSection:i] : 0;
        CGFloat footerHeight = footerView && [self.dataSource respondsToSelector:@selector(gridView:footerHeightInSection:)] ? [self.dataSource gridView:self footerHeightInSection:i] : 0;
        CGFloat footerWidth = footerView && [self.dataSource respondsToSelector:@selector(gridView:footerWidthInSection:)] ? [self.dataSource gridView:self footerWidthInSection:i] : 0;
        
        sectionView.frame = _scrollView.bounds;
        sectionView.x = i * _scrollView.width;
        
        if (headerView)
        {
            headerView.frame = self.itemAlign == UIGridViewItemAlignVertical ?
            CGRectMake(0, 0, self.width, headerHeight) :
            CGRectMake(0, 0, headerWidth, self.height);
        }
        
        if (footerView)
        {
            footerView.frame = self.itemAlign == UIGridViewItemAlignVertical ?
            CGRectMake(0, self.height - footerHeight, self.width, footerHeight) :
            CGRectMake(self.width - footerWidth, 0, footerWidth, self.height);
        }
        
        if (cellIndicatorView)
        {
            [cellIndicatorView setX:self.padding.left + headerWidth y:self.padding.top + headerHeight width:self.width - headerWidth - footerWidth - self.padding.left - self.padding.right height:self.height - headerHeight - footerHeight - self.padding.top - self.padding.bottom];
            
            CGFloat itemWidth = self.itemAlign == UIGridViewItemAlignVertical ?
            (self.width - self.padding.left - self.padding.right)/self.columnCount :
            cellIndicatorView.width/self.columnCount;
            CGFloat itemHeight = self.itemAlign == UIGridViewItemAlignVertical ?
            cellIndicatorView.height/self.rowCount :
            (self.height - self.padding.top - self.padding.bottom)/self.rowCount;
            NSInteger numOfItems = [self.dataSource gridView:self itemCountInSection:i];
            
            for (int j=0; j<numOfItems; j++)
            {
                if (j < cellIndicatorView.subviews.count)
                {
                    PSGridViewCell *cell = [cellIndicatorView.subviews objectAtIndex:j];
                    cell.frame = CGRectMake((j%self.columnCount) * itemWidth, floorf(j/self.columnCount) * itemHeight, itemWidth, itemHeight);
                }
            }
        }
    }
}

#pragma mark - UIGestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.selectable;
}

- (void)tapGestureRecognized:(UIGestureRecognizer *)gestureRecognizer
{
    NSInteger section = roundf(_scrollView.contentOffset.x/_scrollView.width);
    
    if (_scrollView.subviews.count > section)
    {
        UIView *cellIndicator = [_scrollView viewWithTag:UIGridViewSubviewTagCellIndicatorView];
        CGFloat xFrom = section * _scrollView.width;
        CGFloat xTo = xFrom + cellIndicator.width;
        CGFloat yFrom = 0;
        CGFloat yTo = cellIndicator.height;
        CGPoint point = [gestureRecognizer locationInView:_scrollView];
        point.x -= cellIndicator.x;
        point.y -= cellIndicator.y;
        
        if ((point.x >= xFrom && point.x <= xTo) && (point.y >= yFrom && point.y <= yTo))
        {
            CGFloat itemWidth = cellIndicator.width/self.columnCount;
            CGFloat itemHeight = cellIndicator.height/self.rowCount;
            int columnIndex = roundf(point.x - xFrom)/itemWidth;
            int rowIndex = roundf(point.y - yFrom)/itemHeight;
            int index = floorf(columnIndex + (rowIndex*self.columnCount));
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
            
            if (indexPath.section <= [self.dataSource sectionCountInGridView:self] &&
                indexPath.row <= [self.dataSource gridView:self itemCountInSection:indexPath.section] &&
                [self setSelectionWithIndexPath:indexPath])
            {
                if ([_delegate respondsToSelector:@selector(gridView:didSelectRowAtIndexPath:)])
                    [_delegate gridView:self didSelectRowAtIndexPath:indexPath];
            }
        }
    }
}

@end
