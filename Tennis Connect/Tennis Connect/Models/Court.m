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
@dynamic locationArray;
@dynamic objectID;

@synthesize coordinates;



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

// after grabbing from parse server
- (id)initWithPFObject:(PFObject *)postPF {
    self = [super init];
    
    self.name = [postPF objectForKey:@"name"];
    self.locationArray =[postPF objectForKey:@"coordinates"];
    // lat, long
    self.coordinates = CLLocationCoordinate2DMake([self.locationArray[0] doubleValue], [self.locationArray[1] doubleValue]);
    self.objectID = postPF.objectId;
    
    return self;
}

// after grabbing from foursquare
- (id)initWithDictionary:(NSDictionary*) court {
    self = [super init];
    
    self.name = court[@"name"];
    CLLocationDegrees lat = [court[@"location"][@"lat"] doubleValue];
    CLLocationDegrees lng = [court[@"location"][@"lng"] doubleValue];
    self.locationArray = @[[NSNumber numberWithDouble:lat], [NSNumber numberWithDouble:lng]];
    self.coordinates = CLLocationCoordinate2DMake(lat, lng);
    self.objectID = @"";
    
    return self;
}





@end
