//
//  RegisterViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/13/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "RegisterViewController.h"
@import Parse;

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegControl;
@property (weak, nonatomic) IBOutlet UITextField *contactField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateOfBirthPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *skillSegControl;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)tapRegister:(id)sender {
    PFUser *user = [PFUser currentUser];
    
    user[@"name"] = self.nameField.text;
    user[@"gender"] = [NSNumber numberWithLong: self.genderSegControl.selectedSegmentIndex];
    user[@"contact"] =self.contactField.text;
    user[@"age"] = self.dateOfBirthPicker.date;
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) { }];
    
    [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    
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
