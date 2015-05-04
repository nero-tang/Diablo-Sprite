//
//  AD3Stats.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "AD3Stats.h"

@implementation AD3Stats

- (instancetype)initWithJSON:(NSDictionary *)JSON
{
    self = [super init];
    if (self) {
        self.life = [JSON[@"life"] integerValue];
        self.damage = [JSON[@"damage"] doubleValue];
        self.attackSpeed = [JSON[@"attackSpeed"] doubleValue];
        self.armor = [JSON[@"armor"] integerValue];
        self.strength = [JSON[@"strength"] integerValue];
        self.dexterity = [JSON[@"dexterity"] integerValue];
        self.vitality = [JSON[@"vitality"] integerValue];
        self.intelligence = [JSON[@"intelligence"] integerValue];
        self.physicalResist = [JSON[@"physicalResist"] integerValue];
        self.fireResist = [JSON[@"fireResist"] integerValue];
        self.coldResist = [JSON[@"coldResist"] integerValue];
        self.lightningResist = [JSON[@"lightningResist"] integerValue];
        self.poisonResist = [JSON[@"poisonResist"] integerValue];
        self.arcaneResist = [JSON[@"arcaneResist"] integerValue];
        self.critDamage = [JSON[@"critDamage"] doubleValue];
        self.blockChance = [JSON[@"blockChance"] doubleValue];
        self.blockAmountMin = [JSON[@"blockAmountMin"] integerValue];
        self.blockAmountMax = [JSON[@"blockAmountMax"] integerValue];
        self.damageIncrease = [JSON[@"damageIncrease"] integerValue];
        self.critChance = [JSON[@"critChance"] doubleValue];
        self.damageReduction = [JSON[@"damageReduction"] doubleValue];
        self.thorns = [JSON[@"thorns"] doubleValue];
        self.lifeSteal = [JSON[@"lifeSteal"] doubleValue];
        self.lifePerKill = [JSON[@"lifePerKill"] doubleValue];
        self.magicFind = [JSON[@"magicFind"] doubleValue];
        self.goldFind = [JSON[@"goldFind"] doubleValue];
        self.primaryResource = [JSON[@"primaryResource"] integerValue];
        self.secondaryResource = [JSON[@"secondaryResource"] integerValue];
    }
    return self;
}

+ (AD3Stats *)statsWithJSON:(NSDictionary *)JSON
{
    if (![JSON isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[[self class] alloc] initWithJSON:JSON];
}

@end
