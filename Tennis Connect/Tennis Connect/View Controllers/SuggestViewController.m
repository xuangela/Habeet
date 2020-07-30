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
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *suggestedPlayerBuckets; // mutable array of arrays containing players with diffferent proximities
@property (nonatomic, assign) int bestBucket;
@property (nonatomic, strong) NSMutableArray<NSNumber *>* bucketDump;
@property (nonatomic, strong) NSArray *fetchOccurences;

@end

@implementation SuggestViewController

@synthesize players;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self alertSetUp];
    [self activityIndicatorSetUp];
    
    [self initializeArrays];
    
    [self fetchPlayers];
}

- (void) activityIndicatorSetUp {
    [self.view bringSubviewToFront:self.activityIndicator];
    self.activityIndicator.hidesWhenStopped = YES;
    self.view.userInteractionEnabled = NO;
    [self.activityIndicator startAnimating];
}

- (void)initializeArrays {
    self.suggestedPlayerBuckets = [[NSMutableArray alloc] init];
    
    int myageDiffPref = [[[PFUser currentUser] valueForKey:@"ageDiffSearch"] intValue];
    int myratingDiffPref = [[[PFUser currentUser] valueForKey:@"ratingDiffSearch"] intValue];
    int numBuckets = ((15 - myageDiffPref) / 3) + ((1000 - myratingDiffPref) / 200) + 1;
    
    for (int i = 0; i < numBuckets; i++) {
        NSMutableArray *newBucket = [[NSMutableArray alloc] init];
        [self.suggestedPlayerBuckets addObject:newBucket];
    }
    
    self.players = [[NSMutableArray alloc] init];
    self.currPlayer = -1;
    
    self.fetchOccurences = [[NSMutableArray alloc] initWithCapacity:numBuckets];
    
    self.bucketDump =[[NSMutableArray alloc] init];
    for (int i = 0; i < numBuckets; i++) {
        [self.bucketDump addObject:@0];
    }
    self.bestBucket = 0;
}

- (void) fetchPlayers {
    PFUser *me = [PFUser currentUser];
    
    int myageDiffPref = [[me valueForKey:@"ageDiffSearch"] intValue];
    int myratingDiffPref = [[me valueForKey:@"ratingDiffSearch"] intValue];
    
    for (int ageDiff = myageDiffPref; ageDiff <= 15; ageDiff+= 3) {
        for (int ratingDiff = myratingDiffPref; ratingDiff <= 1000; ratingDiff+= 200) {
            [self allQueriesForAgeDiff:ageDiff andRatingDiff:ratingDiff];
        }
    }
}

- (void)allQueriesForAgeDiff: (int)ageDiff andRatingDiff: (int)ratingDiff {
    PFUser *me = [PFUser currentUser];
    
    NSDate* mydob = [me valueForKey:@"age"];
    int myageDiffPref = [[me valueForKey:@"ageDiffSearch"] intValue];
    int myratingDiffPref = [[me valueForKey:@"ratingDiffSearch"] intValue];
    
    NSDate* earliestdobQuery = [mydob dateBySubtractingYears:(NSInteger)(ageDiff)];
    NSDate* latestdobQuery = [mydob dateByAddingYears:(NSInteger)(ageDiff)];
    
    NSInteger prevAgeDiff = (ageDiff - myageDiffPref) > 0 ? (ageDiff - 3): 0;
    NSDate* prevEarliestdobQuery= [mydob dateBySubtractingYears:prevAgeDiff];
    NSDate* prevLatestdobQuery= [mydob dateBySubtractingYears:prevAgeDiff];
    
    int myRating = [[me valueForKey:@"rating"] intValue];
    
    int smallestRating = (myRating - ratingDiff);
    int largestRating = (myRating + ratingDiff);
    
    int prevRatingDiff = (ratingDiff - myratingDiffPref) > 0 ? (ratingDiff - 200)  : 0;
    int prevSmallestRating = (myRating - prevRatingDiff);
    int prevLargestRating = (myRating + prevRatingDiff);
    
    PFQuery *query1 = [self baseQueryWithOccNum:1]; // age+ rating+
    PFQuery *query2 = [self baseQueryWithOccNum:1]; // age+ rating-
    PFQuery *query3 = [self baseQueryWithOccNum:1]; // age- rating+
    PFQuery *query4 = [self baseQueryWithOccNum:1]; // age- rating-
    
    [query1 whereKey:@"rating" greaterThan:[NSNumber numberWithInt:prevLargestRating]];
    [query1 whereKey:@"rating" lessThanOrEqualTo:[NSNumber numberWithInt:largestRating]];
    [query1 whereKey:@"age" greaterThan:prevLatestdobQuery];
    [query1 whereKey:@"age" lessThanOrEqualTo:latestdobQuery];
    
    [query2 whereKey:@"rating" greaterThan:[NSNumber numberWithInt:smallestRating]];
    [query2 whereKey:@"rating" lessThanOrEqualTo:[NSNumber numberWithInt:prevSmallestRating]];
    [query2 whereKey:@"age" greaterThan:prevLatestdobQuery];
    [query2 whereKey:@"age" lessThanOrEqualTo:latestdobQuery];
    
    [query3 whereKey:@"rating" greaterThan:[NSNumber numberWithInt:prevLargestRating]];
    [query3 whereKey:@"rating" lessThanOrEqualTo:[NSNumber numberWithInt:largestRating]];
    [query3 whereKey:@"age" greaterThan:earliestdobQuery];
    [query3 whereKey:@"age" lessThanOrEqualTo:prevEarliestdobQuery];
    
    [query4 whereKey:@"rating" greaterThan:[NSNumber numberWithInt:smallestRating]];
    [query4 whereKey:@"rating" lessThanOrEqualTo:[NSNumber numberWithInt:prevSmallestRating]];
    [query4 whereKey:@"age" greaterThan:earliestdobQuery];
    [query4 whereKey:@"age" lessThanOrEqualTo:prevEarliestdobQuery];
    
    [self performQueries:@[query1, query2, query3, query4] withAgeDiff:ageDiff andRatingDiff:ratingDiff];
    
}

