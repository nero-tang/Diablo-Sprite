//
//  DBSkillViewController.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-03.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "DBHeroSkillViewController.h"
#import "DBTooltipViewController.h"
#import <UIImageView+WebCache.h>

#define HERO_SKILL_CATEGORY_COUNT 2

#define ACTIVE_SKILL_COUNT 6
#define ACTIVE_SKILL_SECTION 0
#define ACTIVE_SKILL_KEY @"active"

#define PASSIVE_SKILL_COUNT 4
#define PASSIVE_SKILL_SECTION 1
#define PASSIVE_SKILL_KEY @"passive"

@interface DBHeroSkillViewController () <UICollectionViewDelegateFlowLayout>
@end

@implementation DBHeroSkillViewController

#pragma mark - UIViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Load collection view background by class and gender
    NSString *class = self.hero.className;
    NSString *gender = [[NSNumber numberWithUnsignedInteger:self.hero.gender] stringValue];
    UIImageView *paperdollImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@_paperdoll.jpg", class, gender]]];
    paperdollImageView.contentMode = UIViewContentModeScaleAspectFill;
    [paperdollImageView sizeToFit];
    [self.collectionView.backgroundView removeFromSuperview];
    self.collectionView.backgroundView = paperdollImageView;
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return HERO_SKILL_CATEGORY_COUNT;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfItems = 0;
    switch (section) {
        case ACTIVE_SKILL_SECTION:
            numberOfItems = ACTIVE_SKILL_COUNT;
            break;
        case PASSIVE_SKILL_SECTION:
            numberOfItems = PASSIVE_SKILL_COUNT;
            break;
    }
    return numberOfItems;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Once generated cell identifiers' array
    static NSArray *cellIdentifiers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cellIdentifiers = @[@"ActiveSkillCell",
                            @"PassiveSkillCell"];
    });
    
    // Get hero's level
    NSUInteger level = self.hero.level;
    
    switch (indexPath.section) {
        case ACTIVE_SKILL_SECTION: {
            NSArray *activeSkills = self.hero.activeSkills;
            DBHeroActiveSkillCell *activeCell = (DBHeroActiveSkillCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[cellIdentifiers objectAtIndex:ACTIVE_SKILL_SECTION] forIndexPath:indexPath];
            [activeCell loadActiveSkill:activeSkills[indexPath.row] inSocket:indexPath.row withLevel:level];
            return activeCell;
        }
        case PASSIVE_SKILL_SECTION: {
            NSArray *passiveSkills = self.hero.passiveSkills;
            DBHeroPassiveSkillCell *passiveCell = (DBHeroPassiveSkillCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[cellIdentifiers objectAtIndex:PASSIVE_SKILL_SECTION] forIndexPath:indexPath];
            [passiveCell loadPassiveSkill:passiveSkills[indexPath.row] inSocket:indexPath.row withLevel:level];
            return passiveCell;
        }
        default:
            return nil;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HeaderIdentifier = @"SkillCategoryHeader";
    DBHeroSkillHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case ACTIVE_SKILL_SECTION:
            headerView.label.text = @"Active Skills";
            break;
        case PASSIVE_SKILL_SECTION:
            headerView.label.text = @"Passive Skills";
            break;
    }
    return headerView;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case PASSIVE_SKILL_SECTION:
            return CGSizeMake(65, 85);
        case ACTIVE_SKILL_SECTION:
        default:
            return CGSizeMake(75, 115);
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DBHeroSkillCell *cell = (DBHeroSkillCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.skill.name) {
        NSURL *tooltipURL = [self.hero.career getTooltipURL:[cell.skill getTooltipParams]];
        [self performSegueWithIdentifier:@"SkillTooltipSegue" sender:tooltipURL];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SkillTooltipSegue"]) {
        if ([sender isKindOfClass:[NSURL class]]) {
            DBTooltipViewController *DBTVC = (DBTooltipViewController *)segue.destinationViewController;
            DBTVC.tooltipURL = sender;
        }
    }
}



@end


/**
 * Resuable collection cell for hero skills
 */
@interface DBHeroSkillCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) UIImage *placeHolderImage;
@end

@implementation DBHeroSkillCell

- (void)setSkill:(AD3Skill *)skill
{
    if (!_skill) {
        _skill = skill;
        self.nameLabel.text = _skill.name;
        [self.iconImageView sd_setImageWithURL:[_skill iconURL] placeholderImage:self.placeHolderImage];
    }
}

@end

/**
 * Resuable collection cell for hero active skills
 */
