//
//  ShieldFood.m
//  Nom
//
//  Created on 11-08-22.
//  Copyright Thomas Zhang, Geoffry Song, Eddy Gao. All rights reserved.
//

#import "ShieldFood.h"

#import "Game.h"
#import "FoodRandomizer.h"

@implementation ShieldFood

+(void) load
{
    [FoodRandomizer addFood: [self class] weight: 1];
}

-(BOOL) eat: (Game *) game
{
    // adds a new snake piece to the end of the snake
    game.isProtected = true;
    return YES;
}

-(ccColor3B) color
{
    return ccYELLOW;
}

@end
