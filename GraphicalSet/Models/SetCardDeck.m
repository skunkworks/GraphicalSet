//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Richard Shin on 5/7/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "SetCardDeck.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];
    
    for (NSNumber *number in [SetCard validNumbers]) {
        for (NSNumber *symbol in [SetCard validSymbols]) {
            for (NSNumber *shade in [SetCard validShades]) {
                for (NSNumber *color in [SetCard validColors]) {
                    SetCard *card = [[SetCard alloc] init];
                    card.number = [number integerValue];
                    card.symbol = [symbol integerValue];
                    card.shade = [shade integerValue];
                    card.color = [color integerValue];
                    [self addCard:card atTop:YES];
                }
            }
        }
    }
    
    return self;
}

@end
