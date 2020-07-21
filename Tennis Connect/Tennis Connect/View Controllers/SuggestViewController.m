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

@end

@implementation SuggestViewController

@synthesize players;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.suggestedview setPlayer:players[0]];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end

