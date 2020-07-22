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

+ (NSMutableArray<Player*> *)playersWithPFUserObjects: (NSArray<PFUser *> *)dictionaries  {
    NSMutableArray *playerArray = [[NSMutableArray alloc] init];
    
    for (PFUser *player in dictionaries) {
        Player *thisPlayer = [[Player alloc] initWithPFUser:player];
        [playerArray addObject:thisPlayer];
    }
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"compatibility" ascending:NO];
    [playerArray sortUsingDescriptors:@[sd]];
    
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
    
    // complex algorithm, what do I want to include
    int randFactor = arc4random() % 50;
    long myAge =[[[PFUser currentUser] valueForKey:@"age"] yearsAgo];
    long ageFactor = 25 - labs(self.age - myAge);
    long myExp = [[[PFUser currentUser] valueForKey:@"experience"] intValue];
    long experienceFactor = 20 - 10 * labs([self.experience intValue] - myExp);
    NSString *myGender = [[PFUser currentUser] valueForKey:@"gender"];
    int genderFactor = [myGender isEqualToString:self.gender] ? 12 : -10;
    
    self.compatibility = randFactor + ageFactor + experienceFactor + genderFactor;
    
    
    return self;
}





@end