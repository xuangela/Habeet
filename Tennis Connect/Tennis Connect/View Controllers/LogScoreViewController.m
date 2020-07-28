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
@property (weak, nonatomic) IBOutlet UIView *set1View;
@property (weak, nonatomic) IBOutlet UIView *set2View;
@property (weak, nonatomic) IBOutlet UIView *set3View;
@property (weak, nonatomic) IBOutlet UITextField *mySet1Games;
@property (weak, nonatomic) IBOutlet UITextField *theirSet1Games;
@property (weak, nonatomic) IBOutlet UITextField *mySet2Games;
@property (weak, nonatomic) IBOutlet UITextField *theirSet2Games;
@property (weak, nonatomic) IBOutlet UITextField *mySet3Games;
@property (weak, nonatomic) IBOutlet UITextField *theirSet3Games;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (nonatomic, strong) UIAlertController *emptyScoreAlert;
@property (nonatomic, assign) BOOL isSender;
@property (nonatomic, assign) BOOL set3shown;

@end

@implementation LogScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pfpSetUp];
    [self visibilitySetUp];
    [self alertSetUp];
    [self registerNotifications];
    
}


- (void) alertSetUp {
    self.emptyScoreAlert = [UIAlertController alertControllerWithTitle:@"Missing game score."
           message:@"Please games won for both you and your opponent."
    preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [self.emptyScoreAlert addAction:okAction];
    
}

- (void) pfpSetUp {
    PFUser *opponent;
    if ([self.match.receiver.objectId isEqualToString:[PFUser currentUser].objectId]) {
        opponent = self.match.sender;
        self.isSender = NO;
    } else {
        opponent = self.match.receiver;
        self.isSender = YES;
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

- (void)visibilitySetUp {
    self.set1View.alpha = 1;
    self.set2View.alpha = 0;
    self.set3View.alpha = 0;
}

- (IBAction)tapOther:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)tapConfirm:(id)sender {
    BOOL set1Good = ![self.mySet1Games.text isEqualToString:@""] && ![self.theirSet1Games.text isEqualToString:@""];
    
    BOOL playingbo3 = self.segmentcontrol.selectedSegmentIndex == 1;
    BOOL set2Good = playingbo3 ? ![self.mySet2Games.text isEqualToString:@""] && ![self.theirSet2Games.text isEqualToString:@""]:YES;
    
    BOOL dispSet3 = self.set3View.alpha == 1;
    BOOL set3Good = dispSet3 ? ![self.mySet1Games.text isEqualToString:@""] && ![self.theirSet1Games.text isEqualToString:@""]:YES;
    
    if (set1Good && set2Good &&set3Good ) {
        [self sendScoresToParse];
        self.delegate.loggedMatch = self.match;
        [self.delegate.matches removeObject:self.match];
        [self.delegate.tableview reloadData];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self presentViewController:self.emptyScoreAlert animated:YES completion:^{  }];
    }
    
}
- (IBAction)doDisplaySet3:(id)sender {
    if (self.segmentcontrol.selectedSegmentIndex == 1) {
         BOOL set1Good = ![self.mySet1Games.text isEqualToString:@""] && ![self.theirSet1Games.text isEqualToString:@""];
         BOOL set2Good = ![self.mySet2Games.text isEqualToString:@""] && ![self.theirSet2Games.text isEqualToString:@""];
        
        if (set1Good && set2Good) {
            BOOL iwin1 = [self.mySet1Games.text intValue] > [self.theirSet1Games.text intValue];
            BOOL iwin2 = [self.mySet2Games.text intValue] > [self.theirSet2Games.text intValue];
            if (iwin1 != iwin2) {
                [UIView animateWithDuration:1 animations:^{
                    self.set3View.alpha = 1;
                }];
                self.set3shown = YES;
            }
        } else {
            [UIView animateWithDuration:1 animations:^{
                self.set3View.alpha = 0;
            }];
            self.set3shown = NO;
        }
    }
}
- (IBAction)changeBO:(id)sender {
    if (self.segmentcontrol.selectedSegmentIndex == 1) {
        self.set2View.alpha = 1;
        if (self.set3shown) {
            self.set3View.alpha = 1;
        }
    } else {
        self.set2View.alpha = 0;
        self.set3View.alpha = 0;
    }
}

- (void) sendScoresToParse {
    NSArray *scores;
    
    if (self.isSender) {
        scores = @[self.mySet1Games.text, self.theirSet1Games.text,self.mySet2Games.text, self.theirSet2Games.text,self.mySet3Games.text, self.theirSet3Games.text,];
    } else {
        scores = @[self.theirSet1Games.text, self.mySet1Games.text,self.theirSet2Games.text, self.mySet2Games.text,self.theirSet3Games.text, self.mySet3Games.text,];
    }
    
    PFQuery *query = [Match query];
    
    [query getObjectInBackgroundWithId:self.match.objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        object[@"scores"] = scores;
        object[@"completed"] = @YES;
        
        NSLog(@"match logged and updated:");
        
        [object saveInBackground];
    }];
}

#pragma mark - Keyboard

- (void) registerNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillShow:(NSNotification *) notif {
    NSDictionary* userInfo = notif.userInfo;
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    keyboardFrame = [self.view convertRect:keyboardFrame fromView:nil];
    
    UIEdgeInsets contentInset = self.scrollview.contentInset;
    contentInset.bottom = keyboardFrame.size.height + 20;
    self.scrollview.contentInset = contentInset;
}

- (void) keyboardWillHide:(NSNotification *) notif {
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    self.scrollview.contentInset = contentInset;
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
