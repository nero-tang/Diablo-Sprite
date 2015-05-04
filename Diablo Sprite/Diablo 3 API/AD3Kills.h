//
//  AD3Kills.h
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AD3Kills : NSObject
@property (nonatomic) NSUInteger monsters;
@property (nonatomic) NSUInteger elites;
@property (nonatomic) NSUInteger hardcoreMosnters;

+ (AD3Kills *)killsWithJSON:(NSDictionary *)JSON;

@end