@interface DBHeroActiveSkillCell ()
@property (weak, nonatomic) IBOutlet UIImageView *overlayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *runeImageView;
@property (weak, nonatomic) IBOutlet UILabel *runeNameLabel;
@end

@implementation DBHeroActiveSkillCell

- (void)setSkill:(AD3Skill *)skill
{
    [super setSkill:skill];
    if ([skill isKindOfClass:[AD3ActiveSkill class]]) {
        AD3ActiveSkill *activeSkill = (AD3ActiveSkill *)skill;
        if (activeSkill.rune) {
            self.runeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"runes_%@", activeSkill.rune.type]];
            self.runeNameLabel.text = activeSkill.rune.name;
        } else {
            self.runeImageView.image = [UIImage imageNamed:@"runes_none"];
        }
    }
}

- (void)loadActiveSkill:(AD3ActiveSkill *)skill inSocket:(DBHeroActiveSkillSocket)socket withLevel:(NSUInteger)level
{
        // Load default active skill icon
        switch (socket) {
            case DBHeroActiveSkill_LeftMouse:
                self.overlayImageView.image = [UIImage imageNamed:@"active_skill_overlay_leftMouse"];
                break;
            case DBHeroActiveSkill_RightMouse:
                if (level < 2) {
                    self.placeHolderImage = [UIImage imageNamed:@"active_skill_locked_1"];
                } else {
                    self.placeHolderImage = [UIImage imageNamed:@"active_skill_unlocked"];
                }
                self.overlayImageView.image = [UIImage imageNamed:@"active_skill_overlay_rightMouse"];
                break;
            case DBHeroActiveSkill_One:
                if (level < 4) {
                    self.placeHolderImage = [UIImage imageNamed:@"active_skill_locked_2"];
                } else {
                    self.placeHolderImage = [UIImage imageNamed:@"active_skill_unlocked"];
                }
                self.overlayImageView.image = [UIImage imageNamed:@"active_skill_overlay_1"];
                break;
            case DBHeroActiveSkill_Two:
                if (level < 9) {
                    self.placeHolderImage = [UIImage imageNamed:@"active_skill_locked_3"];
                } else {
                    self.placeHolderImage = [UIImage imageNamed:@"active_skill_unlocked"];
                }
                
                self.overlayImageView.image = [UIImage imageNamed:@"active_skill_overlay_2"];
                break;
            case DBHeroActiveSkill_Three:
                if (level < 14) {
                    self.placeHolderImage = [UIImage imageNamed:@"active_skill_locked_4"];
                } else {
                    self.placeHolderImage = [UIImage imageNamed:@"active_skill_unlocked"];
                }
                self.overlayImageView.image = [UIImage imageNamed:@"active_skill_overlay_3"];
                break;
            case DBHeroActiveSkill_Four:
                if (level < 19) {
                    self.placeHolderImage = [UIImage imageNamed:@"active_skill_locked_5"];
                } else {
                    self.placeHolderImage= [UIImage imageNamed:@"active_skill_unlocked"];
                }
                self.overlayImageView.image = [UIImage imageNamed:@"active_skill_overlay_4"];
                break;
        }
    self.skill = skill;
}
@end

/**
 * Resuable collection cell for hero passive skills
 */
@interface DBHeroPassiveSkillCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation DBHeroPassiveSkillCell

- (void)loadPassiveSkill:(AD3PassiveSkill *)skill inSocket:(DBHeroPassiveSkillSocket)socket withLevel:(NSUInteger)level
{
        switch (socket) {
            case DBHeroPassiveSkill_One:
                if (level < 10) {
                    self.backgroundImageView.image = [UIImage imageNamed:@"passive_skill_locked_1"];
                } else {
                    self.backgroundImageView.image = [UIImage imageNamed:@"passive_skill_unlocked"];
                }
                break;
            case DBHeroPassiveSkill_Two:
                if (level < 20) {
                    self.backgroundImageView.image = [UIImage imageNamed:@"passive_skill_locked_2"];
                } else {
                    self.backgroundImageView.image = [UIImage imageNamed:@"passive_skill_unlocked"];
                }
                break;
            case DBHeroPassiveSkill_Three:
                if (level < 30) {
                    self.backgroundImageView.image = [UIImage imageNamed:@"passive_skill_locked_3"];
                } else {
                    self.backgroundImageView.image = [UIImage imageNamed:@"passive_skill_unlocked"];
                }
                break;
            case DBHeroPassiveSkill_Four:
                self.backgroundImageView.image = [UIImage imageNamed:@"passive_skill_unlocked"];
                break;
        }
    self.skill = skill;
}

@end


@interface DBHeroSkillHeaderView ()
@end

@implementation DBHeroSkillHeaderView
@end










