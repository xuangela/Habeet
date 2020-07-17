//
//  LoginViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/13/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

// TODO: modally present registration screen

#import "LoginViewController.h"
#import "MapViewController.h"
#import "SuggestViewController.h"
#import "Court.h"
@import Parse;

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (nonatomic, strong) UIAlertController *emptyUsernameAlert;
@property (nonatomic, strong) UIAlertController *emptyPWAlert;
@property (nonatomic, strong) UIAlertController *badLoginAlert;
@property (nonatomic, strong) UIAlertController *usernameTakenAlert;

@property (nonatomic, assign) BOOL tappedButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self alertSetUp];
}

- (void) alertSetUp {
    self.emptyUsernameAlert = [UIAlertController alertControllerWithTitle:@"Missing username."
           message:@"Please input your username."
    preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [self.emptyUsernameAlert addAction:okAction];
    
    self.emptyPWAlert = [UIAlertController alertControllerWithTitle:@"Missing password."
           message:@"Please input your password."
    preferredStyle:(UIAlertControllerStyleAlert)];
    [self.emptyPWAlert addAction:okAction];
    
    self.badLoginAlert = [UIAlertController alertControllerWithTitle:@"Invalid credentials."
           message:@"Invalid login parameters, please try again."
    preferredStyle:(UIAlertControllerStyleAlert)];
    [self.badLoginAlert addAction:okAction];
    
    self.usernameTakenAlert = [UIAlertController alertControllerWithTitle:@"Username taken."
           message:@"Please try a different username."
    preferredStyle:(UIAlertControllerStyleAlert)];
    [self.usernameTakenAlert addAction:okAction];
}

- (IBAction)tapOther:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)tapRegister:(id)sender {
    if (!self.tappedButton) {
        self.tappedButton = YES;
        if ([self.usernameField.text isEqual:@""]) {
            [self presentViewController:self.emptyUsernameAlert animated:YES completion:^{  }];
        } else if ([self.passwordField.text isEqual:@""]) {
            [self presentViewController:self.emptyPWAlert animated:YES completion:^{  }];
        } else {
            PFUser *newUser = [PFUser user];
            
            newUser.username = self.usernameField.text;
            newUser.password = self.passwordField.text;
            
            // call sign up function on the object
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (error != nil) {
                    if (error.code == 202) {
                        [self presentViewController:self.usernameTakenAlert animated:YES completion:^{  }];
                    } else {
                         UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                             message:[error localizedDescription]
                          preferredStyle:(UIAlertControllerStyleAlert)];
                          UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                          [tempAlert addAction:okAction];
                         [self presentViewController:tempAlert animated:YES completion:^{  }];
                    }
                } else {
                    [self performSegueWithIdentifier:@"registerSegue" sender:nil];
                }
            }];
        }
        self.tappedButton = NO;
    }
}

- (IBAction)tapLogin:(id)sender {
    if (!self.tappedButton) {
        self.tappedButton = YES;
        if ([self.usernameField.text isEqual:@""]) {
            [self presentViewController:self.emptyUsernameAlert animated:YES completion:^{  }];
        } else if ([self.passwordField.text isEqual:@""]) {
            [self presentViewController:self.emptyPWAlert animated:YES completion:^{  }];
        } else {
         NSString *username = self.usernameField.text;
         NSString *password = self.passwordField.text;
         
         [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
             if (error != nil) {
                 if (error.code == 101) {
                     [self presentViewController:self.badLoginAlert animated:YES completion:^{  }];
                 } else {
                      UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                         message:error.localizedDescription
                      preferredStyle:(UIAlertControllerStyleAlert)];
                      UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                      [tempAlert addAction:okAction];
                     [self presentViewController:tempAlert animated:YES completion:^{  }];
                 }
             } else {
                 [self performSegueWithIdentifier:@"loginSegue" sender:nil];
             }
         }];
        }
        self.tappedButton = NO;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    
    if ([segue.identifier isEqualToString:@"loginSegue"]) {
        UITabBarController *tabController = [segue destinationViewController];
        tabController.selectedIndex = 2;
        
        MapViewController *mapcontroller = tabController.viewControllers[2];
        SuggestViewController<MapViewControllerDelegate> *suggestcontroller = tabController.viewControllers[1];
        [mapcontroller mapSetUp];
        
        mapcontroller.delegate = suggestcontroller;
        
        PFRelation *relation = [[PFUser currentUser] relationForKey:@"courts"];
           PFQuery *query = [relation query];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            for (Court *court in objects) {
                [relation removeObject:court];
            }
            NSLog(@"deleted");
            [mapcontroller fetchCourtsnear];
        }];

        
        
        
    } 
}




@end
