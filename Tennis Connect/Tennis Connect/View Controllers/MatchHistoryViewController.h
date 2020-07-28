//
//  MatchHistoryViewController.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/24/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface MatchHistoryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray<Match* >* completedMatches;

@end

NS_ASSUME_NONNULL_END
