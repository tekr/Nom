//
//  GameManager.m
//  Nom
//
//  Created on 11-07-27.
//  Copyright Thomas Zhang, Geoffry Song, Eddy Gao. All rights reserved.
//

#import "GameManager.h"

#import "Level.h"
#import "GameScene.h"
#import "MainMenuScene.h"
#import "OptionsScene.h"

#import "Constants.h"

#import "Transitions.h"
#import "SimpleAudioEngine.h"
#import "CocosDenshion.h"

@implementation GameManager
static GameManager *_sharedGameManager = nil;

@synthesize isSoundEffectsON;
@synthesize levels;

+(GameManager *) sharedGameManager
{
    @synchronized([GameManager class])
    {
        if(!_sharedGameManager)
        {
            _sharedGameManager = [[self alloc] init];
        }
        return _sharedGameManager;
    }
    
    return nil;
}

+(id) alloc
{
    return [super alloc];
}

-(id) init
{
    self = [super init];
    if (self != nil)
    {
        //Initialize/load settings
        settings = [NSMutableDictionary new];
        [self load];
        
        /*for very first launch
        bool defaultsSaved = [self getInt: @"defaultsSaved"];
        if (!defaultsSaved) 
        {
        }*/
        
        //Initialize GameManager
        isSoundEffectsON = YES;
        currentScene = kNoSceneUninitialized;
        
        //Load levels
        [self loadLevels];
    }
    
    return self;
}

-(void) cdAudioSourceDidFinishPlaying: (CDLongAudioSource *) audioSource
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic: @"loop.mp3"];
}

-(void) runSceneWithID: (SceneTypes) sceneID
{
    id sceneToRun = nil;
    
    switch (sceneID) 
    {
        case kMainMenuScene:
            if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
            sceneToRun = [MainMenuScene node];
            break;
        
        case kGameScene:
            if (self.isMusicON)
            {
                [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic: @"loop.mp3"];
                [[SimpleAudioEngine sharedEngine] playBackgroundMusic: @"intro.mp3" loop: NO];
                [CDAudioManager sharedManager].backgroundMusic.delegate = self;
            }
            sceneToRun = [GameScene node];
            break;
            
        case kOptionsScene:
            sceneToRun = [OptionsScene node];
            break;
            
        default:
            return;
            break;
    }
    
    SceneTypes oldScene = currentScene;
    currentScene = sceneID;

    if (oldScene == kNoSceneUninitialized)
    {
        [[CCDirector sharedDirector] runWithScene: sceneToRun];
        return;
    }
    
    sceneToRun = [currentScene < oldScene ?
                  [SlideUp class] :
                  [SlideDown class]
                  transitionWithDuration: 0.5 scene: sceneToRun];
    
    [[CCDirector sharedDirector] replaceScene: sceneToRun];
}

-(void) loadLevels
{
    levels = [NSMutableArray new];
    //level one: empty
    Level *emptyLevel = [Level level];
    [levels addObject: emptyLevel];
    
    //level two: box
    Level *boxLevel = [Level level];
    for (int i = 0; i < 30; i++)
    {
        for (int j = 0; j < 30; j++)
        {
            if(i == 0 || i == 29)
                [boxLevel setValue: i: j: LevelWall];
            
            if(j == 0 || j == 29)
                [boxLevel setValue: i: j: LevelWall];
        }
    }
    [levels addObject: boxLevel];
    
    //user levels
    NSArray *userLevels = [self getMutableArray: @"userLevels"];
    if (userLevels)
    {
        [levels addObjectsFromArray: userLevels];
    }
}

-(BOOL) isMusicON
{
    return [self getInt: @"isMusicON" withDefault: YES];
}

-(void) setIsMusicON: (BOOL) val
{
    [self setValue: @"isMusicOn" newInt: val];
}

-(Level *) level
{
    return [levels objectAtIndex: self.levelIndex];
}

-(int) levelIndex
{
    return [self getInt: @"levelIndex" withDefault: 0];
}

-(void) setLevelIndex: (int) levelIndex
{
    [self setValue: @"levelIndex" newInt: levelIndex];
}

-(NSString *) getString: (NSString *) value
{
	return [settings objectForKey:value];
}

-(NSString *) getString: (NSString *) value withDefault: (NSString *) def
{
	NSString *ret = [settings objectForKey:value];
    return ret ? ret : def;
}

-(int) getInt: (NSString *) value 
{
	return [[settings objectForKey:value] intValue];
}

-(int) getInt: (NSString *) value withDefault: (int) def
{
    id ret = [settings objectForKey: value];
    return ret ? [ret intValue] : def;
}

-(NSMutableArray *) getMutableArray: (NSString *) value
{
    return [settings objectForKey: value];
}

-(void) setValue: (NSString *) value newString: (NSString *) aValue
{
	[settings setObject: aValue forKey:value];
}

-(void) setValue: (NSString *) value newInt: (int) aValue
{
	[settings setObject:[NSNumber numberWithInt:aValue] forKey:value];
}

-(void) setValue: (NSString *) value newMutableArray: (NSMutableArray *) aValue
{
    [settings setObject: aValue forKey: value];
}

-(void) save
{
	[[NSUserDefaults standardUserDefaults] setObject:settings forKey:@"com.xamigo.nom"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) load
{
	[settings addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"com.xamigo.nom"]];
}

-(void) logSettings
{
    for(NSString* item in settings)
    {
		NSLog(@"[SettingsManager KEY:%@ - VALUE:%@]", item, [settings valueForKey:item]);
	}
}
@end
