//
//  PSRecycledScrollView.m
//  PSUIKit
//
//  Created by Steve Kim on 2015. 4. 9..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

/*
 Copyright 2015 Steve Kim
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "PSRecycledScrollView.h"
#import "UIView+PSUIKit.h"

@interface PSRecycledScrollView ()
@property (nonatomic, readwrite, strong) NSMutableSet *visibleViews;
@property (strong) NSMutableSet *recycledViews;
@property (strong) NSMutableDictionary *sizeInfo;
- (void)clear;
- (CGFloat)combinedSizeForViewUntilIndex:(NSInteger)index;
- (void)configureView:(UIView *)view atIndex:(NSInteger)index;
- (BOOL)displayingViewAtIndex:(NSInteger)index;
- (CGFloat)sizeForViewAtIndex:(NSInteger)index;
- (NSUInteger)viewCount;
- (void)views;
- (UIView *)visibleViewAtIndex:(NSInteger)index;
@end

@implementation PSRecycledScrollView
{
@private
    NSInteger viewCount;
}

// ================================================================================================
//  Overridden: PSScrollView
// ================================================================================================

#pragma mark - Overridden: PSScrollView

- (CGSize)contentSize {
    return (self.type == PSRecycledScrollViewTypeVertical) ?
    CGSizeMake(self.width, [self combinedSizeForViewUntilIndex:viewCount]) : CGSizeMake([self combinedSizeForViewUntilIndex:viewCount], self.height);
}

- (void)initProperties {
    [super initProperties];
    
    self.padding = 10;
    self.type = PSRecycledScrollViewTypeVertical;
    self.visibleViews = [NSMutableSet set];
    self.recycledViews = [NSMutableSet set];
    self.sizeInfo = [NSMutableDictionary dictionary];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self views];
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public methods

- (id)dequeueRecycledView {
    id view = [self.recycledViews anyObject];
    
    if(view != nil)
        [self.recycledViews removeObject:view];
    
    return view;
}

- (void)moveToIndex:(NSInteger)index withAnimation:(BOOL)animation {
    CGFloat size = [self combinedSizeForViewUntilIndex:index];
    if (self.type == PSRecycledScrollViewTypeVertical) {
        [self setContentOffset:CGPointMake(self.contentOffset.x, size) animated:animation];
    } else if (self.type == PSRecycledScrollViewTypeHorizontal) {
        [self setContentOffset:CGPointMake(size, self.contentOffset.y) animated:animation];
    }
}

- (void)reloadData {
    [self.recycledViews unionSet:self.visibleViews];
    
    for (id object in self.visibleViews) {
        UIView *view = [object isKindOfClass:[UIViewController class]] ? ((UIViewController *)object).view : object;
        [view removeFromSuperview];
    }
    
    [self.sizeInfo removeAllObjects];
    [self.visibleViews removeAllObjects];
    [self views];
}

- (id)viewAtIndex:(NSInteger)index {
    return [self visibleViewAtIndex:index];
}

- (id)visibleView {
    NSInteger index = (self.type == PSRecycledScrollViewTypeHorizontal) ? self.contentOffset.x / self.width : self.contentOffset.y / self.height;
    return [self visibleViewAtIndex:index];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (void)clear {
    [self.recycledViews unionSet:self.visibleViews];
    
    for (id object in self.visibleViews) {
        UIView *view = [object isKindOfClass:[UIViewController class]] ? ((UIViewController *)object).view : object;
        [view removeFromSuperview];
    }
    
    [self.sizeInfo removeAllObjects];
    [self.visibleViews removeAllObjects];
    
    self.contentOffset = CGPointZero;
    self.contentSize = self.frame.size;
}

- (CGFloat)combinedSizeForViewUntilIndex:(NSInteger)index {
    NSMutableDictionary *info = [self.sizeInfo objectForKey:@(index)];
    
    if(info != nil && info[@"combine"] != nil)
        return [info[@"combine"] floatValue];
    
    CGFloat size = 0.0f;
    
    for (NSInteger i=0; i<index; i++)
        size += [self sizeForViewAtIndex:i] + self.padding;
    
    if (info == nil) {
        info = [NSMutableDictionary dictionaryWithCapacity:2];
        [self.sizeInfo setObject:info forKey:@(index)];
    }
    
    [info setObject:@(size) forKey:@"combine"];
    
    return size;
}

- (void)configureView:(UIView *)view atIndex:(NSInteger)index {
    if (self.type == PSRecycledScrollViewTypeVertical) {
        view.frame = CGRectMake(0.0f, [self combinedSizeForViewUntilIndex:index], self.width, [self sizeForViewAtIndex:index]);
    } else if (self.type == PSRecycledScrollViewTypeHorizontal) {
        view.frame = CGRectMake([self combinedSizeForViewUntilIndex:index], 0.0f, [self sizeForViewAtIndex:index], self.height);
    }
}

- (BOOL)displayingViewAtIndex:(NSInteger)index {
    for (id object in self.visibleViews) {
        UIView *view = [object isKindOfClass:[UIViewController class]] ? ((UIViewController *)object).view : object;
        if(view.tag == index)
            return YES;
    }
    return NO;
}

- (CGFloat)sizeForViewAtIndex:(NSInteger)index {
    NSMutableDictionary *info = [self.sizeInfo objectForKey:@(index)];
    
    if (info != nil && info[@"size"] != nil)
        return [info[@"size"] floatValue];
    
    if(!info) {
        info = [NSMutableDictionary dictionaryWithCapacity:2];
        [self.sizeInfo setObject:info forKey:@(index)];
    }
    
    NSInteger page = floorf((CGFloat)index / (CGFloat)viewCount);
    NSInteger actualIndex = (index < viewCount) ? index : index - page * viewCount;
    CGFloat size = [self.dataSource scrollView:self sizeAtIndex:actualIndex] - self.padding;
    
    [info setObject:@(size) forKey:@"size"];
    
    return size;
}

- (NSUInteger)viewCount {
    return [self.dataSource numberOfViewInScrollView:self];
}

- (void)views {
    viewCount = [self viewCount];
    self.contentSize = [self contentSize];
    
    if (_type == PSRecycledScrollViewTypeVertical) {
        self.contentOffset = CGPointMake(0, self.contentOffset.y);
    } else if (_type == PSRecycledScrollViewTypeHorizontal) {
        self.contentOffset = CGPointMake(self.contentOffset.x, 0);
    }
    
    CGRect visibleBounds = CGRectMake(self.contentOffset.x, self.contentOffset.y, self.width, self.height);
    NSInteger firstNeedIndex = 0;
    CGFloat size = [self sizeForViewAtIndex:firstNeedIndex] + self.padding;
    
    if (self.type == PSRecycledScrollViewTypeVertical) {
        while (size > 0 && size < CGRectGetMinY(visibleBounds)) {
            firstNeedIndex ++;
            size += [self sizeForViewAtIndex:firstNeedIndex] + self.padding;
        }
    } else if (self.type == PSRecycledScrollViewTypeHorizontal) {
        while (size > 0 &&size < CGRectGetMinX(visibleBounds)) {
            firstNeedIndex ++;
            size += [self sizeForViewAtIndex:firstNeedIndex] + self.padding;
        }
    }
    
    NSInteger lastNeedIndex = firstNeedIndex;
    
    if (self.type == PSRecycledScrollViewTypeVertical) {
        while (size > 0 &&size <= CGRectGetMaxY(visibleBounds)) {
            lastNeedIndex ++;
            size += [self sizeForViewAtIndex:lastNeedIndex] + self.padding;
        }
    } else if (self.type == PSRecycledScrollViewTypeHorizontal) {
        while (size > 0 &&size <= CGRectGetMaxX(visibleBounds)) {
            lastNeedIndex ++;
            size += [self sizeForViewAtIndex:lastNeedIndex] + self.padding;
        }
    }
    
    if (!self.clipsToBounds) {
        firstNeedIndex --;
        lastNeedIndex ++;
    }
    
    firstNeedIndex = MAX(firstNeedIndex, 0);
    lastNeedIndex = MIN(lastNeedIndex, viewCount - 1);
    
    for (id object in self.visibleViews) {
        UIView *view = [object isKindOfClass:[UIViewController class]] ? ((UIViewController *)object).view : object;
        
        if (view.tag < firstNeedIndex || view.tag > lastNeedIndex) {
            [self.recycledViews addObject:object];
            [view removeFromSuperview];
        }
    }
    
    [self.visibleViews minusSet:self.recycledViews];
    
    if(viewCount == 0)
        return;
    
    for (NSUInteger index=firstNeedIndex; index<=lastNeedIndex; index++) {
        UIView *view;
        
        if (![self displayingViewAtIndex:index]) {
            id object = [self.dataSource viewForRecycledInScrollView:self atIndex:index];
            view = [object isKindOfClass:[UIViewController class]] ? ((UIViewController *)object).view : object;
            view.tag = index;
            
            [self configureView:view atIndex:index];
            [self addSubview:view];
            [self.visibleViews addObject:object];
        } else {
            id object = [self visibleViewAtIndex:index];
            view = [object isKindOfClass:[UIViewController class]] ? ((UIViewController *)object).view : object;
            
            [self configureView:view atIndex:index];
        }
        
        if ([self.scrollViewDelegate respondsToSelector:@selector(scrollView:willDisplayView:forIndex:)])
            [self.scrollViewDelegate scrollView:self willDisplayView:view forIndex:index];
    }
}

- (id)visibleViewAtIndex:(NSInteger)index {
    for (id object in self.visibleViews) {
        UIView *view = [object isKindOfClass:[UIViewController class]] ? ((UIViewController *)object).view : object;
        
        if(view.tag == index)
            return object;
    }
    return nil;
}

@end
