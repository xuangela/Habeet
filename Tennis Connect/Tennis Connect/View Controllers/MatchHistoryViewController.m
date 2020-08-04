//
//  MatchHistoryViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/24/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "MatchHistoryViewController.h"
#import "MatchHistoryCell.h"
@import Parse;
@import MaterialComponents;

@interface MatchHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet MDCActivityIndicator *activityIndicator;

@end

@implementation MatchHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadingIndicatorSetUp];
    [self tableSetUp];
    [self getMatches];
}

- (void)loadingIndicatorSetUp {
    self.activityIndicator = [[MDCActivityIndicator alloc] init];
    
    UIColor *myPink = [[UIColor alloc] initWithRed:246.0/255.0 green:106.0/255.0 blue:172.0/255.0 alpha:1];
    UIColor *myLightPink = [[UIColor alloc] initWithRed:255.0/255.0 green:204.0/255.0 blue:238.0/255.0 alpha:1];
    self.activityIndicator.cycleColors =  @[myPink,myLightPink];
    
    [self.activityIndicator sizeToFit];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width  / 2, self.view.frame.size.height / 2);

    [self.activityIndicator startAnimating];
}

- (void)getMatches {
    PFQuery *sentReq = [Match query];
    [sentReq whereKey:@"sender" equalTo:[PFUser currentUser]];
    [sentReq whereKey:@"completed" equalTo:@YES];
    [sentReq includeKey:@"receiver"];
    [sentReq orderByDescending:@"updatedAt"];
    
    [sentReq findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.completedMatches = [Match matchesWithArray:objects];
        }
            PFQuery *receivedReq = [Match query];
            [receivedReq whereKey:@"receiver" equalTo:[PFUser currentUser]];
            [receivedReq includeKey:@"sender"];
            [receivedReq whereKey:@"completed" equalTo:@YES];
            [receivedReq orderByDescending:@"updatedAt"];
        
        [receivedReq findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                NSArray* moreMatches = [Match matchesWithArray:objects];
                [self.completedMatches addObjectsFromArray:moreMatches];
                
                NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"updatedAt" ascending:NO];
                [self.completedMatches sortUsingDescriptors:@[sd]];
            }
            
            [self.activityIndicator stopAnimating];
            [self.tableview reloadData];
        }];
    }];
}

#pragma mark - Table

- (void)tableSetUp {
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchHistoryCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"MatchHistoryCell"];

    Match *match = self.completedMatches[indexPath.row];
    [cell setMatch:match];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.completedMatches.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 191;
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
