//
//  PlayingCard.h
//  Matchismo
//
//  Created by Richard Shin on 4/27/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
