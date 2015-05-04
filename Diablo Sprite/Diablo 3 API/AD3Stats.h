//
//  AD3Stats.h
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AD3Stats : NSObject

// Basic stats
@property (nonatomic) NSUInteger strength;
@property (nonatomic) NSUInteger dexterity;
@property (nonatomic) NSUInteger vitality;
@property (nonatomic) NSUInteger intelligence;

// Offensive stats
@property (nonatomic) double damage;
@property (nonatomic) double attackSpeed;
@property (nonatomic) double critDamage;
@property (nonatomic) double damageIncrease;
@property (nonatomic) double critChance;


// Defensive stats
@property (nonatomic) NSUInteger armor;
@property (nonatomic) NSUInteger physicalResist;
@property (nonatomic) NSUInteger fireResist;
@property (nonatomic) NSUInteger coldResist;
@property (nonatomic) NSUInteger lightningResist;
@property (nonatomic) NSUInteger poisonResist;
@property (nonatomic) NSUInteger arcaneResist;
@property (nonatomic) double blockChance;
@property (nonatomic) double blockAmountMin;
@property (nonatomic) double blockAmountMax;
@property (nonatomic) double damageReduction;
@property (nonatomic) double thorns;

// Life stats
@property (nonatomic) NSUInteger life;
@property (nonatomic) double lifeSteal;
@property (nonatomic) double lifeOnHit;
@property (nonatomic) double lifePerKill;

// Resource stats
@property (nonatomic) NSUInteger primaryResource;
@property (nonatomic) NSUInteger secondaryResource;

// Adventure stats
@property (nonatomic) double goldFind;
@property (nonatomic) double magicFind;


+ (AD3Stats *)statsWithJSON:(NSDictionary *)JSON;

@end
