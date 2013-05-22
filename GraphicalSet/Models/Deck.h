//
//  Deck.h
//  Matchismo
//
//  Created by Richard Shin on 4/26/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;

- (BOOL)hasDrawableCards;

@end
