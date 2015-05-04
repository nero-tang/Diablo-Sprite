//
//  AD3Hero.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "AD3Hero.h"
#import "AD3Skill.h"
#import "AD3Item.h"
#import "AD3Stats.h"
#import "AD3Career.h"
#import <AFNetworking.h>

@implementation AD3Hero

- (instancetype)initWithInfoJSON:(NSDictionary *)infoJSON
{
    self = [super init];
    if (self) {
        self.paragonLevel = [infoJSON[@"paragonLevel"] integerValue];
        self.seasonal = [infoJSON[@"seasonal"] boolValue];
        self.name = infoJSON[@"name"];
        self.ID = [infoJSON[@"id"] stringValue];
        self.level = [infoJSON[@"level"] integerValue];
        self.hardcore = [infoJSON[@"hardcore"] boolValue];
        self.gender = (AD3HeroGender)[infoJSON[@"gender"] integerValue];
        self.dead = [infoJSON[@"dead"] boolValue];
        self.className = infoJSON[@"class"];
        
        NSString *lastUpdatedString = [infoJSON[@"last-updated"] stringValue];
        if (lastUpdatedString) {
            NSTimeInterval timeStamp = [lastUpdatedString doubleValue];
            self.lastUpdated = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        }
        self.fullyLoaded = NO;
    }
    return self;
}


+ (AD3Hero *)heroWithInfoJSON:(NSDictionary *)infoJSON
{
    if (![infoJSON isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [[[self class] alloc] initWithInfoJSON:infoJSON];
}

- (void)parseCompleteJSON:(NSDictionary *)completeJSON
{
    self.seasonCreated = [completeJSON[@"seasonCreated"] integerValue];
    
    __block NSMutableArray *mutActiveSkills = [[NSMutableArray alloc] init];
    __block NSMutableArray *mutPassiveSkills = [[NSMutableArray alloc] init];
    
    // Retrieve skills json
    NSDictionary *skills = completeJSON[@"skills"];
    if ([skills isKindOfClass:[NSDictionary class]]) {
        NSArray *activeSkills = skills[@"active"];
        [activeSkills enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AD3ActiveSkill *activeSkill = [AD3ActiveSkill activeSkillWithJSON:obj];
            [mutActiveSkills addObject:activeSkill];
        }];
        
        NSArray *passiveSkills = skills[@"passive"];
        [passiveSkills enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AD3PassiveSkill *passiveSkill = [AD3PassiveSkill passiveSkillWithJSON:obj];
            [mutPassiveSkills addObject:passiveSkill];
        }];
    }
    self.activeSkills = mutActiveSkills;
    self.passiveSkills = mutPassiveSkills;
    
    NSDictionary *items = completeJSON[@"items"];
    if ([items isKindOfClass:[NSDictionary class]]) {
        self.head = [AD3Item itemWithJSON:items[@"head"]];
        self.torso = [AD3Item itemWithJSON:items[@"torso"]];
        self.feet = [AD3Item itemWithJSON:items[@"feet"]];
        self.hands = [AD3Item itemWithJSON:items[@"hands"]];
        self.shoulders = [AD3Item itemWithJSON:items[@"shoulders"]];
        self.legs = [AD3Item itemWithJSON:items[@"legs"]];
        self.bracers = [AD3Item itemWithJSON:items[@"bracers"]];
        self.mainHand = [AD3Item itemWithJSON:items[@"mainHand"]];
        self.offHand = [AD3Item itemWithJSON:items[@"offHand"]];
        self.waist = [AD3Item itemWithJSON:items[@"waist"]];
        self.rightFinger = [AD3Item itemWithJSON:items[@"rightFinger"]];
        self.leftFinger = [AD3Item itemWithJSON:items[@"leftFinger"]];
        self.neck = [AD3Item itemWithJSON:items[@"neck"]];
    }
    
    self.stats = [AD3Stats statsWithJSON:completeJSON[@"stats"]];
    self.eliteKills = [completeJSON[@"kills"][@"elites"] integerValue];
    self.fullyLoaded = YES;
    
}

- (void)completeLoadingWithCompletionHandler:(AD3CompletionHandler)handler
{
    if (self.isFullyLoaded) {
        if (handler) {
            handler(nil, self);
        }
    } else {
        // Fetch complete Hero Profile (JSON)
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[self completeQueryRequest]];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [self parseCompleteJSON:responseObject];
                if (handler) {
                    handler(nil, self);
                }
            } else {
                if (handler) {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Response object is not JSON."};
                    NSError *error = [NSError errorWithDomain:AD3ErrorDomain code:kAD3ErrorFalseFormat userInfo:userInfo];
                    handler(error, nil);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (handler) {
                handler(error, nil);
            }
        }];
        [operation start];
    }
}

- (NSURLRequest *)completeQueryRequest
{
    NSURLRequest *queryRequest = nil;
    NSString *regionString = mapRegionToString(self.career.region);
    NSString *localeString = getCurrentLocaleIdentifier();
    NSString *battleTag = [self.career.battleTag stringByReplacingOccurrencesOfString:@"#" withString:@"-"];
    if (regionString) {
        NSString *queryURLString = [NSString stringWithFormat:HERO_PROFILE_URL, regionString, battleTag, self.ID, localeString, API_KEY];
        NSURL *queryURL = [NSURL URLWithString:queryURLString];
        queryRequest = [NSURLRequest requestWithURL:queryURL];
    }
    return queryRequest;
}









@end
