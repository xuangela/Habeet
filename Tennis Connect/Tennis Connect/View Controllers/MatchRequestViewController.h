//
//  MatchRequestViewController.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/21/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Court.h"
#import "SuggestedPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MatchRequestDelegate

@property (nonatomic, strong) NSMutableArray<Player*> *players;

@property (weak, nonatomic) IBOutlet SuggestedPlayerView *suggestedview;

@property (nonatomic, assign) int currPlayer;

@end


@interface MatchRequestViewController : UIViewController

@property (nonatomic, strong) NSArray<Court *> *courts;
@property (nonatomic, strong) Player *player;

@property (nonatomic, assign) BOOL sentReq; 

@property (nonatomic, weak) id<MatchRequestDelegate> delegate;

- (void) findSharedCourts;

@end

NS_ASSUME_NONNULL_END
