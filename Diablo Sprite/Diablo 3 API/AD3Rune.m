//
//  AD3Rune.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "AD3Rune.h"

@implementation AD3Rune

+ (AD3Rune *)runeWithJSON:(NSDictionary *)JSON
{
    if (![JSON isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    AD3Rune *rune = [[AD3Rune alloc] init];
    if (rune) {
        rune.slug = JSON[@"slug"];
        rune.type = JSON[@"type"];
        rune.name = JSON[@"name"];
        rune.level = [JSON[@"level"] integerValue];
        rune.simpleDesc = JSON[@"simpleDescription"];
        rune.desc = JSON[@"description;"];
        rune.tooltipParams = JSON[@"tooltipParams"];
        rune.skillCalcId = JSON[@"skillCalcId"];
        rune.order = [JSON[@"order"] integerValue];
    }
    return rune;
}

@end
