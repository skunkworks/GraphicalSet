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

- (int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.game.cardsInPlayCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell withCard:card];
    return cell;
}

#pragma Abstract methods

- (void)updateCell:(UICollectionViewCell *)cell withCard:(Card *)card
{
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
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell withCard:card];
    }
    
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)sender {
    CGPoint tapPoint = [sender locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapPoint];
    
    // If the gesture was made on a cell in the collection view
    if (indexPath) {
        // Flip a card
        [self.game flipCardAtIndex:indexPath.item];
        // Display the result in the flip result view
        [self.flipResultView displayResultString:self.game.result withCardSubviews:[[self class] createCardSubviews:[self.game cardsFromResult]]];
        
        // Remove matched (i.e. unplayable) cards. Must use NSMutableIndexSet and the array of IndexPaths to track cards to remove, since removing cells and cards must be an atomic operation (removing one-by-one would affect array indexing)
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        NSMutableIndexSet *mutableIndexSet = [[NSMutableIndexSet alloc] init];
        NSLog(@"***BEFORE*** Cells: %d  Cards: %d", [self.cardCollectionView numberOfItemsInSection:0], self.game.cardsInPlayCount);
        for (int i = 0; i < [self.cardCollectionView numberOfItemsInSection:0]; i++) {
            if ([[self.game cardAtIndex:i] isUnplayable]) {
                [mutableArray addObject:[NSIndexPath indexPathForItem:i inSection:0]];
                [mutableIndexSet addIndex:i];
            }
        }
        [self.game removeCardsAtIndexPaths:[mutableIndexSet copy]];
        [self.cardCollectionView deleteItemsAtIndexPaths:[mutableArray copy]];
        
        if ([mutableArray count] == 2) NSLog(@"Deleting index paths: %@, %@", [mutableArray objectAtIndex:0], [mutableArray objectAtIndex:1]);
        NSLog(@"***AFTER*** Cells: %d  Cards: %d", [self.cardCollectionView numberOfItemsInSection:0], self.game.cardsInPlayCount);
        [self updateUI];
    }
}

- (IBAction)deal {
    self.game = nil;
    self.deck = nil;
    self.addCardsButton.enabled = YES;
    self.addCardsButton.alpha = 1;
    [self.flipResultView displayResultString:@""];
    // This will force a resync to the model data, which will remove the extra cells from adding cards during gameplay
    [self.cardCollectionView reloadData];
    [self updateUI];
}

- (IBAction)addCards:(id)sender
{
    for (int i = 0; i < self.numberOfCardsToAdd; i++) {
        Card *card = [self.game drawCardFromDeck];
        if (card) {
            [self.cardCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self.game cardsInPlayCount]-1 inSection:0]]];
        }
    }
    
    if (![self.game hasDrawableCards]) {
        self.addCardsButton.enabled = NO;
        self.addCardsButton.alpha = .3;
    }
    
    [self.cardCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[self.game cardsInPlayCount]-1 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:YES];
}


@end
