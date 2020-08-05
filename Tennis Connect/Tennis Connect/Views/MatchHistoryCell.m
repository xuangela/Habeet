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
    
    int exp = [[opponent valueForKey:@"rating"] intValue];
    
    if (exp <= 500) {
        self.expLabel.text = @"Beginner";
    } else if (exp <= 1000) {
        self.expLabel.text = @"Intermediate";
    } else {
        self.expLabel.text = @"Experienced";
    }
    
    if ([match[@"scoreValidated"] boolValue]) {
        self.validationButton.alpha = 0;
    } else {
        self.validationButton.alpha = 1;
        if (isReceiver) {
            [self.validationButton setTitle:@"Validate score" forState:UIControlStateNormal];
            UIColor *myPink = [[UIColor alloc] initWithRed:246.0/255.0 green:106.0/255.0 blue:172.0/255.0 alpha:1];
            [self.validationButton setTitleColor:myPink forState:UIControlStateNormal];
            self.validationButton.userInteractionEnabled = YES;
        } else {
            [self.validationButton setTitle:@"Awaiting validation" forState:UIControlStateNormal];
            [self.validationButton setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
            self.validationButton.userInteractionEnabled = NO;
            
        }
    }
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
    NSArray *bits = [scores[0] componentsSeparatedByString: @" - "];
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
    
    UIColor *color;
    if ([bits[0] intValue]< [bits[1] intValue]) {
        color = [[UIColor alloc] initWithRed:246.0/255.0 green:106.0/255.0 blue:172.0/255.0 alpha:1];
    } else {
        color = [[UIColor alloc] initWithRed:111.0/255.0 green:179.0/255.0 blue:70.0/255.0 alpha:1];
    }
    self.setLabel.textColor = color;
}

- (NSString*) reverseGameString:(NSString *)gameScore {
    char first = [gameScore characterAtIndex:0];
    char last = [gameScore characterAtIndex:gameScore.length - 1];
    gameScore = [NSString stringWithFormat:@"%c - %c", last, first];
    return gameScore;
}

- (IBAction)onTapValidate:(id)sender {
    NSLog(@"tappedTheValidateButton");
    [UIView animateWithDuration:.2 animations:^{
        self.validationButton.alpha = 0;
    }];
    
    PFQuery *query = [Match query];
    [query getObjectInBackgroundWithId:self.match.objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        object[@"scoreValidated"] = @YES;
        
        [object saveInBackground];
    }];
}
@end
