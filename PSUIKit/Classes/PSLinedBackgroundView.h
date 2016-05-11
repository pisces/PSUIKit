//
//  UILinedBackgroundView.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphicsLayout.h"
#import "PSView.h"

enum {
    LineDrawPositionNone = 0,
    LineDrawPositionBottom = 1<<0,
    LineDrawPositionTop = 1<<1
};
typedef int LineDrawPosition;

@interface PSLinedBackgroundView : PSView
@property (nonatomic) LineDrawPosition lineDrawPosition;
@property (nonatomic, strong) NSArray *seperatorColors;
@property (nonatomic, assign) CGPadding linePadding;
@property (nonatomic, assign) CGFloat lineHeight;
@end