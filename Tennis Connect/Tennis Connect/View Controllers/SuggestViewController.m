//
//  SuggestViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/16/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "SuggestViewController.h"
#import "MapViewController.h"
#import "Court.h"
#import "Player.h"
#import <DateTools/DateTools.h>
#import "MatchRequestViewController.h"

@import Parse;

@interface SuggestViewController () <MapViewControllerDelegate, MatchRequestDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UIAlertController *noMoreSuggestAlert;
@property (nonatomic, strong) NSMutableArray<NSArray *> *suggestedPlayerBuckets; // mutable array of arrays containing players with diffferent proximities

@end

@implementation SuggestViewController

@synthesize players;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self alertSetUp];
    [self activityIndicatorSetUp];
    
    [self fetchPlayers];
    
//    self.currPlayer = 0;
//    [self.suggestedview setPlayer:self.players[self.currPlayer]];
    
    
}

- (void) activityIndicatorSetUp {
    self.activityIndicator.hidesWhenStopped = YES;
    self.view.userInteractionEnabled = NO;
    [self.activityIndicator startAnimating];
}

- (void) fetchPlayers {
    // make queries
    // execute queries
    // store results of each query in suggestedPlayerBuckets
    // query for more in suggestedPlayerbucket when 
    
    
    
    
    
    
    [self.activityIndicator stopAnimating];
    self.view.userInteractionEnabled = YES;
}

- (PFQuery*) queryForFindingPlayersForCourt:(PFObject *) court {
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" notEqualTo:[[PFUser currentUser] objectId]];
    
    if ([[[PFUser currentUser] valueForKey:@"genderImport"] boolValue]== YES) {
        [query whereKey:@"gender" equalTo:[[PFUser currentUser] valueForKey:@"gender"]];
    }
    
    [query whereKey:@"courts" equalTo:court];
    
    return query;
}


- (void) alertSetUp {
    self.noMoreSuggestAlert = [UIAlertController alertControllerWithTitle:@"No more suggestions"
           message:@"Suggestions will reset to top suggestion."
    preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.currPlayer = 0;
        [self.suggestedview setPlayer:self.players[self.currPlayer]];
    }];
    [self.noMoreSuggestAlert addAction:okAction];
}

- (IBAction)swipeLeft:(id)sender {
    self.currPlayer += 1;
    if (self.currPlayer == self.players.count) {
        [self presentViewController:self.noMoreSuggestAlert animated:YES completion:^{  }];
    } else {
        [self.suggestedview setPlayer:self.players[self.currPlayer]];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"matchRequestSegue"]) {
        MatchRequestViewController *viewControl = [segue destinationViewController];
        
        viewControl.courts = self.courts;
        viewControl.player = self.players[self.currPlayer];
        viewControl.delegate = self;
        
        [viewControl findSharedCourts];
    } 
}

@end

