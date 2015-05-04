//
//  DBSkillViewController.h
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-03.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBHeroSkillViewController : UICollectionViewController
@property (strong, nonatomic) AD3Hero *hero;
@end


@interface DBHeroSkillCell : UICollectionViewCell
@property (nonatomic, strong) AD3Skill *skill;
@end


typedef NS_ENUM(NSInteger, DBHeroActiveSkillSocket)
{
    DBHeroActiveSkill_LeftMouse = 0,
    DBHeroActiveSkill_RightMouse,
    DBHeroActiveSkill_One,
    DBHeroActiveSkill_Two,
    DBHeroActiveSkill_Three,
    DBHeroActiveSkill_Four
};


@interface DBHeroActiveSkillCell : DBHeroSkillCell
- (void)loadActiveSkill:(AD3ActiveSkill *)skill inSocket:(DBHeroActiveSkillSocket)socket withLevel:(NSUInteger)level;
@end

typedef NS_ENUM(NSInteger, DBHeroPassiveSkillSocket)
{
    DBHeroPassiveSkill_One = 0,
    DBHeroPassiveSkill_Two,
    DBHeroPassiveSkill_Three,
    DBHeroPassiveSkill_Four
};

@interface DBHeroPassiveSkillCell : DBHeroSkillCell
- (void)loadPassiveSkill:(AD3PassiveSkill *)skill inSocket:(DBHeroPassiveSkillSocket)socket withLevel:(NSUInteger)level;
@end


@interface DBHeroSkillHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *label;
@end