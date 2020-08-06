//
//  PossibleChatCell.m
//  Tennis Connect
//
//  Created by Angela Xu on 8/6/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "PossibleChatCell.h"
#import "Player.h"
@import Parse;

@implementation PossibleChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPlayer:(Player *)player {
    _player = player;
    
    if (player.pfp) {
        self.pfpView.file = player.pfp;
        [self.pfpView loadInBackground];
    }
    
    self.nameLabel.text = player.name;
    
    int exp = [player.rating intValue];
    self.ratingLabel.text = [NSString stringWithFormat:@"%d", exp];
    
    if (exp <= 500) {
        self.experienceLabel.text = @"Beginner";
    } else if (exp <= 1000) {
        self.experienceLabel.text = @"Intermediate";
    } else {
        self.experienceLabel.text = @"Experienced";
    }
}

@end
