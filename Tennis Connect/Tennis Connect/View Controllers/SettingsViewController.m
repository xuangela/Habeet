//
//  SettingsViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/27/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "SettingsViewController.h"
@import Parse;

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderControl;
@property (weak, nonatomic) IBOutlet UITextField *contactfield;
@property (weak, nonatomic) IBOutlet UIDatePicker *dobPicker;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setToCurrent];
}

- (void)setToCurrent {
    PFUser *user = [PFUser currentUser];
    self.nameField.placeholder = [user valueForKey:@"name"];
    
    NSString *gender = [user valueForKey:@"gender"];
    if ([gender isEqualToString:@"Male"]) {
        self.genderControl.selectedSegmentIndex = 0;
    } else if ([gender isEqualToString:@"Femaile"]) {
        self.genderControl.selectedSegmentIndex = 1;
    } else {
        self.genderControl.selectedSegmentIndex = 2;
    }
    
    self.contactfield.placeholder = [user valueForKey:@"contact"];
    self.dobPicker.date = [user valueForKey:@"age"];
}

- (IBAction)tapSave:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
