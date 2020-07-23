//
//  CourtDetailViewController.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/22/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Court.h"
#import "Match.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourtDetailViewController : UIViewController

@property (nonatomic, strong) Court* court;
@property (nonatomic, strong) NSMutableArray<Match *>* matches;

-(void)mapSetUp;
- (void)getMatches;

@end

NS_ASSUME_NONNULL_END
