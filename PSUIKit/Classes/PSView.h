//
//  PSView.h
//  PSUIKit
//
//  Created by Steve Kim on 2014. 8. 24..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2014년 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSViewProtectedMethods <NSObject>
- (void)commitProperties;
- (void)initProperties;
- (void)setUpSubviews;
@end

@interface PSView : UIView <PSViewProtectedMethods>
@property (nonatomic, readonly) BOOL appeared;
@property (nonatomic) BOOL immediatelyUpdating;
- (void)invalidateProperties;
- (void)validateProperties;
@end