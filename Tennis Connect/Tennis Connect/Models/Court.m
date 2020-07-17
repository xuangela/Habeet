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

+ (NSString *) parseClassName{
    return @"Court";
}

+ (NSMutableArray *)courtsWithDictionaries: (NSArray<Court *> *)dictionaries  {
    NSMutableArray *courtArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *court in dictionaries) {
        Court *thisCourt = [[Court alloc] initWithDictionary:court];
        [courtArray addObject:thisCourt];
    }
    return courtArray;
}

+ (void) courtInParseAndAddRelations: (NSArray<Court *> *)dictionaries withBlock: (void (^)(PFObject *))getUsers {
    for (Court *court in dictionaries) {
        PFQuery *query = [Court query];
        [query whereKey:@"lat" equalTo:court.lat];
        [query whereKey:@"lng" equalTo:court.lng];
        [query whereKey:@"name" equalTo:court.name];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (error) {
                if (error.code == 101) {
                    PFObject *newCourt = [Court new];
                    newCourt = court;
                    [newCourt saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if (succeeded) {
                            getUsers(newCourt);
                            PFRelation *relation = [[PFUser currentUser] relationForKey:@"courts"];
                            
                            [relation addObject:newCourt];
                            
                            [[PFUser currentUser] saveInBackground];
                        }
                    }];
                } else {
                    NSLog (@"%@", error);
                }
            } else {
                getUsers(object);
                PFRelation *relation = [[PFUser currentUser] relationForKey:@"courts"];
                [relation addObject:object];
                
                [[PFUser currentUser] saveInBackground];
            }
        }];
    }
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
