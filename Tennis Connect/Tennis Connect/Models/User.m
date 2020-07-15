//
//  User.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/14/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "User.h"
#import "PFObject+Subclass.h"

@implementation User

@dynamic objectID;
@dynamic name;
@dynamic gender;
@dynamic contact;
@dynamic dob;
@dynamic experience;
@dynamic pfp;
@dynamic courts;
@dynamic username;

+ (NSString*)parseClassName {
    return @"User";
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
    
    return self;
}

@end
