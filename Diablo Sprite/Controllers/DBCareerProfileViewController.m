//
//  DBHeroCollectionViewController.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-08-30.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "DBCareerProfileViewController.h"
#import <MBProgressHUD.h>

typedef NS_ENUM(NSUInteger, CareerType)
{
    kCareerTypeNormal = 0,
    kCareerTypeHardcore,
    kCareerTypeSeasonal,
    kCareerTypeSeasonalHardcore,
    kCareerTypeCount
};

@interface DBCareerProfileViewController ()
@property (strong, nonatomic) NSMutableArray *categorizedHeros;
@end

@implementation DBCareerProfileViewController

#pragma mark - Getters & Setters

- (NSMutableArray *)categorizedHeros
{
    if (!_categorizedHeros) {
        NSArray *heroes = self.career.heroes;
        
        // heroes by category
        _categorizedHeros = [[NSMutableArray alloc] initWithCapacity:kCareerTypeCount];
        for (int i = 0 ; i < kCareerTypeCount; i++) {
            [_categorizedHeros addObject:[[NSMutableArray alloc] init]];
        }
        
        [heroes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[AD3Hero class]]) {
                AD3Hero *hero = (AD3Hero *)obj;
                CareerType type;
                if (!hero.isHardcore & !hero.isSeasonal) {
                    type = kCareerTypeNormal;
                } else if (!hero.isHardcore & hero.isSeasonal) {
                    type = kCareerTypeSeasonal;
                } else if (hero.isHardcore & !hero.isSeasonal) {
                    type = kCareerTypeHardcore;
                } else {
                    type = kCareerTypeSeasonalHardcore;
                }
                [_categorizedHeros[type] addObject:hero];
            }
        }];
    }
    return _categorizedHeros;
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.career.battleTag;
}

#pragma mark - IBAction
- (IBAction)logout:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"HeroProfileSegue"]) {
        if ([sender isKindOfClass:[DBCareerCollectionCell class]]) {
            DBCareerCollectionCell *cell = (DBCareerCollectionCell *)sender;
            UITabBarController *tbc = (UITabBarController *)segue.destinationViewController;
            [tbc.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj setValue:cell.hero forKey:@"hero"];
            }];
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kCareerTypeCount;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.categorizedHeros[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HeroPortrait";
    DBCareerCollectionCell *cell = (DBCareerCollectionCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.hero = self.categorizedHeros[indexPath.section][indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"HeroHeader";
    DBCareerCollectionHeaderView *header = (DBCareerCollectionHeaderView *)[self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    NSString *paragonLevel = nil;
    NSString *hardcore = nil;
    NSString *seasonal = nil;
    
    switch (indexPath.section) {
        case kCareerTypeNormal:
            hardcore = @"NO";
            seasonal = @"NO";
            paragonLevel = [[NSNumber numberWithUnsignedInteger:self.career.paragonLevel] stringValue];
            break;
        case kCareerTypeHardcore:
            hardcore = @"YES";
            seasonal = @"NO";
            paragonLevel = [[NSNumber numberWithUnsignedInteger:self.career.paragonLevelHardcore] stringValue];
            break;
        case kCareerTypeSeasonal:
            hardcore = @"NO";
            seasonal = @"YES";
            paragonLevel = [[NSNumber numberWithUnsignedInteger:self.career.paragonLevelSeason] stringValue];
            break;
        case kCareerTypeSeasonalHardcore:
            hardcore = @"YES";
            seasonal = @"YES";
            paragonLevel = [[NSNumber numberWithUnsignedInteger:self.career.paragonLevelSeasonHardcore] stringValue];
            break;
            
    }
    header.hardcoreLabel.text = hardcore;
    header.seasonalLabel.text = seasonal;
    header.paragonLevelLabel.text = paragonLevel;
    return header;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DBCareerCollectionCell *cell = (DBCareerCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.hero.isFullyLoaded) {
        [self performSegueWithIdentifier:@"HeroProfileSegue" sender:cell];
    } else {
        MBProgressHUD *loadingView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        loadingView.labelText = @"Loading Hero Profile...";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [cell.hero completeLoadingWithCompletionHandler:^(NSError *error, id responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [loadingView hide:YES];
                    if (error) {
                        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                        [errorAlert show];
                    } else {
                        if ([responseObject isKindOfClass:[AD3Hero class]]) {
                            [self performSegueWithIdentifier:@"HeroProfileSegue" sender:cell];
                        }
                    }
                });
            }];
        });
    }
}


@end

@interface DBCareerCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *naviFrameImage;
@property (weak, nonatomic) IBOutlet UIImageView *heroPortraitImage;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@end

@implementation DBCareerCollectionCell

- (void)setHero:(AD3Hero *)hero
{
    _hero = hero;
    
    NSString *name = hero.name;
    NSString *level = [[NSNumber numberWithUnsignedInteger:hero.level] stringValue];
    NSString *class = hero.className;
    NSString *gender = [[NSNumber numberWithUnsignedInteger:hero.gender] stringValue];
    
    // Set hero protrait and information
    self.infoLabel.text = [NSString stringWithFormat:@"%@ %@", level, name];
    self.heroPortraitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", class, gender]];
}

@end

@implementation DBCareerCollectionHeaderView
@end


