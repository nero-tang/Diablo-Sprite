//
//  AD3Career.h
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

@class AD3Hero;
@class AD3Kills;
@class AD3TimePlayed;
@class AD3Progression;
@class AD3Artisan;

#import "AD3Defines.h"

@interface AD3Career : NSObject

@property (nonatomic, strong) NSString *battleTag;
@property (nonatomic) AD3Region region;

@property (nonatomic) NSUInteger paragonLevel;
@property (nonatomic) NSUInteger paragonLevelHardcore;
@property (nonatomic) NSUInteger paragonLevelSeason;
@property (nonatomic) NSUInteger paragonLevelSeasonHardcore;

@property (nonatomic, strong) NSArray *heroes;
@property (nonatomic, strong) AD3Hero *lastHeroPlayed;
@property (nonatomic, strong) NSDate *lastUpdated;

@property (nonatomic, strong) AD3Kills *kills;
@property (nonatomic) NSUInteger highestHardcoreLevel;

@property (nonatomic, strong) AD3TimePlayed *timePlayed;
@property (nonatomic, strong) AD3Progression *progression;
@property (nonatomic, strong) NSArray *fallenHeroes;
@property (nonatomic, strong) AD3Artisan *blacksmith;
@property (nonatomic, strong) AD3Artisan *jeweler;
@property (nonatomic, strong) AD3Artisan *mystic;
@property (nonatomic, strong) AD3Artisan *blacksmithHardcore;
@property (nonatomic, strong) AD3Artisan *jewelerHardcore;
@property (nonatomic, strong) AD3Artisan *mysticHardcore;

+ (void)fetchCareerByBattleTag:(NSString *)battleTag
                      inRegion:(AD3Region)region
             completionHandler:(AD3CompletionHandler)handler;

- (NSURL *)getTooltipURL:(NSString *)tooltipParams;

@end
