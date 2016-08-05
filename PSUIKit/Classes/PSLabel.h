//
//  PSLabel.h
//  PSUIKit
//
//  Created by Steve Kim on 2016. 7. 22..
//  Copyright (c) 2016년 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSLabelProtectedMethods <NSObject>
- (void)commitProperties;
- (void)initProperties;
- (void)setUpSubviews;
@end

@interface PSLabel : UILabel <PSLabelProtectedMethods>
@property (nonatomic) BOOL allowTouchHighlighted;
@property (nonatomic, readonly) BOOL appeared;
@property (nonatomic) BOOL immediatelyUpdating;
- (void)invalidateProperties;
- (void)validateProperties;
@end