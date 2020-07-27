//
//  Match.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/14/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Court.h"

NS_ASSUME_NONNULL_BEGIN

@interface Match : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *sender;
@property (nonatomic, strong) PFUser *receiver;
@property (nonatomic, strong) Court *court;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, assign) BOOL confirmed;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, assign) NSArray<NSString *> *score;


+ (NSString*)parseClassName;
+ (NSMutableArray *)matchesWithArray: (NSArray<PFObject *> *)matches;

- (id)initWithPFObject:(PFObject *)matchPF;

@end

NS_ASSUME_NONNULL_END
