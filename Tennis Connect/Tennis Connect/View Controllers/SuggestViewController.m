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

- (void) updatePlayerOrder {
    for (Player* player in self.players) {
        PFUser *me = [PFUser currentUser];
        int randFactor = arc4random() % 50 * [me[@"randImport"] floatValue];
        long myAge =[[me valueForKey:@"age"] yearsAgo];
        long ageFactor =  -50 * labs(player.age - myAge) * [me[@"ageImport"] floatValue];
        long myExp = [[[PFUser currentUser] valueForKey:@"experience"] intValue];
        long experienceFactor = -50 * labs([player.experience intValue] - myExp) * [me[@"expImport"] floatValue];
        NSString *myGender = [me valueForKey:@"gender"];
        int genderFactor = [myGender isEqualToString:player.gender] ? 50*[me[@"genderImport"] floatValue] : 0;
        
        player.compatibility = randFactor + ageFactor + experienceFactor + genderFactor;
    }
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"compatibility" ascending:NO];
    [self.players sortUsingDescriptors:@[sd]];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"matchRequestSegue"]) {
        MatchRequestViewController *viewControl = [segue destinationViewController];
        
        viewControl.courts = self.courts;
        viewControl.player = self.players[self.currPlayer];
        viewControl.delegate = self;
        
        [viewControl findSharedCourts];
    } 
}



@end

