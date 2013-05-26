//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Richard Shin on 5/6/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardCollectionViewCell.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}
- (NSString *)identifier {
    return @"SetCard";
}
- (NSUInteger)startingCardCount {
    return 12;
}
- (NSUInteger)numberOfCardsToMatch {
    return 3;
}
- (NSUInteger)numberOfCardsToAdd {
    return 3;
}
- (int)flipCost {
    return 1;
}
- (int)mismatchPenalty {
    return 2;
}
- (CGFloat)matchBonusMultiplier {
    return 3;
}
- (CGFloat)cardSubviewDisplayRatio {
    return 1;
}

- (void)updateCell:(UICollectionViewCell *)cell
          withCard:(Card *)card
{
    if ([card isMemberOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        
        if ([cell isMemberOfClass:[SetCardCollectionViewCell class]]) {
            SetCardCollectionViewCell *sccvc = (SetCardCollectionViewCell *)cell;
            SetCardView *setCardView = sccvc.setCardView;
            
            setCardView.number = setCard.number;
            setCardView.symbol = setCard.symbol;
            setCardView.color = setCard.color;
            setCardView.shade = setCard.shade;
            setCardView.faceUp = setCard.faceUp;
        }
    }
}

// Accepts array of Card, returns array of UIView
+ (NSArray *)createCardSubviews:(NSArray *)cards
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for (Card *card in cards) {
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            SetCardView *view = [[SetCardView alloc] init];
            view.color = setCard.color;
            view.number = setCard.number;
            view.shade = setCard.shade;
            view.symbol = setCard.symbol;
            [mutableArray addObject:view];
        }
    }
    
    return [mutableArray copy];
}
@end
