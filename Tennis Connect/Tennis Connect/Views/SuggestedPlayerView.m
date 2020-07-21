//
//  SuggestedPlayerView.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/21/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "SuggestedPlayerView.h"



@implementation SuggestedPlayerView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void) customInit {
    [[NSBundle mainBundle] loadNibNamed:@"SuggestedPlayer" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
}

- (void) setPlayer:(Player *)player {
    _player = player;
    
    self.nameLabel.text = player.name;
    
    if ([player.experience intValue]== 0) {
        self.experienceLevel.text = @"beginner";
    }else if ([player.experience intValue]== 1) {
        self.experienceLevel.text = @"intermediate";
    } else if ([player.experience intValue]== 2) {
        self.experienceLevel.text = @"experienced";
    }
    
    if (player.pfp) {
        self.pfpView.file = player.pfp;
        [self.pfpView loadInBackground];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
