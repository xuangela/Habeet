//
//  SuggestViewController.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/16/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuggestedPlayerView.h"
#import "Court.h"

NS_ASSUME_NONNULL_BEGIN

@interface SuggestViewController : UIViewController

@property (weak, nonatomic) IBOutlet SuggestedPlayerView *suggestedview;

@property (nonatomic, strong) NSArray<Court *> *courts;

@property (nonatomic, strong) NSMutableArray<Player*> *players;
@property (nonatomic, assign) int currPlayer;


- (void)settingsChanged; 

@end

NS_ASSUME_NONNULL_END
