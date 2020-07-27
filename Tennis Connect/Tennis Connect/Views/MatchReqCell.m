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
    self.confirmButton.alpha = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void) setMatch:(Match *)match {
    _match = match;
    
    PFUser *opponent;
     if ([match.receiver.objectId isEqualToString:[PFUser currentUser].objectId]) {
         opponent = match.sender;
         self.statusLabel.text = @"Incoming request";
         self.confirmButton.alpha = 1;
     } else {
         opponent = match.receiver;
         self.statusLabel.text = @"Outgoing request";
     }
    
    self.contactLabel.text = [opponent objectForKey:@"contact"];
    
    int exp = [[opponent objectForKey:@"experience"] intValue];
    if (exp == 0) {
           self.expLabel.text = @"beginner";
       }else if (exp == 1) {
           self.expLabel.text = @"intermediate";
       } else if (exp == 2) {
           self.expLabel.text = @"experienced";
       }
    
    self.nameLabel.text = [opponent objectForKey:@"name"];
    
    if ([opponent valueForKey:@"picture"]) {
        self.pfpView.file = [opponent valueForKey:@"picture"];
        [self.pfpView loadInBackground];
    }

    
    if (match.confirmed) {
        self.statusLabel.text = @"Upcoming match";
        self.confirmButton.alpha = 0;
    }
    
   
    self.accessoryType = UITableViewCellAccessoryNone;
    
}



- (IBAction)tapConfirm:(id)sender {
    self.statusLabel.text =@"Upcoming match";
    self.match.confirmed = YES;
    self.confirmButton.alpha = 0; 
    
    PFQuery *query = [Match query];
    
    [query getObjectInBackgroundWithId:self.match.objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        object[@"confirmed"] = @YES;
        NSLog(@"updating database");
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            NSLog(@"added to the database");
        }];
        
    }];
}

@end
