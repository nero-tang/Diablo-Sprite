//
//  AD3Skill.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "AD3Skill.h"
#import "AD3Rune.h"

/**
  Base skill class implementation
 */
@implementation AD3Skill

- (instancetype)initWithJSON:(NSDictionary *)JSON
{
    self = [super init];
    if (self) {
        self.slug = JSON[@"slug"];
        self.name = JSON[@"name"];
        self.icon = JSON[@"icon"];
        self.level = [JSON[@"level"] integerValue];
        self.tooltipUrl = JSON[@"tooltipUrl"];
        self.desc = JSON[@"description"];
        self.skillCalcId = JSON[@"skillCalcId"];
    }
    return self;
}

- (NSURL *)iconURL
{
    NSString *urlString = [NSString stringWithFormat:SKILL_ICON_URL, self.icon];
    return [NSURL URLWithString:urlString];
}

- (NSString *)getTooltipParams
{
    return self.tooltipUrl;
}

@end


/**
  Active class implementation
  */
@implementation AD3ActiveSkill

- (instancetype)initWithJSON:(NSDictionary *)JSON
{
    NSDictionary *skillJSON = JSON[@"skill"];
    NSDictionary *runeJSON = JSON[@"rune"];
    self = [super initWithJSON:skillJSON];
    if (self) {
        self.categorySlug = skillJSON[@"categorySlug"];
        self.simpleDesc = skillJSON[@"simpleDescription"];
        self.rune = [AD3Rune runeWithJSON:runeJSON];
    }
    return self;
}

+ (AD3ActiveSkill *)activeSkillWithJSON:(NSDictionary *)JSON
{
    if (![JSON isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[[self class] alloc] initWithJSON:JSON];
}

- (NSString *)getTooltipParams
{
    NSString *tooltipParams = [super getTooltipParams];
    if (self.rune) {
        NSString *runeType = [NSString stringWithFormat:@"?runeType=%@", self.rune.type];
        tooltipParams = [tooltipParams stringByAppendingString:runeType];
    }
    return tooltipParams;
}

@end

/**
  Passive skill class implementation
  */
@implementation AD3PassiveSkill

- (instancetype)initWithJSON:(NSDictionary *)JSON
{
    NSDictionary *skillJSON = JSON[@"skill"];
    self = [super initWithJSON:skillJSON];
    if (self) {
        self.flavor = skillJSON[@"flavor"];
    }
    return self;
}

+ (AD3PassiveSkill *)passiveSkillWithJSON:(NSDictionary *)JSON
{
    if (![JSON isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [[[self class] alloc] initWithJSON:JSON];
}

@end


