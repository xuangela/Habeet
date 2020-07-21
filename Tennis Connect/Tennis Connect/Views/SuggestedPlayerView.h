//
//  SuggestedPlayerView.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/21/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

NS_ASSUME_NONNULL_BEGIN

@interface SuggestedPlayerView :UIView

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet PFImageView *pfpView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *experienceLevel;

@property (nonatomic, strong) Player *player;

@end

NS_ASSUME_NONNULL_END
