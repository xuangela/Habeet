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

    return playerArray;
}

+ (NSMutableArray<Player*> *)playersWithPFUserFromSet: (NSMutableSet<PFUser *> *)users {
    NSMutableArray *playerArray = [[NSMutableArray alloc] init];
    
    for (PFUser *player in users) {
        Player *thisPlayer = [[Player alloc] initWithPFUser:player];
        [playerArray addObject:thisPlayer];
    }

    return playerArray;
}

- (id)initWithPFUser:(PFUser *)userPF {
    self = [super init];
    
    self.objectId = userPF.objectId;
    self.name = [userPF valueForKey:@"name"];
    self.age =[[userPF valueForKey:@"age"] yearsAgo];
    self.rating = [userPF valueForKey:@"rating"];
    self.gender = [userPF valueForKey:@"gender"];
    self.user = userPF;
    self.pfp = [userPF objectForKey:@"picture"];
    
    return self;
}

@end
