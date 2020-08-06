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
    self.objectId = msgPF.objectId;
    
    return self;
}



@end
