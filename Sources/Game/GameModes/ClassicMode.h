//
//  ClassicMode.h
//  Nom
//
//  Created on 11-08-20.
//  Copyright Thomas Zhang, Geoffry Song, Eddy Gao. All rights reserved.
//

#import "Game.h"

@interface ClassicMode: Game {
}

-(id) init;

-(void) onEat: (Food *) food;

@end
