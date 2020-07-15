//
//  Court.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/14/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "Court.h"
#import "PFObject+Subclass.h"
@import Parse;

@implementation Court

@dynamic name;
@dynamic location;
@dynamic objectID;

+ (NSMutableArray *)courtsWithDictionaries: (NSArray *)dictionaries { // each entry is a court
    NSMutableArray *courtArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *court in dictionaries) {
        Court *thiscourt = [[Court alloc] initWithDictionary:court];
        [courtArray addObject:thiscourt];
    }
    
    return courtArray;
}

+ (NSString *) parseClassName{
    return @"Court";
}

- (id)initWithPFObject:(PFObject *)postPF {
    self = [super init];
    
    self.name = [postPF objectForKey:@"name"];
    NSArray *coordArray =[postPF objectForKey:@"coordinates"];
    // lat, long
    self.location = CLLocationCoordinate2DMake([coordArray[0] doubleValue], [coordArray[1] doubleValue]);
    self.objectID = postPF.objectId;
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*) court {
    self = [super init];
    
    self.name = court[@"name"];
    CLLocationDegrees lat = [court[@"location"][@"lat"] doubleValue];
    CLLocationDegrees lng = [court[@"location"][@"lng"] doubleValue];
    self.location = CLLocationCoordinate2DMake(lat, lng);
    self.objectID = @"";
    
    return self;
}





@end
