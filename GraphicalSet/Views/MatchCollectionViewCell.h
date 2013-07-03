//
//  MatchCollectionViewCell.h
//  GraphicalSet
//
//  Created by Richard Shin on 7/2/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchCollectionViewCell : UICollectionViewCell
@property (nonatomic) NSNumber *score;
- (void)setCardView:(UIView *)cardView atPosition:(NSUInteger)position;
@end
