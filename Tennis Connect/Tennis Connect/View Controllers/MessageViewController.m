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

@property (nonatomic, strong) NSMutableSet *messageRoomsPF;
@property (nonatomic, strong) NSMutableArray<Player*> *messageRooms;

@property (nonatomic, assign) int fetchOcc;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableSetUp];
    [self getExistingMsgs];
}

- (void)getExistingMsgs {
    
    self.messageRoomsPF = [[NSMutableSet alloc] init];
    
    PFUser *me = [PFUser currentUser];
    PFRelation *relation = [me relationForKey:@"messaging"];
    PFQuery *query = [relation query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [self.messageRoomsPF addObjectsFromArray:objects];
        }
        
        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        [query whereKey:@"messaging" equalTo:me];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                [self.messageRoomsPF addObjectsFromArray:objects];
                
                self.messageRooms = [Player playersWithPFUserFromSet:self.messageRoomsPF];
                NSLog(@"got all existing chat rooms");
                
                [self.tableview reloadData];
            }
        }];
    }];
}

#pragma mark - Table Set Up

- (void)tableSetUp {
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.messageRooms.count > 0) {
        return self.messageRooms.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.messageRooms.count > 0) {
        ChatRoomCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"ChatRoomCell"];

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
            
        viewController.possibleChatsPF = [NSMutableSet setWithSet:self.messageRoomsPF];
    }
}


@end
