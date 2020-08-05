//
//  SuggestedPlayerView.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/21/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "SuggestedPlayerView.h"

@implementation SuggestedPlayerView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
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
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
}

- (void) setPlayer:(Player *)player {
    _player = player;
    
    self.nameLabel.text = player.name;
    
    int exp = [player.rating intValue];
    NSString *rating =[NSString stringWithFormat: @"%d", exp];
    
    if (exp <= 500) {
        rating = [rating stringByAppendingString:@"   beginner"];
    } else if (exp <= 1000) {
        rating = [rating stringByAppendingString:@"   intermediate"];
    } else {
        rating = [rating stringByAppendingString:@"   experienced"];
    }
    
    self.experienceLevel.text = rating;
    
    if (player.pfp) {
        self.pfpView.file = player.pfp;
        [self.pfpView loadInBackground];
    }
    
    self.nameLabel.alpha = 0;
    self.experienceLevel.alpha = 0;
    self.pfpView.alpha = 0;
    
    [UIView animateWithDuration:.5 animations:^{
        self.nameLabel.alpha = 1;
        self.experienceLevel.alpha = 1;
        self.pfpView.alpha = 1;
    }];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
