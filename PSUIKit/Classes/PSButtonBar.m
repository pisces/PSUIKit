//
//  PSButtonBar.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "PSButtonBar.h"
#import "PSButton.h"

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
        
        if (_toggle)
        {
            _selectedChild = [_buttons objectAtIndex:_selectedIndex];
            _selectedChild.userInteractionEnabled = NO;
            _selectedChild.selected = YES;
        }
    }
    
    if (shouldRedrawSepertatorView)
    {
        shouldRedrawSepertatorView = NO;
        sepertatorView.lineColor = _seperatorColor;
        sepertatorView.lineWidth = _seperatorLineWidth;
        sepertatorView.padding = _seperatorPadding;
        
        [self updateSeperatorViewDisplay];
    }
}

- (void)initProperties
{
    _alignment = PSButtonBarAlignmentHorizontal;
    _selectedIndex = -1;
    _horizontalGap = 0;
    _seperatorLineWidth = 1;
    _verticalGap = 0;
    _padding = CGPaddingMake(0, 0, 0, 0);
    _seperatorColor = [UIColor clearColor];
    
    sepertatorView = [[PSButtonBarSeperatorView alloc] init];
    sepertatorView.lineColor = _seperatorColor;
    sepertatorView.lineWidth = _seperatorLineWidth;
    sepertatorView.padding = _seperatorPadding;
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
    
    for (NSUInteger i=0; i<_buttons.count; i++)
        [self.delegate buttonBar:self buttonRender:[_buttons objectAtIndex:i] buttonIndex:i];
}

- (void)deselect
{
    [self deselectWithoutClearIndex];
    _selectedIndex = -1;
}

#pragma mark - Public getter/setter

