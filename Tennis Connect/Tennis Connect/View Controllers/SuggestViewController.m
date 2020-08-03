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
@property (nonatomic, assign) int completedBuckets;
@property (nonatomic, assign) BOOL specializedRefilling;
@property (nonatomic, strong) NSMutableArray<NSNumber *>* bucketDump;
@property (nonatomic, strong) NSMutableArray *fetchOccurences;

@end

@implementation SuggestViewController

@synthesize players;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.specializedRefilling = NO;
    self.currPlayer = -1;
    self.bestBucket = 0;
    self.completedBuckets = 0;

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
    self.fetchOccurences = [[NSMutableArray alloc] init];
    self.bucketDump = [[NSMutableArray alloc] init];
    self.players =[[NSMutableArray alloc] init];
    
    int myageDiffPref = [[[PFUser currentUser] valueForKey:@"ageDiffSearch"] intValue];
    int myratingDiffPref = [[[PFUser currentUser] valueForKey:@"ratingDiffSearch"] intValue];
    int numBuckets = ((15 - myageDiffPref) / 3) + ((1000 - myratingDiffPref) / 200) + 1;
    
    for (int i = 0; i < numBuckets; i++) {
        NSMutableArray<Player*> *newBucket = [[NSMutableArray alloc] init];
        [self.suggestedPlayerBuckets addObject:newBucket];
        [self.fetchOccurences addObject:@0];
        [self.bucketDump addObject:@0];
    }
}

- (void) fetchPlayers {
    PFUser *me = [PFUser currentUser];
    
    int myageDiffPref = [[me valueForKey:@"ageDiffSearch"] intValue];
    int myratingDiffPref = [[me valueForKey:@"ratingDiffSearch"] intValue];
    
    for (int ageDiff = myageDiffPref; ageDiff <= 15; ageDiff+= 3) {
        for (int ratingDiff = myratingDiffPref; ratingDiff <= 1000; ratingDiff+= 200) {
            if (self.specializedRefilling) {
                if ([self calculateIndexwithAgeDiff:ageDiff andRatingDiff:ratingDiff] == self.bestBucket) {
                    [self allQueriesForAgeDiff:ageDiff andRatingDiff:ratingDiff];
                }
            } else {
                [self allQueriesForAgeDiff:ageDiff andRatingDiff:ratingDiff];
            }
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
    NSDate* prevLatestdobQuery= [mydob dateByAddingYears:prevAgeDiff];
    
    int myRating = [[me valueForKey:@"rating"] intValue];
    
    int smallestRating = (myRating - ratingDiff);
    int largestRating = (myRating + ratingDiff);
    
    int prevRatingDiff = (ratingDiff - myratingDiffPref) > 0 ? (ratingDiff - 200)  : 0;
    int prevSmallestRating = (myRating - prevRatingDiff);
    int prevLargestRating = (myRating + prevRatingDiff);
    
    int index = [self calculateIndexwithAgeDiff:ageDiff andRatingDiff:ratingDiff];
    int numOcc = [self.fetchOccurences[index] intValue];
    
    PFQuery *query1 = [self baseQueryWithOccNum:numOcc]; // age+ rating+
    PFQuery *query2 = [self baseQueryWithOccNum:numOcc]; // age+ rating-
    PFQuery *query3 = [self baseQueryWithOccNum:numOcc]; // age- rating+
    PFQuery *query4 = [self baseQueryWithOccNum:numOcc]; // age- rating-
    
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
                    
                    int newBucketDumpVal =([self.bucketDump[index] intValue] + 1);
                    self.bucketDump[index] = [NSNumber numberWithInt:newBucketDumpVal];
                    NSLog(@"bucket %d in process", index);
                    
                    if (newBucketDumpVal == [self numOfQuadQueriesForThisBucket:index]) {
                        NSLog(@"bucket %d done", index);
                        self.completedBuckets++;
                        
                        int newFetchOccurences =[self.fetchOccurences[index] intValue] + 1;
                        self.fetchOccurences[index] =  [NSNumber numberWithInt:newFetchOccurences];
                        self.bucketDump[index] = @0;
                        
                        int myageDiffPref = [[[PFUser currentUser] valueForKey:@"ageDiffSearch"] intValue];
                        int myratingDiffPref = [[[PFUser currentUser] valueForKey:@"ratingDiffSearch"] intValue];
                        int numBuckets = ((15 - myageDiffPref) / 3) + ((1000 - myratingDiffPref) / 200) + 1;
                        
                        if (self.specializedRefilling || self.completedBuckets == numBuckets) {
                            [self findNextBucket];
                            
                            [self bucketReady:self.bestBucket];
                            self.currPlayer++;
                            [self.suggestedview setPlayer:self.players[self.currPlayer]];
                            
                            self.completedBuckets = 0;
                        }
                    }
                }];
            }];
        }];
    }];
}

- (void)findNextBucket {
    while (self.suggestedPlayerBuckets[self.bestBucket].count == 0) {
        self.bestBucket++;
    }
}

- (int)numOfQuadQueriesForThisBucket:(int) index {
    
    PFUser *me = [PFUser currentUser];
    
    int myageDiffPref = [[me valueForKey:@"ageDiffSearch"] intValue];
    int myratingDiffPref = [[me valueForKey:@"ratingDiffSearch"] intValue];
    
    int numQuadQueries = 0;
    for (int ageDiff = myageDiffPref; ageDiff <= 15; ageDiff+= 3) {
        for (int ratingDiff = myratingDiffPref; ratingDiff <= 1000; ratingDiff+= 200) {
            if ([self calculateIndexwithAgeDiff:ageDiff andRatingDiff:ratingDiff] == index) {
                numQuadQueries++;
            }
        }
    }
    
    return numQuadQueries;
}

-(void)bucketReady:(int)index {
    [self.activityIndicator stopAnimating];
    self.view.userInteractionEnabled = YES;
    while (self.bestBucket < self.suggestedPlayerBuckets.count && self.suggestedPlayerBuckets[self.bestBucket].count < 5) {
        [self.players addObjectsFromArray:self.suggestedPlayerBuckets[self.bestBucket]];
        [self.suggestedPlayerBuckets[self.bestBucket] removeAllObjects];
        self.bestBucket++;
    }
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
    query.skip = 5 * (occurence);
    
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
    
    if (self.players.count - self.currPlayer < 5 && self.bestBucket < self.suggestedPlayerBuckets.count) {
        self.specializedRefilling = YES;
        [self fetchPlayers];
    }
    
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

