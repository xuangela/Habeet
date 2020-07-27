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
@property (weak, nonatomic) IBOutlet UISlider *genderSlider;
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UISlider *experienceSlider;
@property (weak, nonatomic) IBOutlet UISlider *randSlider;

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
    } else if ([gender isEqualToString:@"Female"]) {
        self.genderControl.selectedSegmentIndex = 1;
    } else {
        self.genderControl.selectedSegmentIndex = 2;
    }
    
    self.contactfield.placeholder = [user valueForKey:@"contact"];
    self.dobPicker.date = [user valueForKey:@"age"];
    
    self.genderSlider.value = [[user valueForKey:@"genderImport"] floatValue];
    self.ageSlider.value = [[user valueForKey:@"ageImport"] floatValue];
    self.experienceSlider.value = [[user valueForKey:@"expImport"] floatValue];
    self.randSlider.value = [[user valueForKey:@"randImport"] floatValue];
}

- (IBAction)tapSave:(id)sender {
    PFQuery *query = [PFUser query];
    
    [query getObjectInBackgroundWithId:[PFUser currentUser].objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (![self.nameField.text isEqualToString:@""]) {
            object[@"name"] = self.nameField.text;
            self.delegate.nameLabel.text = self.nameField.text;
        }
        object[@"gender"] = [self.genderControl titleForSegmentAtIndex:self.genderControl.selectedSegmentIndex];
        self.delegate.genderLabel.text = [self.genderControl titleForSegmentAtIndex:self.genderControl.selectedSegmentIndex];
        
        if (![self.contactfield.text isEqualToString:@""]) {
        
            NSString *unformatted = self.contactfield.text;
                   NSArray *stringComponents = [NSArray arrayWithObjects:[unformatted substringWithRange:NSMakeRange(0, 3)],
                                                [unformatted substringWithRange:NSMakeRange(3, 3)],
                                                [unformatted substringWithRange:NSMakeRange(6, [unformatted length]-6)], nil];

                   NSString *formattedString = [NSString stringWithFormat:@"(%@)%@-%@", [stringComponents objectAtIndex:0], [stringComponents objectAtIndex:1], [stringComponents objectAtIndex:2]];
                   
                   
                   object[@"contact"] = formattedString;
            self.delegate.contactNumLabel.text = formattedString;
        }
        
       
        object[@"age"] = self.dobPicker.date;
        
        NSInteger age =[self.dobPicker.date yearsAgo];
         self.delegate.ageLabel.text = [NSString stringWithFormat: @"%ld", (long)age];
        
        
        object[@"genderImport"] = [NSNumber numberWithFloat:self.genderSlider.value];
        object[@"ageImport"] = [NSNumber numberWithFloat:self.ageSlider.value];
        object[@"expImport"] = [NSNumber numberWithFloat:self.experienceSlider.value];
        object[@"randImport"] = [NSNumber numberWithFloat:self.randSlider.value];
        
        
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) { }];
    }];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)changeExp:(id)sender {
    NSLog(@"%f", self.experienceSlider.value);
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
