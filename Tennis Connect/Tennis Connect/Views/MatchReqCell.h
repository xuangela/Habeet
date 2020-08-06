//
//  MatchReqCell.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/22/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"
@import MaterialComponents;

NS_ASSUME_NONNULL_BEGIN

@protocol ReqCellDelegate

@property (nonatomic, strong) NSMutableArray<Match *>* matches;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@interface MatchReqCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *pfpView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet MDCButton *confirmButton;
@property (weak, nonatomic) IBOutlet MDCButton *deleteButton;

@property (nonatomic, strong) Match* match;
@property (nonatomic, weak) id<ReqCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
