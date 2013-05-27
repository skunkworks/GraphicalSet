//
//  GameSettings.h
//  GraphicalSet
//
//  Created by Richard Shin on 5/26/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSettings : NSObject

@property (nonatomic) NSUInteger playingCardStartCount;

+ (GameSettings *)settings;

@end
