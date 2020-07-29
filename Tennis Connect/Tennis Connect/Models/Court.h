//
//  Court.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/14/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Player.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface Court : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) NSNumber *lat;
@property (nonatomic, assign) NSNumber *lng;

@property (nonatomic, assign) CLLocationCoordinate2D coordinates;

+ (NSString *) parseClassName;
+ (NSMutableArray *)courtsWithDictionaries: (NSArray<Court *> *)dictionaries;
+ (void) courtInParseAndAddRelations: (NSArray<Court *> *)dictionaries withBlock:(void (^)(void))block;

- (id)initWithPFObject:(PFObject *)postPF;
- (id)initWithDictionary:(NSDictionary*) court;

@end

NS_ASSUME_NONNULL_END
