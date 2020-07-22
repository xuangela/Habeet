//
//  CourtDetailViewController.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/22/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Court.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourtDetailViewController : UIViewController

@property (nonatomic, strong) Court* court;

-(void)mapSetUp;

@end

NS_ASSUME_NONNULL_END
