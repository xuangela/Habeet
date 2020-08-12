//
//  Message.h
//  Tennis Connect
//
//  Created by Angela Xu on 8/6/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface Message : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *sender;
@property (nonatomic, strong) PFUser *receiver;
@property (nonatomic, strong) NSString* msg; 
@property (nonatomic, strong) NSDate *timeLogged;
@property (nonatomic, assign) BOOL isReceived; 

+ (NSString *) parseClassName;
+ (NSMutableArray *)messagesWithArray: (NSArray<PFObject *> *)messages;

- (id)initWithPFObject:(PFObject *)msgPF;
- (id)initFromText:(NSString*) content WithReceiver:(PFUser*) them;
- (id)initNewMessageWithUser:(Player*) player;
- (void)addToParse;

@end

NS_ASSUME_NONNULL_END
