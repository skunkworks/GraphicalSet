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
    [string drawInRect:self.bounds];
    NSLog(@"self.bounds: %f, %f", self.bounds.size.width, self.bounds.size.height);
}


@end
