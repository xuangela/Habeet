//
//  ChatRoomCell.h
//  Tennis Connect
//
//  Created by Angela Xu on 8/6/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGChatViewController.h"
#import "Player.h"
#import "Message.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomCell : UITableViewCell <ChatDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *pfpview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic, strong) Player* player;
@property (nonatomic, strong) Message* msg;

- (void)sentMessage;

@end

NS_ASSUME_NONNULL_END
