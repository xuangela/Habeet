//
//  LogScoreViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/23/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "LogScoreViewController.h"

@interface LogScoreViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *mypfpView;
@property (weak, nonatomic) IBOutlet PFImageView *otherpfpView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentcontrol;

@end

@implementation LogScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pfpSetUp];
}

- (void) pfpSetUp {
    PFUser *opponent;
    if ([self.match.receiver.objectId isEqualToString:[PFUser currentUser].objectId]) {
        opponent = self.match.sender;
    } else {
        opponent = self.match.receiver;
    }
    
    if ([[PFUser currentUser] valueForKey:@"picture"]) {
        self.mypfpView.file = [[PFUser currentUser] valueForKey:@"picture"];
        [self.mypfpView loadInBackground];
    }
    
    if ([opponent valueForKey:@"picture"]) {
        self.otherpfpView.file = [opponent valueForKey:@"picture"];
        [self.otherpfpView loadInBackground];
    }
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
