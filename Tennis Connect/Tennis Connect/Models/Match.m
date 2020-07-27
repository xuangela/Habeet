//
//  Match.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/14/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "Match.h"
#import "PFObject+Subclass.h"

@implementation Match

@dynamic sender;
@dynamic receiver;
@dynamic court;
@dynamic updatedAt;
@dynamic confirmed;
@dynamic completed;
@dynamic score;


+ (NSString*)parseClassName {
    return @"Match";
}

+ (NSMutableArray *)matchesWithArray: (NSArray<PFObject *> *)matches  {
    NSMutableArray *matchArray = [[NSMutableArray alloc] init];
    
    for (PFObject *match in matches) {
        Match *thisMatch = [[Match alloc] initWithPFObject:match];
        [matchArray addObject:thisMatch];
    }
    return matchArray;
}

- (id)initWithPFObject:(PFObject *)matchPF {
    self = [super init];
    
    self.sender = [matchPF objectForKey:@"sender"];
    self.receiver = [matchPF objectForKey:@"receiver"];
    self.court = [matchPF objectForKey:@"court"];
    self.objectId = matchPF.objectId;
    self.updatedAt = matchPF.updatedAt;
    
    self.completed = [[matchPF valueForKey:@"completed"] boolValue];
    self.confirmed = [[matchPF valueForKey:@"confirmed"] boolValue];
    
    return self;
}


@end
