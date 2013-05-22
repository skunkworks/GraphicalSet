//
//  PlayingCard.m
//  Matchismo
//
//  Created by Richard Shin on 4/27/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provided setter + getter

+ (NSArray *)validSuits {
    static NSArray *validSuits = nil;
    if (!validSuits) validSuits = @[@"♠",@"♣", @"♥", @"♦"];
    return validSuits;
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        if (otherCard.rank == self.rank) {
            score = 4;
        } else if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        }
    } else if ([otherCards count] == 2) {
        PlayingCard *secondCard = otherCards[0];
        PlayingCard *thirdCard = otherCards[1];
        score = [self match:@[secondCard]] + [self match:@[thirdCard]] + [secondCard match:@[thirdCard]];
    }
    
    return score;
}

+ (NSArray *)rankStrings {
    static NSArray *rankStrings = nil;
    if (!rankStrings) rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
    return rankStrings;
}

+ (NSUInteger)maxRank { return [self rankStrings].count - 1; }

@end
