//
//  MatchHistoryCell.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/24/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet PFImageView *pfpView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expLabel;
@property (weak, nonatomic) IBOutlet UILabel *setLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameLabel;

@property (nonatomic, strong) Match *match;

- (void) setMatch:(Match *)match;

@end

NS_ASSUME_NONNULL_END
