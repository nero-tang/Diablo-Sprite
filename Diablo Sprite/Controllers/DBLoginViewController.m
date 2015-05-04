//
//  DBViewController.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-08-30.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "DBLoginViewController.h"
#import "DBCareerProfileViewController.h"
#import <MBProgressHUD.h>

@interface DBLoginViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    CGFloat keyboardAnimatedDistance;
}
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@property (strong, nonatomic) NSMutableOrderedSet *historyBattleTags;
@property (nonatomic) AD3Region serverRegion;

@end

@implementation DBLoginViewController

#pragma mark - Getters & Setters
- (NSMutableOrderedSet *)historyBattleTags
{
    if (!_historyBattleTags) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *historyArray = [userDefaults arrayForKey:@"history"];
        if (!historyArray) {
            _historyBattleTags = [[NSMutableOrderedSet alloc] init];
        } else {
            _historyBattleTags = [NSMutableOrderedSet orderedSetWithArray:historyArray];
        }
    }
    return _historyBattleTags;
}

#pragma mark - UIViewController
static const CGFloat ACCESSORY_TOOLBAR_HEIGHT = 50.0;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add accessory view to keyboard
    UIToolbar* accessoryToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ACCESSORY_TOOLBAR_HEIGHT)];
    accessoryToolbar.barTintColor = [UIColor blackColor];
    accessoryToolbar.tintColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissKeyboard)];
    UIBarButtonItem *loginButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(login)];
    
    accessoryToolbar.items = [NSArray arrayWithObjects:cancelButtonItem, flexibleSpaceItem, loginButtonItem, nil];
    [accessoryToolbar sizeToFit];
    self.tagTextField.inputAccessoryView = accessoryToolbar;
    self.numTextField.inputAccessoryView = accessoryToolbar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.historyTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:[self.historyBattleTags array] forKey:@"history"];
    [super viewDidDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - IBAction
- (IBAction)regionChanged:(id)sender
{
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *regionControl = (UISegmentedControl *)sender;
        self.serverRegion = regionControl.selectedSegmentIndex;
    }
}

- (void)login
{
    [self dismissKeyboard];
    NSString *battleTag = [NSString stringWithFormat:@"%@#%@", self.tagTextField.text, self.numTextField.text];
    
    MBProgressHUD *loadingView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingView.labelText = @"Loading Career Profile...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [AD3Career fetchCareerByBattleTag:battleTag inRegion:self.serverRegion completionHandler:^(NSError *error, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadingView hide:YES];
                if (error) {
                    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                    [errorAlert show];
                } else {
                    if ([responseObject isKindOfClass:[AD3Career class]]) {
                        [self performSegueWithIdentifier:@"LoginSegue" sender:responseObject];
                        [self.historyBattleTags addObject:battleTag];
                    }
                }
            });
        }];
    });
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LoginSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nc = (UINavigationController *)segue.destinationViewController;;
            DBCareerProfileViewController *DBhcvc = (DBCareerProfileViewController *)nc.topViewController;
            DBhcvc.career = sender;
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.historyBattleTags count];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HistoryTagCell";
    
    UITableViewCell *cell = [self.historyTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.historyBattleTags objectAtIndex:indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor whiteColor]];
    return @"History Battle Tags";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *battleTag = [self.historyBattleTags objectAtIndex:indexPath.row];
    NSArray *tagComponents = [battleTag componentsSeparatedByString:@"#"];
    self.tagTextField.text = [tagComponents firstObject];
    self.numTextField.text = [tagComponents lastObject];
    [self.tagTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216 + ACCESSORY_TOOLBAR_HEIGHT;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162 + ACCESSORY_TOOLBAR_HEIGHT;

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat viewHeight, bottomOfTextField, topOfKeyboard;
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        viewHeight = viewRect.size.height;
        bottomOfTextField = textFieldRect.origin.y + textFieldRect.size.height;
        topOfKeyboard = viewHeight - PORTRAIT_KEYBOARD_HEIGHT - 100; // 50 point padding
    } else {
        viewHeight = viewRect.size.width;
        bottomOfTextField = textFieldRect.origin.x + textFieldRect.size.width;
        topOfKeyboard = viewHeight - LANDSCAPE_KEYBOARD_HEIGHT - 100; // 50 point padding
    }
    
    if (bottomOfTextField >= topOfKeyboard) {
        keyboardAnimatedDistance = bottomOfTextField - topOfKeyboard;
    } else {
        keyboardAnimatedDistance = 0.0f;
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= keyboardAnimatedDistance;
    
    [UIView animateWithDuration:KEYBOARD_ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.view.frame = viewFrame;
        [self.view layoutIfNeeded];
    } completion:NULL];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += keyboardAnimatedDistance;
    
    [UIView animateWithDuration:KEYBOARD_ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.view.frame = viewFrame;
        [self.view layoutIfNeeded];
    } completion:NULL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.tagTextField) {
        [textField resignFirstResponder];
        [self.numTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
