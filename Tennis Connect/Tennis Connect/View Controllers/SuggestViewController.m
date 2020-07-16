//
//  SuggestViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/16/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "SuggestViewController.h"
#import "Court.h"
@import Parse;

@interface SuggestViewController ()

@property (nonatomic, strong) NSArray<Court*> *courts;
@property (nonatomic, strong) NSArray<PFUser*> *players;

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.courts = [defaults objectForKey:@"courts"];
    
    [self findUsers];
}

-(void) findUsers {
    NSMutableArray<PFQuery*> *queries = [[NSMutableArray alloc] init];
    for (Court* court in self.courts) {
        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        
        //add other constraints if present in user settings
        
        [query whereKey:@"courts" equalTo:court];
        [queries addObject:query];
    }
    
    PFQuery *aggregatedQuery = [PFQuery orQueryWithSubqueries:queries];
    
    [aggregatedQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.players = [NSArray arrayWithArray:objects];
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
