//
//  PSToastView.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "PSView.h"
#import <QuartzCore/QuartzCore.h>
#import "GraphicsLayout.h"

enum {
    PSToastViewPostionTop,
    PSToastViewPostionBottom
};
typedef NSInteger PSToastViewPostion;

@interface PSToastView : PSView
@property (nonatomic) CGPadding padding;
@property (nonatomic) NSTimeInterval hideTimeInterval;
@property (nonatomic) PSToastViewPostion position;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, readonly) UILabel *textLabel;
+ (PSToastView *)sharedToastView;
- (void)hide;
- (void)hideWithAnimated:(BOOL)animated;
- (void)showWithView:(UIView *)view message:(NSString *)message;
- (void)showWithView:(UIView *)view message:(NSString *)message position:(PSToastViewPostion)position;
@end

@interface PSToastViewBackgroundView : PSView
@end