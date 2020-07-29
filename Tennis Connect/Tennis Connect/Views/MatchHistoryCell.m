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
    
    _match = match;
    
    PFUser *opponent;
    BOOL isReceiver;
    
    
    
     if ([match.receiver.objectId isEqualToString:[PFUser currentUser].objectId]) {
         opponent = match.sender;
         isReceiver = YES;
         
     } else {
         opponent = match.receiver;
         isReceiver = NO;
         
     }
    
    NSArray<NSString *> *formattedString = [self getScore:match.score];
    [self setScores:formattedString receiving:isReceiver];
    
    if ([opponent valueForKey:@"picture"]) {
        self.pfpView.file = [opponent valueForKey:@"picture"];
        [self.pfpView loadInBackground];
    }
    
    self.nameLabel.text = [opponent objectForKey:@"name"];
    
    NSDate *playedDate = match[@"updatedAt"];
    self.dateLabel.text = [playedDate formattedDateWithStyle:NSDateFormatterFullStyle];
    
    self.expLabel.text = [opponent valueForKey:@"rating"];
}

- (NSArray<NSString *> *) getScore:(NSArray *) scores { //sender, receiver
    int myScore = [scores[1] intValue] > [scores[0] intValue] ? 1:0;
    int theirScore = 1-myScore;
    
    NSString *set1Score = [scores[1] stringByAppendingFormat:@" - %@", scores[0]];
    NSString *set2Score = @"";
    NSString *set3Score = @"";
    
    if ([scores[2] boolValue]) {
        set2Score = [scores[3] stringByAppendingFormat:@" - %@", scores[2]];
        int addToMyScore =[scores[3] intValue] > [scores[2] intValue] ? 1:0;
        myScore += addToMyScore;
        theirScore += 1-addToMyScore;
    }
    
    if ([scores[4] boolValue]) {
        set3Score = [scores[5] stringByAppendingFormat:@" - %@", scores[4]];
        int addToMyScore =[scores[5] intValue] > [scores[4] intValue] ? 1:0;
        myScore += addToMyScore;
        theirScore += 1-addToMyScore;
    }
    //returns format as if I was receiver
    
    NSString *matchScore =[NSString stringWithFormat:@"%d - %d", myScore,theirScore];
    return @[matchScore, set1Score, set2Score, set3Score];
}

- (void) setScores:(NSArray<NSString *> *) scores receiving: (BOOL) receiver {
    if (receiver) {
        self.setLabel.text = scores[0];
        NSString* gameScores = [NSString stringWithFormat:@"%@    %@    %@", scores[1], scores[2], scores[3]];
        self.gameLabel.text = [gameScores stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        for (int i = 0; i < scores.count; i++) {
            NSString *score = scores[i];
            if (![score isEqualToString:@""]) {
                score = [self reverseGameString:score];
            }
        }
        self.setLabel.text = scores[0];
        NSString* gameScores = [NSString stringWithFormat:@"%@    %@    %@", scores[1], scores[2], scores[3]];
        self.gameLabel.text = [gameScores stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

- (NSString*) reverseGameString:(NSString *)gameScore {
    char first = [gameScore characterAtIndex:0];
    char last = [gameScore characterAtIndex:gameScore.length - 1];
    gameScore = [NSString stringWithFormat:@"%c - %c", last, first];
    return gameScore;
}
@end
