//
//  AD3Defines.h
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-12.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#ifndef D3_Buddy_AD3Defines_h
#define D3_Buddy_AD3Defines_h

#import <Foundation/Foundation.h>

// Call back completion handler
typedef void (^AD3CompletionHandler)(NSError *error, id responseObject);

// Valid key for Diablo 3 community API
#define API_KEY @"API KEY"

// AD3 Errors
#define AD3ErrorDomain @"com.archangel.app.D3-Buddy"

typedef NS_ENUM(NSInteger, AD3ErrorCode) {
    kAD3ErrorInvalidBattleTag = -666,
    kAD3ErrorEmptyAccount,
    kAD3ErrorFalseFormat
};


// Formatted URLs
#define CAREER_PROFILE_URL @"https://%@.api.battle.net/d3/profile/%@/?locale=%@&apikey=%@"
#define HERO_PROFILE_URL @"https://%@.api.battle.net/d3/profile/%@/hero/%@?locale=%@&apikey=%@"
#define SKILL_ICON_URL @"http://media.blizzard.com/d3/icons/skills/64/%@.png"
#define ITEM_ICON_URL @"http://media.blizzard.com/d3/icons/items/large/%@.png"
#define TOOLTIP_URL @"http://%@.battle.net/d3/%@/tooltip/%@"

// Region enumeration
typedef NS_ENUM(NSUInteger, AD3Region) {
    kAD3RegionUS = 0,
    kAD3RegionEU = 1,
    kAD3RegionTW = 2,
    kAD3RegionKR = 3
};

extern NSString *mapRegionToString(AD3Region region);
extern NSString *getCurrentLocaleIdentifier();

#endif
