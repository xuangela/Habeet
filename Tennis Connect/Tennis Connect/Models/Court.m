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
@dynamic lat;
@dynamic lng;
@dynamic objectID;

@synthesize coordinates;


+ (NSMutableArray *)courtsWithDictionaries: (NSArray<Court *> *)dictionaries { 
    NSMutableArray *courtArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *court in dictionaries) {
        Court *thiscourt = [[Court alloc] initWithDictionary:court];
        [courtArray addObject:thiscourt];
    }
    
    return courtArray;
}

+ (NSMutableArray *)courtsWithRelation: (NSArray<PFObject *> *)relations {
    NSMutableArray *courtArray = [[NSMutableArray alloc] init];
    
    for (PFObject *court in relations) {
        Court *thiscourt = [[Court alloc] initWithPFObject:court];
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
    self.lat =[postPF objectForKey:@"lat"];
    self.lng =[postPF objectForKey:@"lng"];
    self.coordinates = CLLocationCoordinate2DMake([self.lat doubleValue], [self.lng doubleValue]);
    self.objectID = postPF.objectId;
    
    return self;
}

// after grabbing from foursquare
- (id)initWithDictionary:(NSDictionary*) court {
    self = [super init];
    
    self.name = court[@"name"];
    double latNum = [court[@"location"][@"lat"] doubleValue];
    double lngNum = [court[@"location"][@"lng"] doubleValue];
    self.lat = [NSNumber numberWithDouble:latNum];
    self.lng = [NSNumber numberWithDouble:lngNum];
    self.coordinates = CLLocationCoordinate2DMake(latNum, lngNum);
    self.objectID = @"";
    
    return self;
}





@end
