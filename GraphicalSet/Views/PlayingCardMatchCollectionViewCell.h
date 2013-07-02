//
//  PlayingCardMatchCollectionViewCell.h
//  GraphicalSet
//
//  Created by Richard Shin on 5/27/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardMatchCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutletCollection(PlayingCardView) NSArray *playingCardViews;
@end
