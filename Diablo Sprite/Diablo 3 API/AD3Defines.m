//
//  AD3Defines.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-13.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "AD3Defines.h"

NSString *mapRegionToString(AD3Region region)
{
    static NSArray *regionStrings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regionStrings = @[@"us",
                          @"eu",
                          @"tw",
                          @"kr"];
    });
    return [regionStrings objectAtIndex:region];
}

NSString *getCurrentLocaleIdentifier()
{
    return [[NSLocale currentLocale] localeIdentifier];
}
