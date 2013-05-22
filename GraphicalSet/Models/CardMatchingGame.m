//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Richard Shin on 4/27/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "CardMatchingGame.h"
#import "GameResult.h"

@interface CardMatchingGame ()
@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) NSString *result;
@property (readwrite, nonatomic) NSArray *cardsFromResult; // of Card
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (strong, nonatomic) GameResult *gameResult;
@property (strong, nonatomic) Deck *deck;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSArray *)cardsFromResult {
    if (!_cardsFromResult) _cardsFromResult = [[NSArray alloc] init];
    return _cardsFromResult;
}

- (GameResult *)gameResult {
    if (!_gameResult) {
        _gameResult = [[GameResult alloc] init];
        _gameResult.gameName = self.gameName;
    }
    return _gameResult;
}

- (NSArray *)faceUpPlayableCards {
    // Get face-up, playable cards
    NSIndexSet *indexes = [self.cards indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                           { return ((Card *)obj).isFaceUp && !((Card *)obj).isUnplayable; }];
    return [self.cards objectsAtIndexes:indexes];
}

- (int)numberOfCardsToMatch {
    // Guard against nonsense values by defaulting to two-card match
    if (_numberOfCardsToMatch == 0 ||
        _numberOfCardsToMatch > [self.cards count]) {
        _numberOfCardsToMatch = 2;
    }
    return _numberOfCardsToMatch;
}

-(CGFloat)matchBonusMultiplier {
    if (_matchBonusMultiplier == 0) _matchBonusMultiplier = 2;
    return _matchBonusMultiplier;
}
- (int)mismatchPenalty {
    if (_mismatchPenalty == 0) _mismatchPenalty = 2;
    return _mismatchPenalty;
}
- (int)flipCost {
    if (_flipCost == 0) _flipCost = 1;
    return _flipCost;
}
- (NSUInteger)cardsInPlayCount {
    return [self.cards count];
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        self.deck = deck;
        for (int i = 0; i < count; i++)
        {
            Card *card =  [deck drawRandomCard];
            // Check if we fail to draw a card, e.g. when count > size of deck
            if (card) self.cards[i] = card;
            else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    // Make sure valid card exists at this index
    if (card && !card.isUnplayable) {
        // Make sure card is not already face up
        if (!card.isFaceUp)
        {
            NSArray *otherCards = [self faceUpPlayableCards];
            NSArray *matchedCards = [otherCards arrayByAddingObject:card];
            
            // Check if we have enough face-up, playable cards to score a match
            if ([matchedCards count] != self.numberOfCardsToMatch) {
                self.result = [NSString stringWithFormat:@"Flipped up %@", [CardMatchingGame formatCardsAsString:@[card]]];
                self.cardsFromResult = [[NSArray alloc] initWithObjects:card, nil];
            } else {
                // Get the match score of the card(s)
                int matchScore = [card match:otherCards];
                self.cardsFromResult = [matchedCards copy];
                
                // If they match at all, make them unplayable and add match score. Otherwise, flip the other card(s)
                if (matchScore) {
                    for (Card *matchedCard in matchedCards) matchedCard.unplayable = YES;
                    // Multiply our match score by our multiplier, with a bonus for multicard matches
                    matchScore = matchScore * self.matchBonusMultiplier * [otherCards count];
                    self.score += matchScore;
                    self.result = [NSString stringWithFormat:@"Matched %@ (+%d)", [CardMatchingGame formatCardsAsString:matchedCards], matchScore];
                } else {
                    for (Card *matchedCard in matchedCards) matchedCard.faceUp = NO;
                    matchScore = self.mismatchPenalty * [otherCards count];
                    self.score -= matchScore;
                    self.result = [NSString stringWithFormat:@"%@ don’t match! (-%d)", [CardMatchingGame formatCardsAsString:matchedCards], matchScore];
                }
            }
            self.score -= self.flipCost;
            self.gameResult.score = self.score;
            [self.gameResult synchronize];
        }
        card.faceUp = !card.faceUp;
    }
}

+ (NSString *)formatCardsAsString:(NSArray *)cards
{
    NSMutableString *mutableString = nil;
    
    if ([cards count]) {
        mutableString = [[NSMutableString alloc] init];
        BOOL firstRun = true;
        for (Card *card in cards) {
            if ([card isKindOfClass:[Card class]]) {
                if (firstRun) [mutableString appendString:[NSString stringWithFormat:@"[%@]", card.contents]];
                else          [mutableString appendString:[NSString stringWithFormat:@"&[%@]", card.contents]];
            }
        }
    }
    
    return [mutableString copy];
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

// Returns card that has been played, nil if no more cards could be played from the deck
- (Card *)drawCardFromDeck
{
    Card *card = [self.deck drawRandomCard];
    if (card) [self.cards addObject:card];
    return card;
}

- (BOOL)hasDrawableCards {
    return [self.deck hasDrawableCards];
}

@end
