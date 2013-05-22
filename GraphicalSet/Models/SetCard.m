//
//  SetCard.m
//  Matchismo
//
//  Created by Richard Shin on 5/6/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

// Format: number, symbol, color, shade
- (NSString *)contents {
    return [NSString stringWithFormat:@"%d|%d|%d|%d",
            self.number, self.symbol, self.color, self.shade];
}

- (void)setSymbol:(NSUInteger)symbol {
    if ([[SetCard validSymbols] containsObject:@(symbol)]) {
        _symbol = symbol;
    }
}
- (void)setShade:(NSUInteger)shade {
    if ([[SetCard validShades] containsObject:@(shade)]) {
        _shade = shade;
    }
}
- (void)setColor:(NSUInteger)color {
    if ([[SetCard validColors] containsObject:@(color)]) {
        _color = color;
    }
}
- (void)setNumber:(NSUInteger)number {
    if ([[SetCard validNumbers] containsObject:@(number)]) {
        _number = number;
    }
}

- (int)match:(NSArray *)otherCards
{
    NSIndexSet *indexSet = [otherCards indexesOfObjectsPassingTest:
     ^BOOL(id obj, NSUInteger idx, BOOL *stop) { return ((SetCard *)obj).symbol == self.symbol; }];
    if ([indexSet count] > 0 && [indexSet count] < [otherCards count]) return 0;
    indexSet = [otherCards indexesOfObjectsPassingTest:
                 ^BOOL(id obj, NSUInteger idx, BOOL *stop) { return ((SetCard *)obj).shade == self.shade; }];
    if ([indexSet count] > 0 && [indexSet count] < [otherCards count]) return 0;
    indexSet = [otherCards indexesOfObjectsPassingTest:
                ^BOOL(id obj, NSUInteger idx, BOOL *stop) { return ((SetCard *)obj).color == self.color; }];
    if ([indexSet count] > 0 && [indexSet count] < [otherCards count]) return 0;
    indexSet = [otherCards indexesOfObjectsPassingTest:
                ^BOOL(id obj, NSUInteger idx, BOOL *stop) { return ((SetCard *)obj).number == self.number; }];
    if ([indexSet count] > 0 && [indexSet count] < [otherCards count]) return 0;

    return 1;
}

+ (NSArray *)validSymbols {
    return @[@(1), @(2), @(3)];
}

+ (NSArray *)validShades {
    return @[@(1), @(2), @(3)];
}

+ (NSArray *)validColors {
    return @[@(1), @(2), @(3)];
}

+ (NSArray *)validNumbers {
    return @[@(1), @(2), @(3)];
}

@end
