//
//  SettingsViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/27/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "SettingsViewController.h"
#import <DateTools/DateTools.h>
@import Parse;

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderControl;
@property (weak, nonatomic) IBOutlet UITextField *contactfield;
@property (weak, nonatomic) IBOutlet UIDatePicker *dobPicker;

@property (weak, nonatomic) IBOutlet UISwitch *genderMatchSwitch;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UISlider *randSlider;
@property (weak, nonatomic) IBOutlet UILabel *randomLabel;
@property (weak, nonatomic) IBOutlet UISlider *ratingSlider;

@property (nonatomic, strong) UIAlertController *saveChangesAlert;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setToCurrent];
    [self alertSetUp];
}

- (void)setToCurrent {
    PFUser *user = [PFUser currentUser];
    self.nameField.placeholder = [user valueForKey:@"name"];
    
    NSString *gender = [user valueForKey:@"gender"];
    if ([gender isEqualToString:@"Male"]) {
        self.genderControl.selectedSegmentIndex = 0;
    } else if ([gender isEqualToString:@"Female"]) {
        self.genderControl.selectedSegmentIndex = 1;
    } else {
        self.genderControl.selectedSegmentIndex = 2;
    }
    
    self.contactfield.placeholder = [user valueForKey:@"contact"];
    self.dobPicker.date = [user valueForKey:@"age"];
    
    self.genderMatchSwitch.on =[[user valueForKey:@"genderSearch"] boolValue];
    self.ageSlider.value = [[user valueForKey:@"ageDiffSearch"] floatValue];
    self.ratingSlider.value = [[user valueForKey:@"ratingDiffSearch"] floatValue];
    self.randSlider.value = [[user valueForKey:@"random"] floatValue];
}

- (void) alertSetUp {
    self.saveChangesAlert = [UIAlertController alertControllerWithTitle:@"Save changes?"
           message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveSettings];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [self.saveChangesAlert addAction:yesAction];
    [self.saveChangesAlert addAction:noAction];
    [self.saveChangesAlert.view setTintColor:UIColor.blackColor];
}

- (IBAction)tapOther:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)tapSave:(id)sender {
    [self presentViewController:self.saveChangesAlert animated:YES completion:^{  }];
}

- (void) saveSettings {
    PFQuery *query = [PFUser query];
    
    self.delegate.wasUpdated = YES;
    
    [query getObjectInBackgroundWithId:[PFUser currentUser].objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        if (![self.nameField.text isEqualToString:@""]) {
            object[@"name"] = self.nameField.text;
        }
        
        object[@"gender"] = [self.genderControl titleForSegmentAtIndex:self.genderControl.selectedSegmentIndex];
        
        if (![self.contactfield.text isEqualToString:@""]) {
            object[@"contact"] = [self formatContactNum];
        }
        
        object[@"age"] = self.dobPicker.date;
        
        object[@"genderSearch"] = @(self.genderMatchSwitch.on);
        object[@"ageDiffSearch"] = [NSNumber numberWithFloat:self.ageSlider.value];
        object[@"ratingDiffSearch"] = [NSNumber numberWithFloat:self.ratingSlider.value];
        object[@"random"] = [NSNumber numberWithFloat:self.randSlider.value];
        
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                NSLog(@"settings saved");
            }];
        }];
    }];
}

- (NSString*) formatContactNum {
    NSString *unformatted = self.contactfield.text;
    NSArray *stringComponents = [NSArray arrayWithObjects:[unformatted substringWithRange:NSMakeRange(0, 3)],
                                [unformatted substringWithRange:NSMakeRange(3, 3)],
                                [unformatted substringWithRange:NSMakeRange(6, [unformatted length]-6)], nil];

    NSString *formattedString = [NSString stringWithFormat:@"(%@)%@-%@", [stringComponents objectAtIndex:0], [stringComponents objectAtIndex:1], [stringComponents objectAtIndex:2]];
    
    return formattedString;
}

#pragma mark - Slider set up

- (IBAction)slideAge:(id)sender {
    int value = self.ageSlider.value;
    if (value < 1.5) {
        [self.ageSlider setValue:0 animated:YES];
    } else if (value < 4.5) {
        [self.ageSlider setValue:3 animated:YES];
    } else if (value <7.5) {
        [self.ageSlider setValue:6 animated:YES];
    } else if (value < 10.5) {
        [self.ageSlider setValue:9 animated:YES];
    } else if (value < 13.5) {
        [self.ageSlider setValue:12 animated:YES];
    } else {
        [self.ageSlider setValue:15 animated:YES];
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"%.0f years", self.ageSlider.value];
    
    if (self.ageSlider.value == 15) {
        self.ageLabel.text = @"15+ years";
    }
}

- (IBAction)slideRating:(id)sender {
    int value = self.ratingSlider.value;
    if (value < 100) {
        [self.ratingSlider setValue:0 animated:YES];
    } else if (value < 300) {
        [self.ratingSlider setValue:200 animated:YES];
    } else if (value < 500) {
        [self.ratingSlider setValue:400 animated:YES];
    } else if (value < 700) {
        [self.ratingSlider setValue:600 animated:YES];
    } else if (value < 900) {
        [self.ratingSlider setValue:800 animated:YES];
    } else {
        [self.ratingSlider setValue:1000 animated:YES];
    }
    
    self.ratingLabel.text = [NSString stringWithFormat:@"+- %.0f", self.ratingSlider.value];
    
    if (self.ratingSlider.value == 1000) {
        self.ratingLabel.text = @"+- 1000+";
    }
}

- (IBAction)slideRand:(id)sender {
    float roundedPerc =roundf(self.randSlider.value * 100);
    self.randomLabel.text = [NSString stringWithFormat:@"%.0f%%", roundedPerc];
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
