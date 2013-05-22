//
//  Card.m
//  Matchismo
//
//  Created by Richard Shin on 4/26/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards)
    {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

- (NSString *)description {
    return self.contents;
}

@end
