//
//  PSScrollView.h
//  PSUIKit
//
//  Created by pisces on 2015. 4. 11..
//  Copyright (c) 2015년 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSScrollViewProtectedMethods <NSObject>
- (void)commitProperties;
- (void)initProperties;
- (void)setUpSubviews;
@end

@interface PSScrollView : UIScrollView <PSScrollViewProtectedMethods>
@property (nonatomic) BOOL immediatelyUpdating;
- (void)invalidateProperties;
- (void)validateProperties;
@end