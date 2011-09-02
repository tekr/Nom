//
//  Food.m
//  Nom
//
//  Created on 11-08-15.
//  Copyright Thomas Zhang, Geoffry Song, Eddy Gao. All rights reserved.
//

#import "Food.h"

@implementation Food

@synthesize pos;

-(id) initWithGame: (Game *) game
{
    return [self init];
}

-(void) dealloc
{
    [pos release];
    [super dealloc];
}

-(BOOL) eat: (Game *) game
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

-(ccColor3B) color
{
    [self doesNotRecognizeSelector: _cmd];
    return ccc3(0, 0, 0);
}

@end
