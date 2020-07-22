//
//  MatchRequestViewController.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/21/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Court.h"

NS_ASSUME_NONNULL_BEGIN


@interface MatchRequestViewController : UIViewController

@property (nonatomic, strong) NSArray<Court *> *courts;
@property (nonatomic, strong) Player *player;

- (void) findSharedCourts;

@end

NS_ASSUME_NONNULL_END
