//
//  MessageViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 8/6/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "MessageViewController.h"
#import "NewMsgViewController.h"
#import "Player.h"
#import "ChatRoomCell.h"
#import "EmptyCell.h"
#import "Message.h"

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableDictionary<NSString*, Message*> *uniqueRooms;
@property (nonatomic, strong) NSMutableArray<Message *> *displayingRooms;

@property (nonatomic, assign) int fetchOcc;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableSetUp];
    [self getExistingMsgs];
}

- (void)getExistingMsgs {
    self.uniqueRooms = [[NSMutableDictionary alloc] init];
    
    PFQuery *querySender = [Message query];
    [querySender whereKey:@"sender" equalTo:[PFUser currentUser]];
    [querySender orderByAscending:@"updatedAt"];
    [querySender includeKey:@"receiver"];
    
    [querySender findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            for (Message* msg in objects) {
                [self.uniqueRooms setObject:msg forKey:msg.receiver.objectId];
            }
        }
        
        PFQuery *queryReceiver = [Message query];
        [queryReceiver whereKey:@"receiver" equalTo:[PFUser currentUser]];
        [queryReceiver includeKey:@"sender"];
        [queryReceiver orderByAscending:@"updatedAt"];
        
        [queryReceiver findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                for (Message* msg in objects) {
                    [self.uniqueRooms setObject:msg forKey:msg.receiver.objectId];
                }
            }
            [self displayExistingRooms];
        }];
    }];
}

- (void)displayExistingRooms {
    self.displayingRooms = [[NSMutableArray alloc] init];
    for (NSString* playerId in [self.uniqueRooms allKeys]) {
        Message *thismsg = [self.uniqueRooms valueForKey:playerId];
        [self.displayingRooms addObject:thismsg];
    }
    [self.tableview reloadData];
}

#pragma mark - Table Set Up

- (void)tableSetUp {
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.displayingRooms.count > 0) {
        return self.displayingRooms.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.displayingRooms.count > 0) {
        ChatRoomCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"ChatRoomCell"];
        [cell setMsg:self.displayingRooms[indexPath.row]];
        
        return cell;
        
    } else {
        EmptyCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"EmptyCell"];
        cell.messageLabel.text = @"No messages to display.";
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"newMsgUsersSegue"]) {
        NewMsgViewController *viewController = [segue destinationViewController];
         
        NSMutableDictionary *possibleChat = [[NSMutableDictionary alloc] init];
    
        for (NSString* playerId in [self.uniqueRooms allKeys]) {
            Message *msg = [self.uniqueRooms valueForKey:playerId];
            if (msg.isReceived) {
                [possibleChat setObject:msg.sender forKey:playerId];
            } else {
                [possibleChat setObject:msg.receiver forKey:playerId];
            }
        }
        
    
        viewController.possibleRooms = possibleChat;
    }
}


@end
