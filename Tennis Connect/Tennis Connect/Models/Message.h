//
//  Message.h
//  Tennis Connect
//
//  Created by Angela Xu on 8/6/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface Message : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *sender;
@property (nonatomic, strong) PFUser *receiver;

+ (NSString *) parseClassName;
+ (NSMutableArray *)messagesWithArray: (NSArray<PFObject *> *)messages;

- (id)initWithPFObject:(PFObject *)msgPF;

@end

NS_ASSUME_NONNULL_END
