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

@dynamic  sender;
@dynamic receiver;
@dynamic court;
@dynamic time;
@dynamic confirmed;
@dynamic completed;
@dynamic score;


+ (NSString*)parseClassName {
    return @"Match";
}

@end
