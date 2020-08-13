//
//  ProfileViewController.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/13/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (nonatomic, assign) BOOL wasUpdated; 

@end

NS_ASSUME_NONNULL_END
