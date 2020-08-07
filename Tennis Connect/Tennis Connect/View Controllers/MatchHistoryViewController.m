//
//  MatchHistoryViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/24/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "MatchHistoryViewController.h"
#import "MatchHistoryCell.h"
#import "EmptyCell.h"
@import Parse;
@import MaterialComponents;

@interface MatchHistoryViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet MDCActivityIndicator *activityIndicator;

@property (nonatomic, assign) BOOL isMoreDataLoading;
@property (nonatomic, assign) int numFetch;
@property (nonatomic, strong) UIAlertController *noMoreMatchAlert;

@end

@implementation MatchHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.completedMatches = [[NSMutableArray alloc] init];
    
    [self alertSetUp];
    [self loadingIndicatorSetUp];
    [self tableSetUp];
    [self getMatches];
}

- (void) alertSetUp {
    self.noMoreMatchAlert = [UIAlertController alertControllerWithTitle:@"No more matches to display"
           message:@"Play more matches to see your progress :)"
    preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [self.noMoreMatchAlert addAction:okAction];
    
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
    sentReq.limit = 5;
    sentReq.skip = 5 * self.numFetch;
    
    NSMutableArray *newlyFetchedMatches = [[NSMutableArray alloc] init];
    [sentReq findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [newlyFetchedMatches addObjectsFromArray:[Match matchesWithArray:objects]];
        }
        
        PFQuery *receivedReq = [Match query];
        [receivedReq whereKey:@"receiver" equalTo:[PFUser currentUser]];
        [receivedReq includeKey:@"sender"];
        [receivedReq whereKey:@"completed" equalTo:@YES];
        [receivedReq orderByDescending:@"updatedAt"];
        receivedReq.limit = 5;
        receivedReq.skip = 5 * self.numFetch;
        self.numFetch++;
        
        [receivedReq findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                NSArray* moreMatches = [Match matchesWithArray:objects];
                [newlyFetchedMatches addObjectsFromArray:moreMatches];
            }
            
            if (newlyFetchedMatches.count == 0) {
                [self presentViewController:self.noMoreMatchAlert animated:YES completion:^{  }];
            } else {
                [self.completedMatches addObjectsFromArray:newlyFetchedMatches];
                
                NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"timeLogged" ascending:NO];
                NSArray *sortDescriptors = @[sd];
                NSArray *sortedArray = [self.completedMatches sortedArrayUsingDescriptors:sortDescriptors];
                
                self.completedMatches = [NSMutableArray arrayWithArray:sortedArray];
            }
            
            [self.activityIndicator stopAnimating];
            [self.tableview reloadData];
        }];
    }];
}
#pragma mark - Infinite scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableview.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableview.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableview.isDragging) {
            self.isMoreDataLoading = YES;
            
            [self getMatches];
            [self.activityIndicator startAnimating];
        }
    }
}

#pragma mark - Table

- (void)tableSetUp {
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.completedMatches.count > 0) {
        MatchHistoryCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"MatchHistoryCell"];

        Match *match = self.completedMatches[indexPath.row];
        [cell setMatch:match];

        return cell;
    } else {
        EmptyCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"EmptyCell"];

        cell.messageLabel.text = @"No matches to display";

        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.completedMatches.count > 0) {
        return self.completedMatches.count;
    } else {
        return 1;
    }
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
