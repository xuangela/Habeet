//
//  AGChatViewController.h
//  AGChatView
//
//  Created by Ashish Gogna on 09/04/16.
//  Copyright © 2016 Ashish Gogna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"


@protocol ChatDelegate

@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@interface AGChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) Player* player;
@property (nonatomic, weak) id<ChatDelegate> delegate;
@property (nonatomic, assign) BOOL newRoom; 

@end
