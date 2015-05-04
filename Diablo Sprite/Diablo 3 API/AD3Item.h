//
//  AD3Item.h
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AD3Item : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *displayColor;
@property (nonatomic, strong) NSString *tooltipParams;

+ (AD3Item *)itemWithJSON:(NSDictionary *)JSON;
- (NSURL *)iconURL;

@end
