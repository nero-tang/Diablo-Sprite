//
//  AD3Career.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "AD3Career.h"
#import "AD3Hero.h"
#import "AD3Kills.h"
#import "AD3TimePlayed.h"
#import "AD3Progression.h"
#import "AD3Artisan.h"
#import <AFNetworking.h>

@implementation AD3Career

+ (void)fetchCareerByBattleTag:(NSString *)battleTag inRegion:(AD3Region)region completionHandler:(AD3CompletionHandler)handler
{
    if ([self isBattleTagValid:battleTag]) {
        // If the tag is valid, replace # with - to match the query url requirement
        battleTag = [battleTag stringByReplacingOccurrencesOfString:@"#" withString:@"-"];
        
        // Fetch JSON from url request
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[self completeQueryRequest:battleTag region:region]];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseJSON = (NSDictionary *)responseObject;
                // Check if the BattleTag exist
                if (responseJSON[@"code"]) {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"The BattleTag doesn't exist"};
                    NSError *error = [NSError errorWithDomain:AD3ErrorDomain code:kAD3ErrorEmptyAccount userInfo:userInfo];
                    if (handler) {
                        handler(error, nil);
                    }
                } else {
                    if (handler) {
                        AD3Career *career = [[[self class] alloc] initWithJSON:responseJSON];
                        career.region = region;
                        handler(nil, career);
                    }
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (handler) {
                handler(error, nil);
            }
        }];
        [operation start];
    } else {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Invalid BattleTag."};
        NSError *error = [NSError errorWithDomain:AD3ErrorDomain code:kAD3ErrorInvalidBattleTag userInfo:userInfo];
        if (handler) {
            handler(error, nil);
        }
    }
}

- (instancetype)initWithJSON:(NSDictionary *)JSON
{
    self = [super init];
    if (self) {
        self.battleTag = JSON[@"battleTag"];
        self.paragonLevel = [JSON[@"paragonLevel"] integerValue];
        self.paragonLevelHardcore = [JSON[@"paragonLevelHardcore"] integerValue];
        self.paragonLevelSeason = [JSON[@"paragonLevelSeason"] integerValue];
        self.paragonLevelSeasonHardcore = [JSON[@"paragonLevelSeasonHardcore"] integerValue];
        
        NSString *lastHeroPlayedID = [JSON[@"lastHeroPlayed"] stringValue];
        __block NSMutableArray *mutHeroes = [[NSMutableArray alloc] init];
        NSArray *heroJSONs = JSON[@"heroes"];
        
        [heroJSONs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                AD3Hero *hero = [AD3Hero heroWithInfoJSON:obj];
                if (hero) {
                    hero.career = self;
                    [mutHeroes addObject:hero];
                    if ([hero.ID isEqualToString:lastHeroPlayedID]) {
                        self.lastHeroPlayed = hero;
                    }
                }
            }
        }];
        self.heroes = mutHeroes;
        
        NSString *lastUpdatedString = [JSON[@"lastUpdated"] stringValue];
        if (lastUpdatedString) {
            NSTimeInterval timeStamp = [lastUpdatedString doubleValue];
            self.lastUpdated = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        }
        
        self.kills = [AD3Kills killsWithJSON:JSON[@"kills"]];
        self.highestHardcoreLevel = [JSON[@"highestHardcoreLevel"] integerValue];
        self.timePlayed = [AD3TimePlayed timePlayedWithJSON:JSON[@"timePlayed"]];
        self.progression = [AD3Progression progressionWithJSON:JSON[@"progression"]];
        
        // Skip fallenHeroes for now
        self.fallenHeroes = nil;
        
        // Artisans
        self.blacksmith = [AD3Artisan artisanWithJSON:JSON[@"blackSmith"]];
        self.jeweler = [AD3Artisan artisanWithJSON:JSON[@"jeweler"]];
        self.mystic = [AD3Artisan artisanWithJSON:JSON[@"mystic"]];
        self.blacksmithHardcore = [AD3Artisan artisanWithJSON:JSON[@"blackSmithHardcore"]];
        self.jewelerHardcore = [AD3Artisan artisanWithJSON:JSON[@"jewelerHardcore"]];
        self.mysticHardcore = [AD3Artisan artisanWithJSON:JSON[@"mysticHardcore"]];
    }
    return self;
}

+ (NSURLRequest *)completeQueryRequest:(NSString *)battleTag region:(AD3Region)region
{
    NSURLRequest *queryRequest = nil;
    NSString *regionString = mapRegionToString(region);
    NSString *localeString = getCurrentLocaleIdentifier();
    if (regionString) {
        NSString *queryURLString = [NSString stringWithFormat:CAREER_PROFILE_URL, regionString, battleTag, localeString, API_KEY];
        NSURL *queryURL = [NSURL URLWithString:queryURLString];
        queryRequest = [NSURLRequest requestWithURL:queryURL];
    }
    return queryRequest;
}

+ (BOOL)isBattleTagValid:(NSString *)battleTag
{
    NSString *pattern = @"^[\\p{L}\\p{Mn}][\\p{L}\\p{Mn}0-9]{1,11}#[0-9]{4,5}$";
    NSError *error = nil;
    NSRegularExpression *matchRegex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return false;
    }
    
    if ([matchRegex numberOfMatchesInString:battleTag
                                    options:0
                                      range:NSMakeRange(0, [battleTag length])]) {
        return true;
    }
    return false;
}

- (NSURL *)getTooltipURL:(NSString *)tooltipParams
{
    NSString *regionString = mapRegionToString(self.region);
    NSString *langString = [getCurrentLocaleIdentifier() substringToIndex:2];
    NSString *urlString = [NSString stringWithFormat:TOOLTIP_URL, regionString, langString, tooltipParams];
    return [NSURL URLWithString:urlString];
}


@end
