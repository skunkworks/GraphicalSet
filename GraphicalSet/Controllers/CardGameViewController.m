//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Richard Shin on 4/24/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "FlipResultView.h"

@interface CardGameViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;
@property (weak, nonatomic) IBOutlet FlipResultView *flipResultView;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) Deck *deck;
@end

@implementation CardGameViewController

#pragma Properties

- (CardMatchingGame *)game {
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:self.deck];
        _game.numberOfCardsToMatch = self.numberOfCardsToMatch;
        _game.matchBonusMultiplier = self.matchBonusMultiplier;
        _game.mismatchPenalty = self.mismatchPenalty;
        _game.flipCost = self.flipCost;
        _game.gameName = self.identifier;
    }
    
    return _game;
}

// Calls createDeck, an abstract method that's overridden by subclass controllers, to get the right type of deck
- (Deck *)deck {
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

#pragma UICollectionViewDataSource protocol methods

#define CARD_SECTION_INDEX 0
#define MATCH_SECTION_INDEX 1

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == CARD_SECTION_INDEX) return [self.game cardsInPlayCount];
    else if (section == MATCH_SECTION_INDEX) return [self.game matchesCount];
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (indexPath.section == CARD_SECTION_INDEX) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell withCard:card];
    } else if (indexPath.section == MATCH_SECTION_INDEX) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self.identifier stringByAppendingString:@"Match"] forIndexPath:indexPath];
        // NSLog(@"Cell bounds = %@", NSStringFromCGRect(cell.bounds));
        NSArray *matchedCards = [self.game matchAtIndex:indexPath.item];
        [self updateCell:cell withMatchedCards:matchedCards];
    }
    return cell;
}

#pragma Abstract methods

- (void)updateCell:(UICollectionViewCell *)cell withCard:(Card *)card
{
    // abstract method
}

- (void)updateCell:(UICollectionViewCell *)cell withMatchedCards:(NSArray *)cards {
    // abstract method
}

- (Deck *)createDeck {
    return nil; // abstract method
}

- (void)removeMatchedCardsFromGame:(CardMatchingGame *)game {
    // abstract
}

+ (NSArray *)createCardSubviews:(NSArray *)cards {
    // abstract
    return nil;
}

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        if (indexPath.section == CARD_SECTION_INDEX) {
            Card *card = [self.game cardAtIndex:indexPath.item];
            [self updateCell:cell withCard:card];
        } else if (indexPath.section == MATCH_SECTION_INDEX) {
            NSArray *matchedCards = [self.game matchAtIndex:indexPath.item];
            [self updateCell:cell withMatchedCards:matchedCards];
        }
    }
    
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)sender {
    CGPoint tapPoint = [sender locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapPoint];
    
    // If the gesture was made on a cell in the collection view
    if (indexPath && indexPath.section == CARD_SECTION_INDEX) {
        // Flip a card
        [self.game flipCardAtIndex:indexPath.item];
        
        // Display the result in the flip result view (if one exists)
        if (self.game.result) {
            [self.flipResultView displayResultString:self.game.result
                                    withCardSubviews:[[self class] createCardSubviews:[self.game cardsFromResult]]
                                        displayRatio:self.cardSubviewDisplayRatio];
            self.flipResultView.alpha = 1;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:5];
            self.flipResultView.alpha = 0;
            [UIView commitAnimations];
        }
        
        // Remove matched (i.e. unplayable) cards. Must use NSMutableIndexSet and the array of IndexPaths to track cards to remove, since removing cells and cards must be an atomic operation (removing one-by-one would affect array indexing)
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        NSMutableIndexSet *mutableIndexSet = [[NSMutableIndexSet alloc] init];
        for (int i = 0; i < [self.cardCollectionView numberOfItemsInSection:0]; i++) {
            if ([[self.game cardAtIndex:i] isUnplayable]) {
                [mutableArray addObject:[NSIndexPath indexPathForItem:i inSection:CARD_SECTION_INDEX]];
                [mutableIndexSet addIndex:i];
            }
        }
        if ([mutableIndexSet count]) {
            // Update matched section of our collection view
            [self.cardCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self.game matchesCount]-1 inSection:MATCH_SECTION_INDEX]]];
            // Finally, remove the cards from the game and from the collection view. This has to be done after we insert the matched cards into the match section of the collection view, otherwise there's a discrepancy between what the data source returns for the card count vs. the cell count in the collection view.
            [self.game removeCardsAtIndexes:[mutableIndexSet copy]];
            [self.cardCollectionView deleteItemsAtIndexPaths:[mutableArray copy]];
        }

        [self updateUI];
    }
}

- (IBAction)deal {
    self.game = nil;
    self.deck = nil;
    self.addCardsButton.enabled = YES;
    self.addCardsButton.alpha = 1;
    [self.flipResultView displayResultString:@""];
    // This will force a resync to the model data and is needed to force the cardCollectionView to reload the correct number of cells, since they may have been added/deleted during the previous game
    [self.cardCollectionView reloadData];
    [self updateUI];
}

- (IBAction)addCards:(id)sender
{
    for (int i = 0; i < self.numberOfCardsToAdd; i++) {
        Card *card = [self.game drawCardFromDeck];
        if (card) {
            [self.cardCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self.game cardsInPlayCount]-1 inSection:CARD_SECTION_INDEX]]];
        }
    }
    
    if (![self.game hasDrawableCards]) {
        self.addCardsButton.enabled = NO;
        self.addCardsButton.alpha = .3;
    }
    
    [self.cardCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[self.game cardsInPlayCount]-1 inSection:CARD_SECTION_INDEX]
                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:YES];
}

@end
