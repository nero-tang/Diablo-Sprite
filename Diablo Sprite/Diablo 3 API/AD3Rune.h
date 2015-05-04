//
//  AD3Rune.h
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AD3Rune : NSObject

@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSUInteger level;
@property (nonatomic, strong) NSString *simpleDesc;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *tooltipParams;
@property (nonatomic, strong) NSString *skillCalcId;
@property (nonatomic) NSUInteger order;

+ (AD3Rune* )runeWithJSON:(NSDictionary *)rune;

@end
