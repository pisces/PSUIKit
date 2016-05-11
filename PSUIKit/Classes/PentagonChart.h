//
//  PentagonChart.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphicsLayout.h"

@interface PentagonChart : UIView
@property (nonatomic, retain) NSArray *entities;
@property (nonatomic, retain) NSArray *labelNames;
@property (nonatomic) float maximumValue;
- (id)initWithFrame:(CGRect)frame labelNames:(NSArray *)labelNames;
- (void)drawPentagonWithValues:(NSArray *)values;
@end
