//
//  AD3TimePlayed.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "AD3TimePlayed.h"

@implementation AD3TimePlayed

- (instancetype)initWithJSON:(NSDictionary *)JSON
{
    self = [super init];
    if (self) {
        self.barbarian = [JSON[@"barbarian"] doubleValue];
        self.crusader = [JSON[@"crusader"] doubleValue];
        self.demonHunter = [JSON[@"demon-hunter"] doubleValue];
        self.monk = [JSON[@"monk"] doubleValue];
        self.witchDoctor = [JSON[@"witch-doctor"] doubleValue];
        self.wizard = [JSON[@"wizard"] doubleValue];
    }
    return self;
}

+ (AD3TimePlayed *)timePlayedWithJSON:(NSDictionary *)JSON
{
    if (![JSON isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[[self class] alloc] initWithJSON:JSON];
}

@end
