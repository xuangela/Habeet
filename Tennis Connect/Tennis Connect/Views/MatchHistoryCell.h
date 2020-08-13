//
//  MatchHistoryCell.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/24/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN


@protocol HistoryCellDelegate

- (void)updateRating:(int)rating; 

@end

@interface MatchHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet PFImageView *pfpView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expLabel;
@property (weak, nonatomic) IBOutlet UILabel *setLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameLabel;
@property (weak, nonatomic) IBOutlet UIButton *validationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setScoreTopConstraint;

@property (nonatomic, strong) Match *match;
@property (nonatomic, strong) PFUser *opponent;
@property (nonatomic, assign) BOOL isReceiver;
@property (nonatomic, assign) BOOL iWon;

@property (nonatomic, weak) id<HistoryCellDelegate> delegate;

- (void) setMatch:(Match *)match;

@end

NS_ASSUME_NONNULL_END
