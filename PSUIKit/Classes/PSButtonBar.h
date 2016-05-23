//
//  PSButtonBar.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "PSView.h"
#import "GraphicsLayout.h"
#import "UIView+PSUIKit.h"

enum {
    PSButtonBarAlignmentHorizontal = 1<<0,
    PSButtonBarAlignmentVertical = 1<<1
};
typedef Byte PSButtonBarAlignment;

@class PSButtonBar;

@protocol PSButtonBarDelegate <NSObject>
- (void)buttonBar:(PSButtonBar*)buttonBar buttonRender:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex;
@optional
- (void)buttonBar:(PSButtonBar*)buttonBar buttonClicked:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex;
- (void)buttonBar:(PSButtonBar*)buttonBar buttonResized:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex;
- (void)buttonBar:(PSButtonBar*)buttonBar buttonSelected:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex;
@end

@interface PSButtonBarDelegateObject : NSObject <PSButtonBarDelegate>
typedef void (^PSButtonBarDelegateBlock)(UIButton *button, NSUInteger buttonIndex);
- (id)initWithRender:(PSButtonBarDelegateBlock)render clicked:(PSButtonBarDelegateBlock)clicked resized:(PSButtonBarDelegateBlock)resized selected:(PSButtonBarDelegateBlock)selected;
- (void)clear;
- (void)render:(PSButtonBarDelegateBlock)render clicked:(PSButtonBarDelegateBlock)clicked resized:(PSButtonBarDelegateBlock)resized selected:(PSButtonBarDelegateBlock)selected;
@end

@interface PSButtonBar : PSView
@property (nonatomic) BOOL toggle;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) NSInteger numOfButtons;
@property (nonatomic, readonly) NSInteger rowCount;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, readonly) CGFloat buttonWidth;
@property (nonatomic, readonly) CGFloat buttonHeight;
@property (nonatomic) CGFloat horizontalGap;
@property (nonatomic) CGFloat verticalGap;
@property (nonatomic) UIButtonType buttonType;
@property (nonatomic) CGPadding padding;
@property (nonatomic) CGPadding seperatorPadding;
@property (nonatomic) PSButtonBarAlignment alignment;
@property (nonatomic, readonly) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, readonly) UIButton *selectedChild;
@property (nonatomic, strong) UIColor *seperatorColor;
@property (nonatomic, strong) PSButtonBarDelegateObject *delegateObject;
@property (nonatomic, weak) IBOutlet id<PSButtonBarDelegate> delegate;
- (NSUInteger)buttonIndex:(UIButton *)button;
- (void)callRenderButtons;
- (void)deselect;
@end

@interface PSButtonBarSeperatorView : PSView
@property (nonatomic) NSUInteger columnCount;
@property (nonatomic) NSUInteger rowCount;
@property (nonatomic) CGPadding padding;
@property (nonatomic, strong) UIColor *lineColor;
@end