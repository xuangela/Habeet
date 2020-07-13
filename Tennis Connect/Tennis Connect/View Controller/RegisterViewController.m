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

@property (nonatomic, strong) UIAlertController *emptyUsernameAlert;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAlerts];
}

-(void)setUpAlerts {
    self.emptyUsernameAlert = [UIAlertController alertControllerWithTitle:@"Missing name."
              message:@"Please input your first name."
       preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [self.emptyUsernameAlert addAction:okAction];
}

- (IBAction)tapRegister:(id)sender {
    if ([self.nameField.text isEqual:@""]) {
        [self presentViewController:self.emptyUsernameAlert animated:YES completion:^{  }];
    } else {
        PFUser *user = [PFUser currentUser];
        
        user[@"name"] = self.nameField.text;
        user[@"gender"] = [NSNumber numberWithLong: self.genderSegControl.selectedSegmentIndex];
        user[@"contact"] =self.contactField.text;
        user[@"age"] = self.dateOfBirthPicker.date;
        user[@"experience"] = [NSNumber numberWithLong: self.skillSegControl.selectedSegmentIndex];
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) { }];
        
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    }
}

- (IBAction)tapCancel:(id)sender {
    [[PFUser currentUser] delete];
    [self performSegueWithIdentifier:@"delSegue" sender:nil];
}

- (IBAction)tapOther:(id)sender {
    [self.view endEditing:YES];
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
