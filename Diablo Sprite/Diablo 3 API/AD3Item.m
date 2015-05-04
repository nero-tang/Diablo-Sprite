//
//  AD3Item.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "AD3Item.h"


@implementation AD3Item

- (instancetype)initWithJSON:(NSDictionary *)JSON
{
    self = [super init];
    if (self) {
        self.ID = JSON[@"id"];
        self.name = JSON[@"name"];
        self.icon = JSON[@"icon"];
        self.displayColor = JSON[@"displayColor"];
        self.tooltipParams = JSON[@"tooltipParams"];
    }
    return self;
}

+ (AD3Item *)itemWithJSON:(NSDictionary *)JSON
{
    if (![JSON isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[[self class] alloc] initWithJSON:JSON];
}

- (NSURL *)iconURL
{
    NSString *urlString = [NSString stringWithFormat:ITEM_ICON_URL, self.icon];
    return [NSURL URLWithString:urlString];
}

@end
