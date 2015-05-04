//
//  AD3TimePlayed.h
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AD3TimePlayed : NSObject

@property (nonatomic) double barbarian;
@property (nonatomic) double crusader;
@property (nonatomic) double demonHunter;
@property (nonatomic) double monk;
@property (nonatomic) double witchDoctor;
@property (nonatomic) double wizard;

+ (AD3TimePlayed *)timePlayedWithJSON:(NSDictionary *)JSON;

@end
