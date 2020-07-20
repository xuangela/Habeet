//
//  SuggestViewController.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/16/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Court.h"

NS_ASSUME_NONNULL_BEGIN

@interface SuggestViewController : UIViewController

@property (nonatomic, strong) NSArray<Court *> *courts;
@property (nonatomic, strong) NSArray<PFUser*> *players;

- (void) findUsersWithQueries:(NSArray<PFQuery*> *) playerQueries;

@end

NS_ASSUME_NONNULL_END
