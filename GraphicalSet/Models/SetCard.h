//
//  SetCard.h
//  Matchismo
//
//  Created by Richard Shin on 5/6/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger shade;
@property (nonatomic) NSUInteger color;

+ (NSArray *)validSymbols;
+ (NSArray *)validShades;
+ (NSArray *)validColors;
+ (NSArray *)validNumbers;

@end
