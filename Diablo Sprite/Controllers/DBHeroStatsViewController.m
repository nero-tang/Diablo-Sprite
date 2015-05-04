//
//  DBHeroStatsTableViewController.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-01.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "DBHeroStatsViewController.h"

@interface DBHeroStatsViewController ()
@end

@implementation DBHeroStatsViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *class = self.hero.className;
    NSString *gender = [[NSNumber numberWithUnsignedInteger:self.hero.gender] stringValue];
    // Load collection view background by class and gender

    UIImageView *paperdollImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@_paperdoll.jpg", class, gender]]];
    paperdollImageView.contentMode = UIViewContentModeScaleAspectFill;
    [paperdollImageView sizeToFit];
    [self.tableView.backgroundView removeFromSuperview];
    self.tableView.backgroundView = paperdollImageView;
    
    //
    [self setNavigationTitleView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self categorizedStatsDescriptions] objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self categoryDescriptions] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StatsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *statsDesc = [[[self categorizedStatsDescriptions] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *statsKey = [[[self categorizedStatsKeys] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    AD3Stats *stats = self.hero.stats;
    NSNumber *rawValue = [stats valueForKey:statsKey];
    NSString *formattedVaue = nil;
    
    if ([statsKey isEqualToString:@"damage"]) {
        formattedVaue = [NSString stringWithFormat:@"%.1f", [rawValue floatValue]];
    } else if ([statsKey isEqualToString:@"attackSpeed"]) {
        formattedVaue = [NSString stringWithFormat:@"%.2f", [rawValue floatValue]];
    } else if ([statsKey isEqualToString:@"critChance"]) {
        formattedVaue = [NSString stringWithFormat:@"%.1f%%", [rawValue floatValue] * 100.0];
    } else if ([statsKey isEqualToString:@"critDamage"]) {
        formattedVaue = [NSString stringWithFormat:@"%d%%", (int)([rawValue floatValue] * 100.0)];
    } else if ([statsKey isEqualToString:@"blockChance"]) {
        formattedVaue = [NSString stringWithFormat:@"%.1f%%", [rawValue floatValue] * 100.0];
    } else if ([statsKey isEqualToString:@"goldFind"]) {
        formattedVaue = [NSString stringWithFormat:@"%d%%", (int)([rawValue floatValue] * 100.0)];
    } else if ([statsKey isEqualToString:@"magicFind"]) {
        formattedVaue = [NSString stringWithFormat:@"%d%%", (int)([rawValue floatValue] * 100.0)];
    } else {
        formattedVaue = [rawValue stringValue];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = statsDesc;
    cell.detailTextLabel.text = formattedVaue;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *HeaderIdentifier = @"StatsHeader";
    UITableViewCell *header = [tableView dequeueReusableCellWithIdentifier:HeaderIdentifier];
    UILabel *headerLabel = (UILabel *)[header viewWithTag:0];
    headerLabel.text = [self categoryDescriptions][section];
    headerLabel.font = [UIFont fontWithName:@"ExocetBlizzardOT-Medium" size:20];
    return header;
}

#pragma mark - Helper methods
- (void)setNavigationTitleView
{
    NSString *class = self.hero.className;
    NSString *gender = [[NSNumber numberWithUnsignedInteger:self.hero.gender] stringValue];
    
    UIView *headerView = [[UIView alloc] init];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@",class, gender]]];
    imgView.frame = CGRectMake(0, 6, 40, 32);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    [headerView addSubview:imgView];
    
    UILabel *heroInfoLabel = [[UILabel alloc] init];
    NSMutableAttributedString *heroInfoAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", self.hero.name] attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
          NSFontAttributeName : [UIFont fontWithName:@"ExocetBlizzardOT-Light" size:16]}];
    NSMutableAttributedString *paragonLevel = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%lu)", (unsigned long)self.hero.paragonLevel] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:102/255.0 green:204/255.0 blue:1.0 alpha:1.0], NSFontAttributeName : [UIFont systemFontOfSize:14]}];
    [heroInfoAttrString appendAttributedString:paragonLevel];
    
    heroInfoLabel.attributedText = heroInfoAttrString;
    [heroInfoLabel sizeToFit];
    heroInfoLabel.frame = CGRectMake(40, 0, heroInfoLabel.frame.size.width, 44);

    [headerView addSubview:heroInfoLabel];
    headerView.frame = CGRectMake(0, 0, imgView.frame.size.width + heroInfoLabel.frame.size.width, 44);
    self.tabBarController.navigationItem.titleView = headerView;
    
}

- (NSArray *)categorizedStatsDescriptions
{
    // Once generated hero stats category and description
    static NSArray *categorizedStatsDesc;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *basicStatsDesc = @[@"Strength",
                                    @"Dexterity",
                                    @"Vitality",
                                    @"Intelligence"];
        NSArray *offensiveStatsDesc = @[@"Damage",
                                        @"Attack per Second",
                                        @"Critical Hit Chance",
                                        @"Critical Hit Damage"];
        NSArray *defensiveStatsDesc = @[@"Armor",
                                        @"Max Block Amount",
                                        @"Min Block Amount",
                                        @"Block Chance",
                                        @"Physical Resistance",
                                        @"Cold Resistance",
                                        @"Fire Resistance",
                                        @"Lightning Resistance",
                                        @"Poison Resistance",
                                        @"Arcane/Holy Resistance",
                                        @"Thorns"];
        NSArray *lifeStatsDesc = @[@"Maximum Life",
                                   @"Life per Hit",
                                   @"Life per Kill"];
        NSArray *resourceStatsDesc = @[@"Primary Resource",
                                       @"Second Resource"];
        NSArray *adventureStatsDesc = @[@"Gold Find",
                                        @"Magic Find"];
        
        categorizedStatsDesc = @[basicStatsDesc,
                                 offensiveStatsDesc,
                                 defensiveStatsDesc,
                                 lifeStatsDesc,
                                 resourceStatsDesc,
                                 adventureStatsDesc];
    });
    return categorizedStatsDesc;
}

