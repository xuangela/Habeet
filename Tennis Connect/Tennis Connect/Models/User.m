//
//  User.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/14/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "User.h"
#import "PFObject+Subclass.h"
@import Parse;

@implementation User

@dynamic objectID;
@dynamic name;
@dynamic gender;
@dynamic contact;
@dynamic dob;
@dynamic experience;
@dynamic pfp;
@dynamic username;

@synthesize courts;

+(User*)user {
    return (User*)[PFUser user];
}

- (instancetype) initWithPF: (PFUser *) user {
    self = [super init];
    
    self.objectID = user.objectId;
    self.name = [user objectForKey:@"name"];
    self.gender = [user objectForKey:@"gender"];
    self.contact = [user objectForKey:@"contact"];
    self.dob = [user objectForKey:@"age"];
    self.experience = [user objectForKey:@"experience"];
    self.pfp = [user objectForKey:@"picture"];
    self.username = [user objectForKey:@"username"];
    
    PFRelation *relation = [self relationForKey:@"courts"];
    PFQuery *query = [relation query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.courts = [Court courtsWithRelation:objects];
    }];
    
    return self;
}

@end
