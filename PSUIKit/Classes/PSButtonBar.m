//
//  PSButtonBar.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "PSButtonBar.h"

// ================================================================================================
//
//  Implementation: PSButtonBar
//
// ================================================================================================

@interface PSButtonBar ()
@property (nonatomic, readonly) CGFloat calculatedButtonHeight;
@property (nonatomic, readonly) CGFloat calculatedButtonWidth;
@property (nonatomic, readonly) NSInteger calculatedColumnCount;
@property (nonatomic, readonly) NSInteger calculatedRowCount;
@end

@implementation PSButtonBar
{
@private
    BOOL canUpdateDisplayList;
    BOOL numOfButtonsChanged;
    BOOL selectedIndexChanged;
    BOOL shouldRedrawSepertatorView;
    PSButtonBarSeperatorView *sepertatorView;
}

// ================================================================================================
//  Overridden: PSView
// ================================================================================================

#pragma mark - Overridden: PSView

- (void)dealloc
{
    [self removeButtons];
    [_buttons removeAllObjects];
    
    _buttons = nil;
    _selectedChild = nil;
}

- (void)commitProperties
{
    if (canUpdateDisplayList)
    {
        canUpdateDisplayList = NO;
        
        [self setNeedsLayout];
    }
    
    if (numOfButtonsChanged)
    {
        numOfButtonsChanged = NO;
        
        [self removeButtons];
        [self createButtons];
        [self updateSeperatorViewDisplay];
        [self bringSubviewToFront:sepertatorView];
    }
    
    if (selectedIndexChanged)
    {
        selectedIndexChanged = NO;
        
        [self deselectWithoutClearIndex];
        
        if (self.toggle)
        {
            _selectedChild = [_buttons objectAtIndex:_selectedIndex];
            _selectedChild.userInteractionEnabled = NO;
            _selectedChild.selected = YES;
        }
    }
    
    if (shouldRedrawSepertatorView)
    {
        shouldRedrawSepertatorView = NO;
        sepertatorView.lineColor = self.seperatorColor;
        sepertatorView.padding = self.seperatorPadding;
        
        [self updateSeperatorViewDisplay];
    }
}

- (void)initProperties
{
    _alignment = PSButtonBarAlignmentHorizontal;
    _selectedIndex = -1;
    _horizontalGap = 0;
    _verticalGap = 0;
    _padding = CGPaddingMake(0, 0, 0, 0);
    _seperatorColor = [UIColor clearColor];
    
    sepertatorView = [[PSButtonBarSeperatorView alloc] init];
    sepertatorView.lineColor = self.seperatorColor;
    sepertatorView.padding = self.seperatorPadding;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateDisplayList];
}

- (void)setUpSubviews
{
    [self addSubview:sepertatorView];
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public methods

- (NSUInteger)buttonIndex:(UIButton *)button
{
    return [_buttons indexOfObject:button];
}

- (void)callRenderButtons {
    if (![self.delegate respondsToSelector:@selector(buttonBar:buttonRender:buttonIndex:)])
        return;
    
    for (NSUInteger i=0; i<self.buttons.count; i++)
        [self.delegate buttonBar:self buttonRender:[self.buttons objectAtIndex:i] buttonIndex:i];
}

- (void)deselect
{
    [self deselectWithoutClearIndex];
    _selectedIndex = -1;
}

#pragma mark - Public getter/setter

- (id<PSButtonBarDelegate>)delegate
{
    return self.delegateObject ? self.delegateObject : _delegate;
}

- (void)setAlignment:(PSButtonBarAlignment)alignment
{
    if (alignment == _alignment)
        return;
    
    _alignment = alignment;
    canUpdateDisplayList = YES;
    
    [self invalidateProperties];
}

- (void)setColumnCount:(NSInteger)columnCount
{
    if (columnCount == _columnCount)
        return;
    
    _columnCount = columnCount;
    canUpdateDisplayList = YES;
    
    [self invalidateProperties];
}

- (void)setHorizontalGap:(CGFloat)horizontalGap
{
    if (horizontalGap == _horizontalGap)
        return;
    
    _horizontalGap = horizontalGap;
    canUpdateDisplayList = YES;
    
    [self invalidateProperties];
}

- (void)setVerticalGap:(CGFloat)verticalGap
{
    if (verticalGap == _verticalGap)
        return;
    
    _verticalGap = verticalGap;
    canUpdateDisplayList = YES;
    
    [self invalidateProperties];
}

- (void)setPadding:(CGPadding)padding
{
    if (CGPaddingEquals(padding, _padding))
        return;
    
    _padding = padding;
    canUpdateDisplayList = YES;
    
    [self invalidateProperties];
}

- (void)setNumOfButtons:(NSInteger)numOfButtons
{
    if (numOfButtons == _numOfButtons)
        return;
    
    _numOfButtons = numOfButtons;
    numOfButtonsChanged = YES;
    
    [self invalidateProperties];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex == _selectedIndex)
        return;
    
    _selectedIndex = selectedIndex;
    selectedIndexChanged = YES;
    
    [self invalidateProperties];
}

