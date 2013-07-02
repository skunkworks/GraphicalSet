//
//  PlayingCardMatchCollectionViewCell.m
//  GraphicalSet
//
//  Created by Richard Shin on 5/27/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "PlayingCardMatchCollectionViewCell.h"

@implementation PlayingCardMatchCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.matchString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12] }];
    CGRect textBounds;
    textBounds.origin = CGPointMake(0, 0);
    textBounds.size = [string size];
    [string drawInRect:textBounds];

}


@end
