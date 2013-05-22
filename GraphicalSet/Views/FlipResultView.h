//
//  FlipResultView.h
//  GraphicalSet
//
//  Created by Richard Shin on 5/20/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FlipResultView : UIView
- (void)displayResultString:(NSString *)result;
- (void)displayResultString:(NSString *)result
           withCardSubviews:(NSArray *)cardSubviews;
@end