- (void)performQueries:(NSArray<PFQuery*>*) queries withAgeDiff: (int)ageDiff andRatingDiff: (int)ratingDiff {
    
    int index = [self calculateIndexwithAgeDiff:ageDiff andRatingDiff:ratingDiff];
    NSMutableArray *thisBucket = self.suggestedPlayerBuckets[index];
    
    [queries[0] findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSMutableArray *resultingPlayer = [Player playersWithPFUserObjects:objects];
        [thisBucket addObjectsFromArray:resultingPlayer];
        
        [queries[1] findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            NSMutableArray *resultingPlayer = [Player playersWithPFUserObjects:objects];
            [thisBucket addObjectsFromArray:resultingPlayer];
            
            [queries[2] findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                NSMutableArray *resultingPlayer = [Player playersWithPFUserObjects:objects];
                [thisBucket addObjectsFromArray:resultingPlayer];
                
                [queries[3] findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    NSMutableArray *resultingPlayer = [Player playersWithPFUserObjects:objects];
                    [thisBucket addObjectsFromArray:resultingPlayer];
                    
                    self.bucketDump[index] = [NSNumber numberWithInt:[self.bucketDump[index] intValue] + 1];
                    
                    if ([self.bucketDump[index] intValue] == [self numOfQuadQueriesForThisBucket:index]) {
                        if (resultingPlayer.count == 0) {
                            self.bestBucket++;
                        } else if (index == self.bestBucket) {
                            [self bucketReady:index];
                        }
                    }
                }];
            }];
        }];
    }];
}

- (int)numOfQuadQueriesForThisBucket:(int) index {
    int numQuadQueries = 0;
    for (int i = 0; i <= index; i++) {
        for (int j = 0; j <= index; j++) {
            if (i + j == index) {
                numQuadQueries++;
            }
        }
    }
    return numQuadQueries;
}

-(void)bucketReady:(int)index {
    [self.activityIndicator stopAnimating];
    self.view.userInteractionEnabled = YES;
    
    [self.players addObjectsFromArray:self.suggestedPlayerBuckets[self.bestBucket]];
    [self.suggestedPlayerBuckets[self.bestBucket] removeAllObjects];
    
    self.currPlayer++;
    [self.suggestedview setPlayer:self.players[self.currPlayer]];
    
}

- (int)calculateIndexwithAgeDiff: (int)ageDiff andRatingDiff: (int)ratingDiff {
    PFUser *me = [PFUser currentUser];
    
    int myageDiffPref = [[me valueForKey:@"ageDiffSearch"] intValue];
    int myratingDiffPref = [[me valueForKey:@"ratingDiffSearch"] intValue];
    
    int ageDev = (ageDiff - myageDiffPref) / 3;
    int ratingDev = (ratingDiff - myratingDiffPref) / 200;
    
    return ageDev + ratingDev;
}

- (PFQuery*) baseQueryWithOccNum: (int)occurence {
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"objectId" notEqualTo:[[PFUser currentUser] objectId]];
    Court *court =[[PFUser currentUser] valueForKey:@"homeCourt"];
    [query whereKey:@"courts" equalTo:court];
    
    if ([[[PFUser currentUser] valueForKey:@"genderImport"] boolValue]== YES) {
        [query whereKey:@"gender" equalTo:[[PFUser currentUser] valueForKey:@"gender"]];
    }
    
    query.limit = 5;
    query.skip = 5 * (occurence - 1);
    
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