- (id<PSButtonBarDelegate>)delegate
{
    return _delegateObject ? _delegateObject : _delegate;
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

- (void)setSeperatorLineWidth:(CGFloat)seperatorLineWidth {
    if (seperatorLineWidth == _seperatorLineWidth)
        return;
    
    _seperatorLineWidth = seperatorLineWidth;
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
    if ((_alignment & PSButtonBarAlignmentHorizontal) == PSButtonBarAlignmentHorizontal &&
        (_alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return (self.height - _padding.top - _padding.bottom - (_verticalGap*(_rowCount-1)))/_rowCount;
    
    if ((_alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return (self.height - _padding.top - _padding.bottom - (_verticalGap * (_numOfButtons-1)))/_numOfButtons;
    
    return self.height - _padding.top - _padding.bottom;
}

- (CGFloat)calculatedButtonWidth
{
    if ((_alignment & PSButtonBarAlignmentHorizontal) == PSButtonBarAlignmentHorizontal &&
        (_alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return (self.width - _padding.left - _padding.right - (_horizontalGap*(_columnCount-1)))/_columnCount;
    
    if ((_alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return self.width - _padding.left - _padding.right;
    
    return (self.width - _padding.left - _padding.right - (_horizontalGap * (_numOfButtons-1)))/_numOfButtons;
}

- (NSInteger)calculatedColumnCount
{
    if ((_alignment & PSButtonBarAlignmentHorizontal) == PSButtonBarAlignmentHorizontal &&
        (_alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return _columnCount > 0 ? _columnCount : _numOfButtons;
    
    if ((_alignment & PSButtonBarAlignmentHorizontal) == PSButtonBarAlignmentHorizontal)
        return _numOfButtons;
    
    return 1;
}

- (NSInteger)calculatedRowCount
{
    if ((_alignment & PSButtonBarAlignmentHorizontal) == PSButtonBarAlignmentHorizontal &&
        (_alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return ceilf((CGFloat) _numOfButtons/_columnCount);
    
    if ((_alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return _numOfButtons;
    
    return 1;
}

#pragma mark - Private methods

- (void)addButtonTargets:(UIButton *)button
{
    [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createButtons
{
    if (_buttons)
        return;
    
    _columnCount = self.calculatedColumnCount;
    _rowCount = self.calculatedRowCount;
    _buttons = [NSMutableArray array];
    _buttonWidth = self.calculatedButtonWidth;
    _buttonHeight = self.calculatedButtonHeight;
    
    for (NSUInteger i=0; i<_numOfButtons; i++)
    {
        UIButton *button = [PSButton buttonWithType:_buttonType];
        button.frame = CGRectMake([self xOffsetWithIndex:i], [self yOffsetWithIndex:i], _buttonWidth, _buttonHeight);
        button.userInteractionEnabled = YES;
        button.titleLabel.minimumScaleFactor = 0.5;
        
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
    
    for (NSUInteger i=0; i<_buttons.count; i++)
    {
        UIButton *button = [_buttons objectAtIndex:i];
        button.frame = CGRectMake([self xOffsetWithIndex:i], [self yOffsetWithIndex:i], _buttonWidth, _buttonHeight);
        
        if ([self.delegate respondsToSelector:@selector(buttonBar:buttonResized:buttonIndex:)])
            [self.delegate buttonBar:self buttonResized:button buttonIndex:i];
    }
    
    [self updateSeperatorViewDisplay];
}

- (void)updateSeperatorViewDisplay
{
    sepertatorView.columnCount = _columnCount;
    sepertatorView.rowCount = _rowCount;
    
    [sepertatorView setX:_padding.left y:_padding.top width:self.width - _padding.left - _padding.right height:self.height - _padding.top - _padding.bottom];
    [sepertatorView setNeedsDisplay];
}

- (CGFloat)xOffsetWithIndex:(NSInteger)index
{
    if ((_alignment & PSButtonBarAlignmentHorizontal) == PSButtonBarAlignmentHorizontal &&
        (_alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
    {
        NSInteger columnIndex = index%_columnCount;
        return _padding.left + (columnIndex*_buttonWidth) + (columnIndex*_horizontalGap);
    }
    
    if ((_alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return _padding.left;
    
    return _padding.left + (index*_buttonWidth) + (index*_horizontalGap);
}

- (CGFloat)yOffsetWithIndex:(NSInteger)index
{
    if ((_alignment & PSButtonBarAlignmentHorizontal) == PSButtonBarAlignmentHorizontal &&
        (_alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
    {
        NSInteger rowIndex = floorf((CGFloat) index/_columnCount);
        return _padding.top + (rowIndex*_buttonHeight) + (rowIndex*_verticalGap);
    }
    
    if ((_alignment & PSButtonBarAlignmentVertical) == PSButtonBarAlignmentVertical)
        return _padding.top + (index*_buttonHeight) + (index*_verticalGap);
    
    return _padding.top;
}

#pragma mark - Private Button selector

- (void)buttonTouchUpInside:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buttonBar:buttonClicked:buttonIndex:)])
        [self.delegate buttonBar:self buttonClicked:sender buttonIndex:(int) [_buttons indexOfObject:sender]];
    
    if (!_toggle)
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
    _render = NULL;
    _clicked = NULL;
    _resized = NULL;
    _selected = NULL;
}

- (void)render:(PSButtonBarDelegateBlock)render clicked:(PSButtonBarDelegateBlock)clicked resized:(PSButtonBarDelegateBlock)resized selected:(PSButtonBarDelegateBlock)selected
{
    _render = render;
    _clicked = clicked;
    _resized = resized;
    _selected = selected;
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - PSButtonBar Delegate

- (void)buttonBar:(PSButtonBar *)buttonBar buttonClicked:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex
{
    if (_clicked)
        _clicked(button, buttonIndex);
}

- (void)buttonBar:(PSButtonBar *)buttonBar buttonRender:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex
{
    if (_render)
        _render(button, buttonIndex);
}

- (void)buttonBar:(PSButtonBar *)buttonBar buttonResized:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex
{
    if (_resized)
        _resized(button, buttonIndex);
}

- (void)buttonBar:(PSButtonBar *)buttonBar buttonSelected:(UIButton *)button buttonIndex:(NSUInteger)buttonIndex
{
    if (_selected)
        _selected(button, buttonIndex);
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
    _lineWidth = 1;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextSetLineWidth(context, _lineWidth);
    
    [self drawHorizontalLineWithContext:context rect:rect];
    [self drawVerticalLineWithContext:context rect:rect];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (void)drawHorizontalLineWithContext:(CGContextRef)context rect:(CGRect)rect
{
    if (_rowCount < 1)
        return;
    
    CGFloat y = rect.size.height/_rowCount;
    
    for (NSUInteger i=0; i<_rowCount-1; i++)
    {
        CGContextMoveToPoint(context, _padding.left, (i+1) * y);
        CGContextAddLineToPoint(context, rect.size.width - _padding.right, (i+1) * y);
        CGContextStrokePath(context);
    }
}

- (void)drawVerticalLineWithContext:(CGContextRef)context rect:(CGRect)rect
{
    if (_columnCount < 1)
        return;
    
    CGFloat x = rect.size.width/_columnCount;
    
    for (NSUInteger i=0; i<_columnCount-1; i++)
    {
        CGContextMoveToPoint(context, (i+1) * x, _padding.top);
        CGContextAddLineToPoint(context, (i+1) * x, rect.size.height - _padding.bottom);
        CGContextStrokePath(context);
    }
}

@end