- (NSArray *)categorizedStatsKeys
{
    // Once generated hero stats category and description
    static NSArray *categorizedStatsKeys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *basicStatsKeys = @[@"strength",
                                    @"dexterity",
                                    @"vitality",
                                    @"intelligence"];
        NSArray *offensiveStatsKeys = @[@"damage",
                                        @"attackSpeed",
                                        @"critChance",
                                        @"critDamage"];
        NSArray *defensiveStatsKeys = @[@"armor",
                                        @"blockAmountMax",
                                        @"blockAmountMin",
                                        @"blockChance",
                                        @"physicalResist",
                                        @"coldResist",
                                        @"fireResist",
                                        @"lightningResist",
                                        @"poisonResist",
                                        @"arcaneResist",
                                        @"thorns"];
        NSArray *lifeStatsKeys = @[@"life",
                                   @"lifeOnHit",
                                   @"lifePerKill"];
        NSArray *resourceStatsKeys = @[@"primaryResource",
                                       @"secondaryResource"];
        NSArray *adventureStatsKeys = @[@"goldFind",
                                        @"magicFind"];
        
        categorizedStatsKeys = @[basicStatsKeys,
                                 offensiveStatsKeys,
                                 defensiveStatsKeys,
                                 lifeStatsKeys,
                                 resourceStatsKeys,
                                 adventureStatsKeys];
    });
    return categorizedStatsKeys;
}

- (NSArray *)categoryDescriptions
{
    static NSArray *categoryDesc;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        categoryDesc = @[@"Basic",
                         @"Offensive",
                         @"Defensive",
                         @"Life",
                         @"Resource",
                         @"Adventure"];
    });
    return categoryDesc;
}


@end
