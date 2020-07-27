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
    NSArray *scores = match.score; //sender, receiver
    
     if ([match.receiver.objectId isEqualToString:[PFUser currentUser].objectId]) {
         opponent = match.sender;
         int myScore = [scores[1] intValue] > [scores[0] intValue] ? 1:0;
         int theirScore = 1-myScore;
         NSString *gameScore = [scores[1] stringByAppendingFormat:@" - %@", scores[0]];
         if (scores[2] && scores[3]) {
             NSString *secondSetScores = [scores[3] stringByAppendingFormat:@" - %@", scores[2]];
             gameScore = [gameScore stringByAppendingFormat:@"    %@", secondSetScores];
             int addToMyScore =[scores[3] intValue] > [scores[2] intValue] ? 1:0;
             myScore += addToMyScore;
             theirScore += 1-addToMyScore;
         }
         if (scores[4] && scores[5]) {
             NSString *thirdSetScores = [scores[5] stringByAppendingFormat:@" - %@", scores[4]];
             gameScore = [gameScore stringByAppendingFormat:@"    %@", thirdSetScores];
             int addToMyScore =[scores[5] intValue] > [scores[4] intValue] ? 1:0;
             myScore += addToMyScore;
             theirScore += 1-addToMyScore;
         }
         self.gameLabel.text = gameScore;
         self.setLabel.text = [[NSString stringWithFormat:@"%d", myScore] stringByAppendingFormat:@" - %d", theirScore];
     } else {
         opponent = match.receiver;
         
         int myScore = [scores[0] intValue] > [scores[1] intValue] ? 1:0;
         int theirScore = 1-myScore;
         NSString *gameScore = [scores[0] stringByAppendingFormat:@" - %@", scores[1]];
         if (scores[2] && scores[3]) {
             NSString *secondSetScores = [scores[2] stringByAppendingFormat:@" - %@", scores[3]];
             gameScore = [gameScore stringByAppendingFormat:@"    %@", secondSetScores];
             int addToMyScore =[scores[2] intValue] > [scores[3] intValue] ? 1:0;
             myScore += addToMyScore;
             theirScore += 1-addToMyScore;
         }
         if (scores[4] && scores[5]) {
             NSString *thirdSetScores = [scores[4] stringByAppendingFormat:@" - %@", scores[5]];
             gameScore = [gameScore stringByAppendingFormat:@"    %@", thirdSetScores];
             int addToMyScore =[scores[4] intValue] > [scores[5] intValue] ? 1:0;
             myScore += addToMyScore;
             theirScore += 1-addToMyScore;
         }
         self.gameLabel.text = gameScore;
         self.setLabel.text = [[NSString stringWithFormat:@"%d", myScore] stringByAppendingFormat:@" - %d", theirScore];
         
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
