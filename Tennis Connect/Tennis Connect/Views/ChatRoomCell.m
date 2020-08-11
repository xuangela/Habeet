//
//  ChatRoomCell.m
//  Tennis Connect
//
//  Created by Angela Xu on 8/6/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "ChatRoomCell.h"

@implementation ChatRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

- (void)setMsg:(Message *)msg {
    _msg = msg;
    
    if ([msg.receiver.objectId isEqualToString:[PFUser currentUser].objectId]) {
        msg.isReceived = YES;
    } else {
        msg.isReceived = NO; 
    }
    
    if (msg.isReceived) {
        _player = [[Player alloc] initWithPFUser:msg.sender];
    } else {
        _player = [[Player alloc] initWithPFUser:msg.receiver];
    }
    
    if (self.player.pfp) {
        self.pfpview.file = self.player.pfp;
        [self.pfpview loadInBackground];
    }
    
    self.nameLabel.text = self.player.name;
    self.timestampLabel.text = [self getDateTimeStringFromNSDate:msg.timeLogged];
    self.messageLabel.text = msg.msg;
}

- (NSString*)getDateTimeStringFromNSDate: (NSDate*)date {
    NSString *dateTimeString = @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM, hh:mm a"];
    dateTimeString = [dateFormatter stringFromDate:date];
    
    return dateTimeString;
}
@end
