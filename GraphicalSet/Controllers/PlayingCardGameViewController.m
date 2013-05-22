//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Richard Shin on 5/7/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardCollectionViewCell.h"

@interface PlayingCardGameViewController ()
@end

@implementation PlayingCardGameViewController

- (NSString *)identifier {
    return @"PlayingCard";
}
- (NSUInteger)startingCardCount {
    return 22;
}
- (NSUInteger)numberOfCardsToMatch {
    return 2;
}
-(CGFloat)matchBonusMultiplier {
    return 2;
}
- (int)mismatchPenalty {
    return 2;
}
- (int)flipCost {
    return 1;
}

// Overrides abstract method in superclass
- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

// Implements/overrides the superclass method
- (void)updateCell:(UICollectionViewCell *)cell
          withCard:(Card *)card
{
    PlayingCard *playingCard = (PlayingCard *)card;
    
    if (playingCard) {
        PlayingCardCollectionViewCell *pccvc = (PlayingCardCollectionViewCell *)cell;
        
        if (pccvc) {
            PlayingCardView *playingCardView = pccvc.playingCardView;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.alpha = playingCard.isUnplayable ? .3 : 1;
        }
    }
}

// Accepts array of Card, returns array of UIView
+ (NSArray *)createCardSubviews:(NSArray *)cards
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for (Card *card in cards) {
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            PlayingCardView *view = [[PlayingCardView alloc] init];
            view.rank = playingCard.rank;
            view.suit = playingCard.suit;
            view.faceUp = YES;
            [mutableArray addObject:view];
        }
    }
    
    return [mutableArray copy];
}

@end