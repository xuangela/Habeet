//
//  LogScoreViewController.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/23/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LogScoreDelegate

@property (nonatomic, strong) NSMutableArray<Match *>* matches;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@interface LogScoreViewController : UIViewController

@property (nonatomic, strong) Match* match;
@property (nonatomic, weak) id<LogScoreDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
