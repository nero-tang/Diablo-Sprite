//
//  AD3Kills.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "AD3Kills.h"

@implementation AD3Kills

- (instancetype)initWithJSON:(NSDictionary *)JSON
{
    self = [super init];
    if (self) {
        self.monsters = [JSON[@"monsters"] integerValue];
        self.elites = [JSON[@"elites"] integerValue];
        self.hardcoreMosnters = [JSON[@"hardcoreMonsters"] integerValue];
    }
    return self;
}

+ (AD3Kills *)killsWithJSON:(NSDictionary *)JSON
{
    if (![JSON isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[[self class] alloc] initWithJSON:JSON];
}

@end
