//
//  Message.m
//  Tennis Connect
//
//  Created by Angela Xu on 8/6/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "Message.h"

@implementation Message

@dynamic receiver;
@dynamic sender;
@dynamic timeLogged;
@dynamic isReceived;
@dynamic msg;

+ (NSString *) parseClassName{
    return @"Message";
}

+ (NSMutableArray *)messagesWithArray: (NSArray<PFObject *> *)messages {
    NSMutableArray *msgArray = [[NSMutableArray alloc] init];
    
    for (PFObject *msg in messages) {
        Message *thisMsg = [[Message alloc] initWithPFObject:msg];
        [msgArray addObject:thisMsg];
    }
    return msgArray;
}


- (id)initWithPFObject:(PFObject *)msgPF {
    self = [super init];
    
    self.receiver = [msgPF objectForKey:@"receiver"];
    self.sender =[msgPF objectForKey:@"sender"];
    self.msg =[msgPF objectForKey:@"msg"];
    
    self.objectId = msgPF.objectId;
    self.timeLogged = msgPF.updatedAt;
    
    if ([self.receiver.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.isReceived = YES;
    } else {
        self.isReceived = NO;
    }
    
    return self;
}

- (void)addToParse {
    Message *newMessage = [Message object];
    newMessage.sender = [PFUser currentUser];
    newMessage.receiver = self.receiver;
    newMessage.msg = self.msg;
    
    [newMessage saveInBackground];
}

- (id)initFromText:(NSString*) content WithReceiver:(PFUser*) them {
    self = [super init];

    self.receiver = them;
    self.sender =[PFUser currentUser];
    self.msg =content;
    self.timeLogged = [NSDate date];

    self.isReceived = NO; 

    return self;
}
 
- (id)initNewMessageWithUser:(Player*) player {
    self = [super init];

    self.receiver = player.user;
    self.sender =[PFUser currentUser];

    return self;
}


@end
