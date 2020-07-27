//
//  MatchHistoryCell.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/24/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "MatchHistoryCell.h"
#import "NSDate+DateTools.h"

@implementation MatchHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMatch:(Match *)match {

//    @property (weak, nonatomic) IBOutlet UILabel *setLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *gameLabel;
    
    
    _match = match;
    
    PFUser *opponent;
     if ([match.receiver.objectId isEqualToString:[PFUser currentUser].objectId]) {
         opponent = match.sender;
     } else {
         opponent = match.receiver;
     }
    
    if ([opponent valueForKey:@"picture"]) {
        self.pfpView.file = [opponent valueForKey:@"picture"];
        [self.pfpView loadInBackground];
    }
    
    self.nameLabel.text = [opponent objectForKey:@"name"];
    
    NSDate *playedDate = match[@"updatedAt"];

    self.dateLabel.text = [playedDate formattedDateWithStyle:NSDateFormatterFullStyle];
    
    
    int exp = [[opponent objectForKey:@"experience"] intValue];
    if (exp == 0) {
        self.expLabel.text = @"beginner";
    }else if (exp == 1) {
        self.expLabel.text = @"intermediate";
    } else if (exp == 2) {
        self.expLabel.text = @"experienced";
    }
    
    
    
}

@end
