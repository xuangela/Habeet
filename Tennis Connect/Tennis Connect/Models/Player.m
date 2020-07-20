//
//  Player.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/17/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "Player.h"
#import <DateTools/DateTools.h>

@implementation Player

+ (NSArray *)playersWithPFUserObjects: (NSArray<PFUser *> *)dictionaries  {
    NSMutableArray *playerArray = [[NSMutableArray alloc] init];
    
    for (PFUser *player in dictionaries) {
        Player *thisPlayer = [[Player alloc] initWithPFUser:player];
        [playerArray addObject:thisPlayer];
    }
    return playerArray;
}


+ (PFQuery*) queryForFindingPlayersForCourt:(PFObject *) court {
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" notEqualTo:[[PFUser currentUser] objectId]];
    
    //add other constraints if present in user settings
    
    [query whereKey:@"courts" equalTo:court];
    
    return query;
}


- (id)initWithPFUser:(PFUser *)userPF {
    self = [super init];
    
    self.objectId = userPF.objectId;
    self.name = [userPF valueForKey:@"name"];
    self.age =[[userPF valueForKey:@"age"] yearsAgo];
    self.experience = [userPF valueForKey:@"experience"];
    self.gender = [userPF valueForKey:@"gender"];
    self.user = userPF;
    self.pfp = [userPF objectForKey:@"picture"];
    
    return self;
}





@end
