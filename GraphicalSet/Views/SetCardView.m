//
//  SetCardView.m
//  GraphicalSet
//
//  Created by Richard Shin on 5/18/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (void)setColor:(NSUInteger)color {
    _color = color;
    [self setNeedsDisplay];
}
- (void)setNumber:(NSUInteger)number {
    _number = number;
    [self setNeedsDisplay];
}
- (void)setSymbol:(NSUInteger)symbol {
    _symbol = symbol;
    [self setNeedsDisplay];
}
- (void)setShade:(NSUInteger)shade {
    _shade = shade;
    [self setNeedsDisplay];
}
- (void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIColor *backgroundColor = (self.isFaceUp) ? [UIColor colorWithRed:0 green:0 blue:1 alpha:.3] : [UIColor whiteColor];
    [backgroundColor setFill];
    UIRectFill(self.bounds);
    
    UIColor *strokeColor = [self colorForCardSymbolWithAlpha:1];
    
    UIColor *fillColor = nil;
    // solid color fill
    if (self.shade == 1) {
        fillColor = strokeColor;
    } else if (self.shade == 2) {
        fillColor = [self colorForCardSymbolWithAlpha:.3];
    }

    for (NSValue *rectValue in [self rectsForSymbolsOnCardWithRect:rect]) {
        CGRect symbolRect = [rectValue CGRectValue];
        
        UIBezierPath *bezierPath = [SetCardView bezierPathForSymbol:self.symbol inRect:symbolRect];
        bezierPath.lineWidth = 2;

        [fillColor setFill];
        [strokeColor setStroke];
        [bezierPath fill];
        [bezierPath stroke];
    }
}

#define MARGIN_SCALE .10

// Returns NSArray of NSValue-wrapped CGRects where the symbols should be drawn
- (NSArray *)rectsForSymbolsOnCardWithRect:(CGRect)rect
{
    NSArray *rects = nil;
    
    // An inset rect with margins
    CGFloat marginWidth = rect.size.width * MARGIN_SCALE;
    CGFloat marginHeight = rect.size.height * MARGIN_SCALE;
    CGRect insetRect = CGRectInset(rect, marginWidth, marginHeight);

    CGSize symbolSize = CGSizeMake(insetRect.size.width, insetRect.size.height/3);
    
    if (self.number == 1) {
        rects = @[[NSValue valueWithCGRect:CGRectMake(insetRect.origin.x, insetRect.size.height/3 + marginHeight, symbolSize.width, symbolSize.height)]];
    } else if (self.number == 2) {
        rects = @[[NSValue valueWithCGRect:CGRectMake(insetRect.origin.x, insetRect.size.height/6 + marginHeight, symbolSize.width, symbolSize.height)],
                  [NSValue valueWithCGRect:CGRectMake(insetRect.origin.x, insetRect.size.height/2 + marginHeight, symbolSize.width, symbolSize.height)]];
    } else if (self.number == 3) {
        rects = @[[NSValue valueWithCGRect:CGRectMake(insetRect.origin.x, insetRect.origin.y, symbolSize.width, symbolSize.height)],
                  [NSValue valueWithCGRect:CGRectMake(insetRect.origin.x, insetRect.size.height/3 + marginHeight, symbolSize.width, symbolSize.height)],
                  [NSValue valueWithCGRect:CGRectMake(insetRect.origin.x, insetRect.size.height*2/3 + marginHeight, symbolSize.width, symbolSize.height)]];
    }
    
    return rects;
}

// Returns the UIColor for this card's symbols
- (UIColor *)colorForCardSymbolWithAlpha:(CGFloat)alpha {
    UIColor *color = nil;

    if (self.color == 1) {
        color = [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:alpha];
    } else if (self.color == 2) {
        color = [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:alpha];
    } else if (self.color == 3) {
        color = [[UIColor alloc] initWithRed:.5 green:0 blue:.5 alpha:alpha];
    }
    
    return color;
}

#define KERNING_SCALE .2
#define SQUIGGLE_CONTROL_POINT_PULL_SCALE .5
#define DIAMOND_SIDE_INSET_SCALE .2

// Returns the symbol drawn as a UIBezierPath within the bounds of a CGRect
+ (UIBezierPath *)bezierPathForSymbol:(NSUInteger)symbol inRect:(CGRect)rect {
    UIBezierPath *bezierPath = nil;
    
    CGFloat kerningHeight = KERNING_SCALE * rect.size.height;
    
    if (symbol == 1) {
        // Draw diamond
        bezierPath = [[UIBezierPath alloc] init];
        [bezierPath moveToPoint:CGPointMake(rect.origin.x + (rect.size.width*DIAMOND_SIDE_INSET_SCALE), rect.origin.y + rect.size.height/2)];
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + kerningHeight)];
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x + (rect.size.width*(1-DIAMOND_SIDE_INSET_SCALE)) , rect.origin.y + rect.size.height/2)];
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height - kerningHeight)];
        [bezierPath closePath];
    } else if (symbol == 2) {
        // Draw squiggle
        CGFloat squigglePullStrength = rect.size.height * SQUIGGLE_CONTROL_POINT_PULL_SCALE;
        bezierPath = [[UIBezierPath alloc] init];
        CGPoint topLeft = CGPointMake(rect.origin.x, rect.origin.y+kerningHeight);
        CGPoint bottomRight = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height-kerningHeight);

        CGPoint controlPoint1 = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
        CGPoint controlPoint2 = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y-squigglePullStrength);
        CGPoint controlPoint3 = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
        CGPoint controlPoint4 = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height+squigglePullStrength);

        // Start at top left, add curve to bottom right (using control points)
        [bezierPath moveToPoint:topLeft];
        [bezierPath addCurveToPoint:bottomRight controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        [bezierPath addCurveToPoint:topLeft controlPoint1:controlPoint3 controlPoint2:controlPoint4];
    } else if (symbol == 3) {
        // Draw oval
        bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x, rect.origin.y + kerningHeight, rect.size.width, rect.size.height - (kerningHeight * 2))];
    }
    
    return bezierPath;
}

@end
