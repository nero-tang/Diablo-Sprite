//
//  AD3Skill.h
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

@class AD3Rune;

#import <Foundation/Foundation.h>

/**
  Base skill class
 */
@interface AD3Skill : NSObject

@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic) NSUInteger level;
@property (nonatomic, strong) NSString *tooltipUrl;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *skillCalcId;

- (NSURL *)iconURL;
- (NSString *)getTooltipParams;

@end

/**
  Active skill class
 */
@interface AD3ActiveSkill : AD3Skill

@property (nonatomic, strong) NSString *categorySlug;
@property (nonatomic, strong) NSString *simpleDesc;
@property (nonatomic, strong) AD3Rune *rune;

+ (AD3ActiveSkill *)activeSkillWithJSON:(NSDictionary *)JSON;

@end

/**
  Passive skill class
  */
@interface AD3PassiveSkill : AD3Skill

@property (nonatomic, strong) NSString *flavor;

+ (AD3PassiveSkill *)passiveSkillWithJSON:(NSDictionary *)JSON;

@end