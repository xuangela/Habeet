//
//  MessageViewController.h
//  Tennis Connect
//
//  Created by Angela Xu on 8/6/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray<Message *> *displayingRooms;

- (void) addNewRoomWithUser: (Player*) user;



@end

NS_ASSUME_NONNULL_END
