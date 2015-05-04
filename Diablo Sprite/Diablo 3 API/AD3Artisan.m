//
//  AD3Artisan.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "AD3Artisan.h"

@implementation AD3Artisan

- (instancetype)initWithJSON:(NSDictionary *)JSON
{
    self = [super init];
    if (self) {
        self.slug = JSON[@"slug"];
        self.level = [JSON[@"level"] integerValue];
        self.stepCurrent = [JSON[@"stepCurrent"] integerValue];
        self.stepMax = [JSON[@"stepMax"] integerValue];
    }
    return self;
}

+ (AD3Artisan *)artisanWithJSON:(NSDictionary *)JSON
{
    if (![JSON isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [[[self class] alloc] initWithJSON:JSON];
}

@end