- (void)setSeperatorColor:(UIColor *)seperatorColor
{
    if ([seperatorColor isEqual:_seperatorColor])
        return;
    
    _seperatorColor = seperatorColor;
    shouldRedrawSepertatorView = YES;
    
    [self invalidateProperties];
}

- (void)setSeperatorPadding:(CGPadding)seperatorPadding
{
    if (CGPaddingEquals(seperatorPadding, _seperatorPadding))
        return;
    
    _seperatorPadding = seperatorPadding;
    shouldRedrawSepertatorView = YES;
    
    [self invalidateProperties];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private getter/setter

- (CGFloat)calculatedButtonHeight
{
    if ((self.alignment & PSButtonBarAlignmentHorizontal) == PSButtonBarAlignmentHorizontal &&
        (self.alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return (self.height - self.padding.top - self.padding.bottom - (self.verticalGap*(self.rowCount-1)))/self.rowCount;
    
    if ((self.alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return (self.height - self.padding.top - self.padding.bottom - (self.verticalGap * (self.numOfButtons-1)))/self.numOfButtons;
    
    return self.height - self.padding.top - self.padding.bottom;
}

- (CGFloat)calculatedButtonWidth
{
    if ((self.alignment & PSButtonBarAlignmentHorizontal) == PSButtonBarAlignmentHorizontal &&
        (self.alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return (self.width - self.padding.left - self.padding.right - (self.horizontalGap*(self.columnCount-1)))/self.columnCount;
    
    if ((self.alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return self.width - self.padding.left - self.padding.right;
    
    return (self.width - self.padding.left - self.padding.right - (self.horizontalGap * (self.numOfButtons-1)))/self.numOfButtons;
}

- (NSInteger)calculatedColumnCount
{
    if ((self.alignment & PSButtonBarAlignmentHorizontal) == PSButtonBarAlignmentHorizontal &&
        (self.alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return self.columnCount > 0 ? self.columnCount : self.numOfButtons;
    
    if ((self.alignment & PSButtonBarAlignmentHorizontal) == PSButtonBarAlignmentHorizontal)
        return self.numOfButtons;
    
    return 1;
}

- (NSInteger)calculatedRowCount
{
    if ((self.alignment & PSButtonBarAlignmentHorizontal) == PSButtonBarAlignmentHorizontal &&
        (self.alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return ceilf((CGFloat) self.numOfButtons/self.columnCount);
    
    if ((self.alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return self.numOfButtons;
    
    return 1;
}

#pragma mark - Private methods

- (void)addButtonTargets:(UIButton *)button
{
    [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createButtons
{
    if (self.buttons)
        return;
    
    _columnCount = self.calculatedColumnCount;
    _rowCount = self.calculatedRowCount;
    _buttons = [NSMutableArray array];
    _buttonWidth = self.calculatedButtonWidth;
    _buttonHeight = self.calculatedButtonHeight;
    
    for (NSUInteger i=0; i<_numOfButtons; i++)
    {
        UIButton *button = [UIButton buttonWithType:self.buttonType];
        button.frame = CGRectMake([self xOffsetWithIndex:i], [self yOffsetWithIndex:i], _buttonWidth, _buttonHeight);
        button.userInteractionEnabled = YES;
        
        if (i == _selectedIndex)
        {
            button.selected = YES;
            _selectedChild = button;
        }
        
        [_buttons addObject:button];
        [self addButtonTargets:button];
        [self addSubview:button];
        
        if ([self.delegate respondsToSelector:@selector(buttonBar:buttonRender:buttonIndex:)])
            [self.delegate buttonBar:self buttonRender:button buttonIndex:i];
    }
}

- (void)deselectWithoutClearIndex
{
    if (_selectedChild)
    {
        _selectedChild.userInteractionEnabled = YES;
        _selectedChild.selected = NO;
        _selectedChild = nil;
    }
}

- (void)removeButtons
{
    if (_buttons)
    {
        for (UIButton *button in _buttons)
        {
            [self removeButtonTargets:button];
            [button removeFromSuperview];
        }
        [_buttons removeAllObjects];
        _buttons = nil;
    }
}

- (void)removeButtonTargets:(UIButton *)button
{
    [button removeTarget:button action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateDisplayList
{
    if (!_buttons)
        return;
    
    _columnCount = self.calculatedColumnCount;
    _rowCount = self.calculatedRowCount;
    _buttonWidth = self.calculatedButtonWidth;
    _buttonHeight = self.calculatedButtonHeight;
    
    for (NSUInteger i=0; i<self.buttons.count; i++)
    {
        UIButton *button = [self.buttons objectAtIndex:i];
        button.frame = CGRectMake([self xOffsetWithIndex:i], [self yOffsetWithIndex:i], _buttonWidth, _buttonHeight);
        
        if ([self.delegate respondsToSelector:@selector(buttonBar:buttonResized:buttonIndex:)])
            [self.delegate buttonBar:self buttonResized:button buttonIndex:i];
    }
    
    [self updateSeperatorViewDisplay];
}

- (void)updateSeperatorViewDisplay
{
    sepertatorView.columnCount = self.columnCount;
    sepertatorView.rowCount = self.rowCount;
    
    [sepertatorView setX:self.padding.left y:self.padding.top width:self.width - self.padding.left - self.padding.right height:self.height - self.padding.top - self.padding.bottom];
    [sepertatorView setNeedsDisplay];
}

- (CGFloat)xOffsetWithIndex:(NSInteger)index
{
    if ((self.alignment & PSButtonBarAlignmentHorizontal) == PSButtonBarAlignmentHorizontal &&
        (self.alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
    {
        NSInteger columnIndex = index%self.columnCount;
        return self.padding.left + (columnIndex*self.buttonWidth) + (columnIndex*self.horizontalGap);
    }
    
    if ((self.alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return self.padding.left;
    
    return self.padding.left + (index*self.buttonWidth) + (index*self.horizontalGap);
}

- (CGFloat)yOffsetWithIndex:(NSInteger)index
{
    if ((self.alignment & PSButtonBarAlignmentHorizontal) == PSButtonBarAlignmentHorizontal &&
        (self.alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
    {
        NSInteger rowIndex = floorf((CGFloat) index/self.columnCount);
        return self.padding.top + (rowIndex*self.buttonHeight) + (rowIndex*self.verticalGap);
    }
    
    if ((self.alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return self.padding.top + (index*self.buttonHeight) + (index*self.verticalGap);
    
    return self.padding.top;
}

#pragma mark - Private Button selector

- (void)buttonTouchUpInside:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buttonBar:buttonClicked:buttonIndex:)])
        [self.delegate buttonBar:self buttonClicked:sender buttonIndex:(int) [self.buttons indexOfObject:sender]];
    
    if (!self.toggle)
        return;
    
    @synchronized (self)
    {
        if (sender != _selectedChild)
        {
            [self deselectWithoutClearIndex];
            
            NSUInteger buttonIndex = [_buttons indexOfObject:sender];
            _selectedChild = sender;
            _selectedChild.userInteractionEnabled = NO;
            _selectedChild.selected = YES;
            _selectedIndex = (int) buttonIndex;
            
            if (self.delegate)
                [self.delegate buttonBar:self buttonSelected:sender buttonIndex:(int) buttonIndex];
        }
    }
}

@end

// ================================================================================================
//
//  Implementation: PSButtonBarDelegateObject
//
// ================================================================================================

@interface PSButtonBarDelegateObject ()
@property (nonatomic, copy) PSButtonBarDelegateBlock clicked;
@property (nonatomic, copy) PSButtonBarDelegateBlock render;
@property (nonatomic, copy) PSButtonBarDelegateBlock resized;
@property (nonatomic, copy) PSButtonBarDelegateBlock selected;
@end

@implementation PSButtonBarDelegateObject

// ================================================================================================
//  Overridden: NSObject
// ================================================================================================

#pragma mark - Overridden: NSObject

- (id)initWithRender:(PSButtonBarDelegateBlock)render clicked:(PSButtonBarDelegateBlock)clicked resized:(PSButtonBarDelegateBlock)resized selected:(PSButtonBarDelegateBlock)selected
{
    self = [super init];
    
    if (self)
        [self render:render clicked:clicked resized:resized selected:selected];
    
    return self;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public methods

- (void)clear
{
    self.render = NULL;
    self.clicked = NULL;
    self.resized = NULL;
    self.selected = NULL;
}

- (void)render:(PSButtonBarDelegateBlock)render clicked:(PSButtonBarDelegateBlock)clicked resized:(PSButtonBarDelegateBlock)resized selected:(PSButtonBarDelegateBlock)selected
{
    self.render = render;
    self.clicked = clicked;
    self.resized = resized;
    self.selected = selected;
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - PSButtonBar Delegate

- (void)buttonBar:(PSButtonBar *)buttonBar buttonClicked:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex
{
    if (self.clicked)
        self.clicked(button, buttonIndex);
}

- (void)buttonBar:(PSButtonBar *)buttonBar buttonRender:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex
{
    if (self.render)
        self.render(button, buttonIndex);
}

- (void)buttonBar:(PSButtonBar *)buttonBar buttonResized:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex
{
    if (self.resized)
        self.resized(button, buttonIndex);
}

- (void)buttonBar:(PSButtonBar *)buttonBar buttonSelected:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex
{
    if (self.selected)
        self.selected(button, buttonIndex);
}

@end

// ================================================================================================
//
//  Implementation: PSButtonBarSeperatorView
//
// ================================================================================================

@implementation PSButtonBarSeperatorView

// ================================================================================================
//  Overridden: PSView
// ================================================================================================

#pragma mark - Overridden: PSView

- (void)initProperties
{
    _lineColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    
    [self drawHorizontalLineWithContext:context rect:rect];
    [self drawVerticalLineWithContext:context rect:rect];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (void)drawHorizontalLineWithContext:(CGContextRef)context rect:(CGRect)rect
{
    if (self.rowCount < 1)
        return;
    
    CGContextSetLineWidth(context, 0.5);
    
    CGFloat y = rect.size.height/self.rowCount;
    
    for (NSUInteger i=0; i<self.rowCount-1; i++)
    {
        CGContextMoveToPoint(context, self.padding.left, (i+1) * y);
        CGContextAddLineToPoint(context, rect.size.width - self.padding.right, (i+1) * y);
        CGContextStrokePath(context);
    }
}

- (void)drawVerticalLineWithContext:(CGContextRef)context rect:(CGRect)rect
{
    if (self.columnCount < 1)
        return;
    
    CGContextSetLineWidth(context, 0.5);
    
    CGFloat x = rect.size.width/self.columnCount;
    
    for (NSUInteger i=0; i<self.columnCount-1; i++)
    {
        CGContextMoveToPoint(context, (i+1) * x, self.padding.top);
        CGContextAddLineToPoint(context, (i+1) * x, rect.size.height - self.padding.bottom);
        CGContextStrokePath(context);
    }
}

@end