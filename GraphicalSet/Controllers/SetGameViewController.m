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
- (NSArray *)createCardSubviews:(NSArray *)cards
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

//// Precondition: cards array is sorted in the same order that they appear in resultString (which should be implemented in CardMatchingGame.h)
//+ (NSAttributedString *)attributedStringFromResultString:(NSString *)resultString
//                                               withCards:(NSArray *)cards
//{
//    NSMutableAttributedString *mutableAttributedString = nil;
//    
//    if (resultString) {
//        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:resultString];
//        NSRange searchRange = NSMakeRange(0, resultString.length);
//        
//        for (SetCard *card in cards) {
//            NSRange cardRange = [resultString rangeOfString:card.contents
//                                                    options:NSLiteralSearch
//                                                      range:searchRange];
//            if (cardRange.location != NSNotFound) {
//                [mutableAttributedString addAttributes:[[self class] attributesForSetCard:card]
//                                                 range:cardRange];
//            }
//            searchRange.location = cardRange.location + cardRange.length;
//            searchRange.length = resultString.length - searchRange.location;
//        }
//    }
//    [mutableAttributedString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}
//                                     range:NSMakeRange(0, [resultString length])];
//    
//    return [mutableAttributedString copy];
//}
//
//+ (NSAttributedString *)attributedStringFromSetCard:(SetCard *)card {
//    NSAttributedString *attributedString = nil;
//    
//    if (card) {
//        NSDictionary *attributes = [[self class]attributesForSetCard:card];
//        attributedString = [[NSAttributedString alloc] initWithString:card.contents attributes:attributes];
//    }
//    
//    return attributedString;
//}
//
//+ (NSDictionary *)attributesForSetCard:(SetCard *)card {
//    NSDictionary *attributes = nil;
//    
//    if (card) {
//        // Get color for this card. Note that if the symbol has a shade setting of "shaded", we use transparency to draw it as such
//        UIColor *strokeColor = [[self class] colorForSetCard:card withAlpha:1];
//        UIColor *fillColor = (card.shade == 2) ?
//                             [[self class] colorForSetCard:card withAlpha:.3] :
//                             strokeColor;
//        
//        // If symbol has shade setting of "open", we want to draw the outline only, so we set the stroke width to a positive NSNumber.
//        NSNumber *strokeWidth = @-10;
//        if (card.shade == 3) {
//            strokeWidth = @10;
//        }
//        
//        attributes = @{NSForegroundColorAttributeName : fillColor,
//                       NSStrokeColorAttributeName : strokeColor,
//                       NSStrokeWidthAttributeName : strokeWidth };
//    }
//    
//    return attributes;
//}
@end
