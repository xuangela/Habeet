//
//  User.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/14/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Court.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface User:PFUser<PFSubclassing>

@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSDate *dob;
@property (nonatomic, strong) NSNumber *experience;
@property (nonatomic, strong) PFFileObject *pfp;
@property (nonatomic, strong) NSString* username;

@property (nonatomic, strong) NSMutableArray<Court*> *courts;

+ (User*)user;

- (instancetype) initWithPF: (PFUser *) user;

@end

NS_ASSUME_NONNULL_END
