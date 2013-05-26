//
//  FlipResultView.m
//  GraphicalSet
//
//  Created by Richard Shin on 5/20/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "FlipResultView.h"

@interface FlipResultView ()
@property (strong, nonatomic) NSString *result;
@property (strong, nonatomic) NSArray *cardSubviews;
@end

@implementation FlipResultView

- (CGFloat) cardSubviewDisplayRatio {
    if (_cardSubviewDisplayRatio <= 0) {
        _cardSubviewDisplayRatio = 1;
    }
    return _cardSubviewDisplayRatio;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)displayResultString:(NSString *)result
{
    self.result = result;
    self.cardSubviews = nil;
    [self setNeedsDisplay];
}

- (void)displayResultString:(NSString *)result
           withCardSubviews:(NSArray *)cardSubviews
               displayRatio:(CGFloat)displayRatio
{
    self.result = result;
    self.cardSubviews = cardSubviews;
    self.cardSubviewDisplayRatio = displayRatio;
    [self setNeedsDisplay];
}


#define FONT_SCALE_FACTOR 0.60

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    UIFont *font = [UIFont systemFontOfSize:self.bounds.size.height * FONT_SCALE_FACTOR];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;

    NSArray *resultStringArray = [FlipResultView parseResultString:self.result];
    int xCoordinate = 0;
    int subviewIndex = 0;
    for (id object in resultStringArray) {
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = (NSString *)object;
            NSAttributedString *resultText = [[NSAttributedString alloc] initWithString:string attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font }];
            CGRect textBounds;
            textBounds.origin = CGPointMake(xCoordinate, (self.bounds.size.height - [resultText size].height)/2);
            textBounds.size = [resultText size];
            [resultText drawInRect:textBounds];
            xCoordinate += textBounds.size.width;
        } else if ([object isMemberOfClass:[NSNull class]]) {
            if (subviewIndex < [self.cardSubviews count]) {
                UIView *subview = (UIView *)self.cardSubviews[subviewIndex];
                CGRect viewBounds;
                viewBounds.origin = CGPointMake(xCoordinate, 0);
                viewBounds.size = CGSizeMake(self.bounds.size.height*self.cardSubviewDisplayRatio, self.bounds.size.height);
                subview.frame = viewBounds;
                subview.backgroundColor = [UIColor clearColor];
                [self addSubview:subview];
                xCoordinate += viewBounds.size.width;
                subviewIndex++;

            }
        }
    }    
}

+ (NSArray *)parseResultString:(NSString *)string
{
    if (!string) return nil;
    
    NSMutableArray *resultStringArray = [[NSMutableArray alloc] init];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[.*?]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *textCheckingResults = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    if ([textCheckingResults count]) {
        int trailingIndex = 0;
        for (NSTextCheckingResult *textCheckingResult in textCheckingResults) {
            NSRange cardRange = [textCheckingResult range];
            [resultStringArray addObject:[string substringWithRange:NSMakeRange(trailingIndex, cardRange.location-trailingIndex)]];
            [resultStringArray addObject:[NSNull null]];
            trailingIndex = cardRange.location + cardRange.length;
        }
        if (trailingIndex != string.length) {
            [resultStringArray addObject:[string substringWithRange:NSMakeRange(trailingIndex, string.length-trailingIndex)]];
        }
    } else {
        [resultStringArray addObject:string];
    }
    
    return [resultStringArray copy];
}

@end
