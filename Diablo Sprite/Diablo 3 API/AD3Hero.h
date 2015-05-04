//
//  AD3Hero.h
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

@class AD3Career;
@class AD3Item;
@class AD3Stats;

typedef NS_ENUM(NSUInteger, AD3HeroClass) {
    kAD3HeroBarbarian = 0,
};

typedef NS_ENUM(NSUInteger, AD3HeroGender) {
    kAD3HeroMale = 0,
    kAD3HeroFemale = 1
};

#import "AD3Defines.h"

@interface AD3Hero : NSObject

@property (nonatomic, weak) AD3Career *career;
@property (nonatomic, getter=isFullyLoaded) BOOL fullyLoaded;

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSString *className;
@property (nonatomic) AD3HeroGender gender;
@property (nonatomic) NSUInteger level;
@property (nonatomic) NSUInteger paragonLevel;
@property (nonatomic, getter=isHardcore) BOOL hardcore;
@property (nonatomic, getter=isSeasonal) BOOL seasonal;
@property (nonatomic) NSUInteger seasonCreated;

// Skills
@property (nonatomic, strong) NSArray *activeSkills;
@property (nonatomic, strong) NSArray *passiveSkills;

// Items
@property (nonatomic, strong) AD3Item *head;
@property (nonatomic, strong) AD3Item *torso;
@property (nonatomic, strong) AD3Item *feet;
@property (nonatomic, strong) AD3Item *hands;
@property (nonatomic, strong) AD3Item *shoulders;
@property (nonatomic, strong) AD3Item *legs;
@property (nonatomic, strong) AD3Item *bracers;
@property (nonatomic, strong) AD3Item *mainHand;
@property (nonatomic, strong) AD3Item *offHand;
@property (nonatomic, strong) AD3Item *waist;
@property (nonatomic, strong) AD3Item *rightFinger;
@property (nonatomic, strong) AD3Item *leftFinger;
@property (nonatomic, strong) AD3Item *neck;

// Stats
@property (nonatomic, strong) AD3Stats *stats;

@property (nonatomic) NSUInteger eliteKills;
@property (nonatomic, getter=isDead) BOOL dead;
@property (nonatomic, strong) NSDate *lastUpdated;

// Complete loading
+ (AD3Hero *)heroWithInfoJSON:(NSDictionary *)infoJSON;

- (void)completeLoadingWithCompletionHandler:(AD3CompletionHandler)handler;

@end
