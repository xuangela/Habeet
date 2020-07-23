//
//  MatchReqCell.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/22/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "MatchReqCell.h"

@implementation MatchReqCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void) setMatch:(Match *)match {
    if (match.confirmed) {
        self.statusLabel.text = @"Upcoming match";
    }
    
    if ([match.receiver.objectId isEqualToString:[PFUser currentUser].objectId]) { // if the receiver is me
        self.statusLabel.text = @"Incoming request";
        self.contactLabel.text = [match.sender objectForKey:@"contact"];
        int exp = [[match.sender objectForKey:@"experience"] intValue];
        
        if (exp == 0) {
            self.expLabel.text = @"beginner";
        }else if (exp == 1) {
            self.expLabel.text = @"intermediate";
        } else if (exp == 2) {
            self.expLabel.text = @"experienced";
        }
        
        self.nameLabel.text = [match.sender objectForKey:@"name"];
        
        if ([match.sender valueForKey:@"picture"]) {
            self.pfpView.file = [match.sender valueForKey:@"picture"];
            [self.pfpView loadInBackground];
        }
    } else {
        self.statusLabel.text = @"Incoming request";
        self.contactLabel.text = [match.receiver objectForKey:@"contact"];
        int exp = [[match.receiver objectForKey:@"experience"] intValue];
        
        if (exp == 0) {
            self.expLabel.text = @"beginner";
        }else if (exp == 1) {
            self.expLabel.text = @"intermediate";
        } else if (exp == 2) {
            self.expLabel.text = @"experienced";
        }
        
        self.nameLabel.text = [match.receiver objectForKey:@"name"];
        
        if ([match.receiver valueForKey:@"picture"]) {
            self.pfpView.file = [match.receiver valueForKey:@"picture"];
            [self.pfpView loadInBackground];
        }
    }
    
}

@end
