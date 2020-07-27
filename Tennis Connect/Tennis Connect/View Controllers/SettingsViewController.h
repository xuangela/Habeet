//
//  SettingsViewController.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/27/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SettingsViewDelegate

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end

@interface SettingsViewController : UIViewController

@property (nonatomic, weak) id<SettingsViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
