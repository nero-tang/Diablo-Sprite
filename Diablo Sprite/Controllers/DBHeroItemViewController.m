//
//  DBHeroItemViewController.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-03.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "DBHeroItemViewController.h"
#import "DBTooltipViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define BORDER_COLOR_WHITE @"#56402c"
#define BORDER_COLOR_BLUE @"#6ba9ba"
#define BORDER_COLOR_YELLOW @"#b1a73c"
#define BORDER_COLOR_ORANGE @"#fba412"
#define BORDER_COLOR_GREEN @"#a4df44"

@interface DBHeroItemViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
// Items IBOutletCollection
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *itemBackgroundCollection;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *itemIconCollection;
@property (weak, nonatomic) IBOutlet UIImageView *classBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) BOOL needRefresh;
@end

@implementation DBHeroItemViewController

#pragma mark - Getters & Setters
- (void)setHero:(AD3Hero *)hero
{
    if (_hero != hero) {
        _hero = hero;
        self.needRefresh = YES;
    }
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.needRefresh) {
        self.nameLabel.text = self.hero.name;
        NSString *class = self.hero.className;
        NSString *gender = [[NSNumber numberWithUnsignedInteger:self.hero.gender] stringValue];
        self.classBackgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@_background.jpg", class, gender]];
        
        for (UIImageView *itemBackgroundView in self.itemBackgroundCollection) {
            NSString *typeKey = [[self itemTypeKeys] objectAtIndex:itemBackgroundView.tag];
            AD3Item *itemInfo = [self.hero valueForKey:typeKey];
            if (!itemInfo) {
                continue;
            }
            NSString *displayColor = itemInfo.displayColor;
            if ([displayColor isEqualToString:@"white"]) {
                itemBackgroundView.image = [UIImage imageNamed:@"ItemBrounBackground.png"];
                itemBackgroundView.layer.borderColor = [UIColor colorWithHexString:BORDER_COLOR_WHITE].CGColor;
            } else if ([displayColor isEqualToString:@"blue"]) {
                itemBackgroundView.image = [UIImage imageNamed:@"ItemBlueBackground.png"];
                itemBackgroundView.layer.borderColor = [UIColor colorWithHexString:BORDER_COLOR_BLUE].CGColor;
            } else if ([displayColor isEqualToString:@"yellow"]) {
                itemBackgroundView.image = [UIImage imageNamed:@"ItemYellowBackground.png"];
                itemBackgroundView.layer.borderColor = [UIColor colorWithHexString:BORDER_COLOR_YELLOW].CGColor;
            } else if ([displayColor isEqualToString:@"orange"]) {
                itemBackgroundView.image = [UIImage imageNamed:@"ItemOrangeBackground.png"];
                itemBackgroundView.layer.borderColor = [UIColor colorWithHexString:BORDER_COLOR_ORANGE].CGColor;
            } else if ([displayColor isEqualToString:@"green"]) {
                itemBackgroundView.image = [UIImage imageNamed:@"ItemGreenBackground.png"];
                itemBackgroundView.layer.borderColor = [UIColor colorWithHexString:BORDER_COLOR_GREEN].CGColor;
            }
            itemBackgroundView.layer.cornerRadius = 3.5;
            itemBackgroundView.layer.masksToBounds = YES;
            itemBackgroundView.layer.borderWidth = 1.0;
        }
        
        for (UIImageView *itemIconView in self.itemIconCollection) {
            NSString *typeKey = [[self itemTypeKeys] objectAtIndex:itemIconView.tag];
            AD3Item *itemInfo = [self.hero valueForKey:typeKey];
            if (!itemInfo) {
                continue;
            }
            [itemIconView sd_setImageWithURL:[itemInfo iconURL]];
        }
        self.needRefresh = NO;
    }
}

#pragma mark - IBActions
- (IBAction)itemClicked:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *buttonPushed = (UIButton *)sender;
        NSString *typeKey = [[self itemTypeKeys] objectAtIndex:buttonPushed.tag];
        AD3Item *itemInfo = [self.hero valueForKey:typeKey];
        [self performSegueWithIdentifier:@"ItemTooltipSegue" sender:[self.hero.career getTooltipURL:itemInfo.tooltipParams]];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ItemTooltipSegue"]) {
        if ([sender isKindOfClass:[NSURL class]]) {
            DBTooltipViewController *DBTVC = (DBTooltipViewController *)segue.destinationViewController;
            DBTVC.tooltipURL = sender;
        }
    }
}

#pragma mark - Helper Methods
- (NSArray *)itemTypeKeys
{
    static NSArray *keys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = @[@"head",
                 @"torso",
                 @"feet",
                 @"hands",
                 @"shoulders",
                 @"legs",
                 @"bracers",
                 @"mainHand",
                 @"offHand",
                 @"waist",
                 @"rightFinger",
                 @"leftFinger",
                 @"neck"];
    });
    return keys;
}



@end
