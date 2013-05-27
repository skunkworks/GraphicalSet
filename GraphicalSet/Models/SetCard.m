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
    NSArray *allCards = [otherCards arrayByAddingObject:self];
    int allCardsCount = [allCards count];
    
    // Test for similarity or for mutual exclusion
    NSSet *setOfSymbols = [[NSMutableSet alloc] initWithArray:[allCards valueForKey:@"symbol"]];
    NSSet *setOfNumbers = [[NSMutableSet alloc] initWithArray:[allCards valueForKey:@"number"]];
    NSSet *setOfShades = [[NSMutableSet alloc] initWithArray:[allCards valueForKey:@"shade"]];
    NSSet *setOfColors = [[NSMutableSet alloc] initWithArray:[allCards valueForKey:@"color"]];
    
    if (([setOfSymbols count] == 1 || [setOfSymbols count] == allCardsCount) &&
        ([setOfNumbers count] == 1 || [setOfNumbers count] == allCardsCount) &&
        ([setOfShades count] == 1 || [setOfShades count] == allCardsCount) &&
        ([setOfColors count] == 1 || [setOfColors count] == allCardsCount)) {
        return 1;
    }
    return 0;
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
