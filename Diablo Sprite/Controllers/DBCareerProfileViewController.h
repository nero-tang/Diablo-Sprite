//
//  DBHeroCollectionViewController.h
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-08-30.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBCareerProfileViewController : UICollectionViewController
@property (strong, nonatomic) AD3Career *career;
@end

@interface DBCareerCollectionCell : UICollectionViewCell
@property (nonatomic, strong) AD3Hero *hero;
@end

@interface DBCareerCollectionHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *paragonLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *hardcoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *seasonalLabel;
@end