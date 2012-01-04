//
//  HelpLayer.m
//  Nom
//
//  Created by Thomas Zhang on 11-08-23.
//  Copyright 2011 Cisco. All rights reserved.
//

#import "HelpLayer.h"
#import "MainMenuLayer.h"
#import "SpriteLoader.h"

@implementation HelpLayer
-(id) initWithColor:(ccColor4B)color
{
    self = [super init];
    if (self != nil)
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        
        CCSprite *help = loadSprite(@"HelpLayer.png");
        [help setPosition: ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild: help];
    }
    
    return self;
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self goAway];
}

-(void) goAway
{
    [self runAction:
     [CCSequence actions:
      [CCFadeOut actionWithDuration: 0.5],
      [CCCallFunc actionWithTarget: self selector: @selector(finishGoingAway)],
      nil]
     ];
}

-(void) finishGoingAway
{
    MainMenuLayer *mml = (MainMenuLayer *) [self.parent getChildByTag: kMainMenuLayer];
    [self.parent removeChild: self cleanup: YES];
    [mml onEnter];
}
@end
