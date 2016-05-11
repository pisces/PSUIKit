//
//  PSAttributedDivisionLabel.h
//  PSUIKit
//
//  Created by Steve Kim on 2014. 8. 13..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2014년 hh963103@naver.com. All rights reserved.
//

#import "OHAttributedLabel.h"

@interface PSAttributedDivisionLabel : OHAttributedLabel
@property (nonatomic, strong) NSString *divider;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *fonts;
@property (nonatomic, strong) OHParagraphStyle *paragraphStyle;
@end
