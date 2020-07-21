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
#import "SuggestedPlayerView.h"

@import Parse;

@interface SuggestViewController () <MapViewControllerDelegate>

@property (weak, nonatomic) IBOutlet SuggestedPlayerView *suggestedview;

@property (nonatomic, assign) int currPlayer;
@property (nonatomic, strong) UIAlertController *noMoreSuggestAlert;

@end

@implementation SuggestViewController

@synthesize players;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self alertSetUp];
    
    self.currPlayer = 0;
    [self.suggestedview setPlayer:self.players[self.currPlayer]];
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

- (void) findUsersWithQueries:(NSArray<PFQuery*> *) playerQueries {
    PFQuery *findingPlayers = [PFQuery orQueryWithSubqueries:playerQueries];
    NSLog(@"have all the queries");
    
    [findingPlayers findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            
        } else {
            self.players = [Player playersWithPFUserObjects:objects];
        }
    }];
}

- (IBAction)swipeLeft:(id)sender {
    self.currPlayer += 1;
    if (self.currPlayer == self.players.count) {
        [self presentViewController:self.noMoreSuggestAlert animated:YES completion:^{  }];
    } else {
        [self.suggestedview setPlayer:self.players[self.currPlayer]];
    }
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

