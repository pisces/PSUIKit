//
//  PentagonChart.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Modified by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "PentagonChart.h"

#define PentagonColors @[[UIColor colorWithRed:0.0 green:228/255.0 blue:1.0 alpha:0.7], [UIColor colorWithRed:248/255.0 green:65/255.0 blue:29/255.0 alpha:1.0]]

@implementation PentagonChart
{
@private
    NSMutableArray *labelList;
}

@synthesize entities = _entities;

// ================================================================================================
//  Overridden: UIView
// ================================================================================================

- (id)init
{
    self = [super init];
    if (self)
        [self initProperties];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self initProperties];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self initProperties];
    return self;
}

- (id)initWithFrame:(CGRect)frame labelNames:(NSArray *)names
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.labelNames = names;
        [self initProperties];
    }
    return self;
}

- (void)dealloc
{
    [labelList removeAllObjects];
    
    labelList = nil;
    _entities = nil;
    _labelNames = nil;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self drawBasePentagons];
    [self setLabels];
    [self drawPentagons];
}

// ================================================================================================
//  Public
// ================================================================================================

- (void)drawPentagons
{
    if (!_entities)
        return;
   
    int i = 0;
    for (NSArray *data in _entities)
    {
        UIColor *color = [PentagonColors objectAtIndex:i];
        [color setStroke];
        [color setFill];
        [self drawPentagonWithValues:data];
        i++;
    }
}

- (void)drawPentagonWithValues:(NSArray *)values
{
    float radius;
    NSArray *points;
    NSMutableArray *petagonPoints = [NSMutableArray arrayWithCapacity:5];
    for (int i=1; i<=values.count; i++)
    {
        radius = (self.frame.size.width/2*[[values objectAtIndex:i-1] floatValue])/_maximumValue;
        points = [self pointsWithPath:nil x:self.frame.size.width/2 y:self.frame.size.height/2 sides:5 radius:radius angle:90];
        [petagonPoints addObject:[points objectAtIndex:values.count-i]];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointFromString([petagonPoints objectAtIndex:0])];
    [path addLineToPoint:CGPointFromString([petagonPoints objectAtIndex:1])];
    [path addLineToPoint:CGPointFromString([petagonPoints objectAtIndex:2])];
    [path addLineToPoint:CGPointFromString([petagonPoints objectAtIndex:3])];
    [path addLineToPoint:CGPointFromString([petagonPoints objectAtIndex:4])];
    [path addLineToPoint:CGPointFromString([petagonPoints objectAtIndex:0])];
    [path closePath];
    [path strokeWithBlendMode:kCGBlendModeNormal alpha:0.7];
    [path fillWithBlendMode:kCGBlendModeNormal alpha:0.3];
    CGContextRestoreGState(context);
}

- (void)setEntities:(NSArray *)entities
{
    if ([entities isEqual:_entities])
        return;
    
    if (_entities)
        _entities = nil;
    
    _entities = entities;
    
    [self setNeedsDisplay];
}

// ================================================================================================
//  Internal
// ================================================================================================

- (void)drawBasePentagons
{
    //[[UIColor darkGrayColor] setStroke];
    //modified by sangchan @2013.7.23 : 알파값 변경
    [[UIColor clearColor] setFill];
    
    float radius1 = 100;
    float step = radius1/5;
    NSArray *list = [NSArray arrayWithObjects:[NSNumber numberWithInt:radius1], [NSNumber numberWithInt:radius1-(step*1)], [NSNumber numberWithInt:radius1-(step*2)], [NSNumber numberWithInt:radius1-(step*3)], [NSNumber numberWithInt:radius1-(step*4)], nil];
    
    for (int i=1; i<=list.count; i++)
    {
        if (i == 1)
            [[UIColor colorWithRed:15/255.0 green:149/255.0 blue:196/255.0 alpha:1.0] setStroke];
        else
            [[UIColor colorWithRed:91/255.0 green:105/255.0 blue:117/255.0 alpha:1.0] setStroke];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path fill];
        path.lineWidth = (i == 1) ? 2.0f: 1.0f;
        [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    }
}

- (void)initProperties
{
    self.backgroundColor = [UIColor clearColor];
    
    _maximumValue = 100;
    labelList = [NSMutableArray arrayWithCapacity:5];
    
    for (int i=0; i<5; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:12.0];
        label.textColor = [UIColor colorWithRed:178/255.0 green:194/255.0 blue:207/255.0 alpha:1.0];
        label.hidden = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [labelList addObject:label];
    }
}

- (NSMutableArray *)pointsWithPath:(UIBezierPath *)path x:(float)x y:(float)y sides:(int)sides radius:(float)radius angle:(float)angle
{
    int count = ABS(sides);
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:5];
    if (count > 2)
    {
        float step, start, n, dx, dy;
        step = (M_PI*2/sides);
        start = (angle/180)*M_PI;
        
        if (path)
            [path moveToPoint:CGPointMake(x+(cosf(start)*radius), y-(sinf(start)*radius))];
        
        for (n=1; n<=count; n++)
        {
            dx = x+cosf(start+(step*n))*radius;
            dy = y-sinf(start+(step*n))*radius;
            CGPoint point = CGPointMake(dx, dy);
            
            if (path)
                [path addLineToPoint:point];
            
            [points addObject:NSStringFromCGPoint(point)];
        }
        
        if (path)
            [path closePath];
    }
    return points;
}

- (void)setLabels
{
    float w2 = self.frame.size.width/2;
    float h2 = self.frame.size.width/2;
    NSArray *points = [self pointsWithPath:nil x:w2 y:h2 sides:5 radius:w2 angle:90];
    for (int i=0; i<points.count; i++)
    {
        CGPoint point = CGPointFromString([points objectAtIndex:i]);
        NSString *name = [self.labelNames objectAtIndex:i];
        UILabel *label = [labelList objectAtIndex:i];
        label.text = name;
        
        [GraphicsLayout widthFitByText:label];
        [GraphicsLayout heightFitByText:label];
        
        CGRect labelFrame = label.frame;
        if (i==0)
        {
            labelFrame.origin.x = point.x - labelFrame.size.width - 5;
            labelFrame.origin.y = point.y - labelFrame.size.height/2;
        }
        else if (i==1 || i==2)
        {
            labelFrame.origin.x = point.x - labelFrame.size.width/2;
            labelFrame.origin.y = point.y + 5;
        }
        else if (i==3)
        {
            labelFrame.origin.x = point.x + 5;
            labelFrame.origin.y = point.y - labelFrame.size.height/2;
        }
        else if (i==4)
        {
            labelFrame.origin.x = point.x - labelFrame.size.width/2;
            labelFrame.origin.y = point.y - labelFrame.size.height - 5;
        }
        
        label.frame = labelFrame;
        label.hidden = NO;
    }
}
@end
