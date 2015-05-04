//
//  AD3Progression.h
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AD3Progression : NSObject

@property (nonatomic) BOOL act1;
@property (nonatomic) BOOL act2;
@property (nonatomic) BOOL act3;
@property (nonatomic) BOOL act4;
@property (nonatomic) BOOL act5;

+ (AD3Progression *)progressionWithJSON:(NSDictionary *)JSON;

@end
