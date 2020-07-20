//
//  MapViewController.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/14/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuggestViewController.h"
#import "Court.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MapViewControllerDelegate

@property (nonatomic, strong) NSArray<Court *> *courts;
@property (nonatomic, strong) NSArray<PFUser*> *players;

- (void) findUsersWithQueries:(NSArray<PFQuery*> *) playerQueries;

@end

@interface MapViewController : UIViewController

@property (nonatomic, weak) id<MapViewControllerDelegate> delegate;

-(void)mapSetUp;
- (void)fetchCourtsnear;

@end

NS_ASSUME_NONNULL_END
