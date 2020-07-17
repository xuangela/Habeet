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
@import Parse;

@interface SuggestViewController () <MapViewControllerDelegate>

@end

@implementation SuggestViewController

@synthesize players;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void) findUsers:(PFObject *) court {
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" notEqualTo:[[PFUser currentUser] objectId]];
    
    //add other constraints if present in user settings
    
    [query whereKey:@"courts" equalTo:court];
    
//    if (court.objectId == nil) {
//        [court saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//                NSLog(@"which path");
//                if (error) {
//                    NSLog(@"%@", error.localizedDescription);
//                } else {
//                    [self.players addObjectsFromArray:objects];
//                }
//            }];
//        }];
//    } else {
//        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//            NSLog(@"which path");
//            if (error) {
//                NSLog(@"%@", error.localizedDescription);
//            } else {
//                [self.players addObjectsFromArray:objects];
//            }
//        }];
//    }
    
    [court saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            NSLog(@"which path");
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            } else {
                [self.players addObjectsFromArray:objects];
            }
        }];
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

