//
//  AD3Artisan.h
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-10.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AD3Artisan : NSObject

@property (nonatomic, strong) NSString *slug;
@property (nonatomic) NSUInteger level;
@property (nonatomic) NSInteger stepCurrent;
@property (nonatomic) NSInteger stepMax;

+ (AD3Artisan *)artisanWithJSON:(NSDictionary *)JSON;

@end
