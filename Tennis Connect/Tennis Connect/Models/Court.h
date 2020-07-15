//
//  Court.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/14/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface Court : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) NSNumber *lat;
@property (nonatomic, assign) NSNumber *lng;
@property (nonatomic, strong) NSString *objectID;

@property (nonatomic, assign) CLLocationCoordinate2D coordinates;

+ (NSMutableArray *)courtsWithDictionaries: (NSArray *)dictionaries;
+ (NSMutableArray *)courtsWithRelation: (NSArray *)relations;
+ (NSString *) parseClassName; 

- (id)initWithPFObject:(PFObject *)postPF;
- (id)initWithDictionary:(NSDictionary*) court;

@end

NS_ASSUME_NONNULL_END
