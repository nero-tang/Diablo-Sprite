//
//  AD3Progression.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "AD3Progression.h"

@implementation AD3Progression

- (instancetype)initWithJSON:(NSDictionary *)JSON
{
    self = [super init];
    if (self) {
        self.act1 = [JSON[@"act1"] boolValue];
        self.act2 = [JSON[@"act2"] boolValue];
        self.act3 = [JSON[@"act3"] boolValue];
        self.act4 = [JSON[@"act4"] boolValue];
    }
    return self;
}

+ (AD3Progression *)progressionWithJSON:(NSDictionary *)JSON
{
    if (![JSON isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[[self class] alloc] initWithJSON:JSON];
}

@end
