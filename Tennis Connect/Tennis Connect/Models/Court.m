//
//  Court.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/14/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "Court.h"
#import "Player.h"
#import "PFObject+Subclass.h"

@import Parse;

@implementation Court

@dynamic name;
@dynamic lat;
@dynamic lng;

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

+ (void) courtInParseAndAddRelations: (NSArray<Court *> *)dictionaries withBlock:(void (^)(void))block {
    for (int i = 0; i < dictionaries.count; i++) {
        Court *court = dictionaries[i];
        PFQuery *query = [Court query];
        [query whereKey:@"lat" equalTo:court.lat];
        [query whereKey:@"lng" equalTo:court.lng];
        [query whereKey:@"name" equalTo:court.name];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (error) {
                if (error.code == 101) {
                    [court saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if (succeeded) {
                            PFRelation *relation = [[PFUser currentUser] relationForKey:@"courts"];
                            [relation addObject:court];
                            
                            if (i == 0) {
                                [PFUser currentUser][@"homeCourt"] = court;
                            }
                            
                            [[PFUser currentUser] saveInBackground];
                        }
                    }];
                } else {
                    NSLog (@"%@", error);
                }
            } else {
                PFRelation *relation = [[PFUser currentUser] relationForKey:@"courts"];
                [relation addObject:object];
                court.objectId = object.objectId;
                
                if (i == 0) {
                    [PFUser currentUser][@"homeCourt"] = object;
                }
                
                [[PFUser currentUser] saveInBackground];
            }
            
            if (i == dictionaries.count - 1) {
                block();
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
    self.objectId = postPF.objectId;
    
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
    
    return self;
}

@end
