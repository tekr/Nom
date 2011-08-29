//
//  OptionsBackgroundLayer.m
//  Nom
//
//  Created by Thomas Zhang on 11-08-24.
//  Copyright 2011 Cisco. All rights reserved.
//

#import "OptionsBackgroundLayer.h"
#import "GameManager.h"

@implementation OptionsBackgroundLayer
-(id) init
{
    self = [super init];
    if (self != nil)
    {
        self.isTouchEnabled = YES;
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];

        CCSprite *bg;
        bg = [CCSprite spriteWithFile: @"OptionsBackground.png"];
        [bg setPosition: CGPointMake (screenSize.width/2, screenSize.height/2)];
        [self addChild: bg];
        
        slowButton = [CCMenuItemImage 
                                       itemFromNormalImage: @"OptionHard.png" 
                                       selectedImage: @"OptionHard-selected.png" 
                                       disabledImage: @"OptionHard-selected.png"  
                                       target: self 
                                       selector: @selector(setSlow)];
        [slowButton setPosition: ccp(66, 118)];
        mediumButton = [CCMenuItemImage 
                                       itemFromNormalImage: @"OptionHarder.png" 
                                       selectedImage: @"OptionHarder-selected.png" 
                                       disabledImage: @"OptionHarder-selected.png"
                                       target: self 
                                       selector: @selector(setMedium)];
        [mediumButton setPosition: ccp(160, 118)];
        fastButton = [CCMenuItemImage 
                                       itemFromNormalImage: @"OptionCrazy.png" 
                                       selectedImage: @"OptionCrazy-selected.png" 
                                       disabledImage: @"OptionCrazy-selected.png"
                                       target: self 
                                       selector: @selector(setFast)];
        [fastButton setPosition: ccp(254, 118)];
        
        CCMenuItemImage *playButton = [CCMenuItemImage 
                                       itemFromNormalImage: @"OptionPlayGame.png" 
                                       selectedImage: @"OptionPlayGame-selected.png" 
                                       disabledImage: @"OptionPlayGame.png"  
                                       target: self 
                                       selector: @selector(playGame)];
        [playButton setPosition: ccp(160, 55)];
        
        optionsMenu = [CCMenu menuWithItems: slowButton,
                       mediumButton, fastButton, playButton, nil];
        [optionsMenu setPosition: CGPointZero];
        [self addChild: optionsMenu];
        
        int speed = [[GameManager sharedGameManager] getInt: @"speed" withDefault: 350];
        if (speed == 150)
            [self setFast];
        else if (speed == 250)
            [self setMedium];
        else
            [self setSlow];
    }
    
    return self;
}

-(void) setSlow
{
    [slowButton setIsEnabled: NO];
    [mediumButton setIsEnabled: YES];
    [fastButton setIsEnabled: YES];
    [[GameManager sharedGameManager] setValue: @"speed" newInt: 350];
}
-(void) setMedium
{
    [slowButton setIsEnabled: YES];
    [mediumButton setIsEnabled: NO];
    [fastButton setIsEnabled: YES];
    [[GameManager sharedGameManager] setValue: @"speed" newInt: 250];
}
-(void) setFast
{
    [slowButton setIsEnabled: YES];
    [mediumButton setIsEnabled: YES];
    [fastButton setIsEnabled: NO];
    [[GameManager sharedGameManager] setValue: @"speed" newInt: 150];
}

-(void) playGame
{
    [[GameManager sharedGameManager] runSceneWithID: kGameScene];
}
@end
