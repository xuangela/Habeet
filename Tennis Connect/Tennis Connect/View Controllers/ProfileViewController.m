//
//  ProfileViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/13/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "SuggestViewController.h"
#import "SceneDelegate.h"
#import <DateTools/DateTools.h>
@import Parse;

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,SettingsViewDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *pfpView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillLabel;

@property (nonatomic, strong) UIImagePickerController *imagePickerVC;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self userInfoDisplay];
    [self cameraSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.wasUpdated) {
        [self userInfoDisplay];
        SuggestViewController *suggestcontrol = self.tabBarController.viewControllers[1];
        [suggestcontrol updatePlayerOrder];
    }
}

- (void) cameraSetup {
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

- (void) userInfoDisplay {
    PFUser *user = [PFUser currentUser];
    self.nameLabel.text = [user valueForKey:@"name"];
    self.usernameLabel.text = [@"@" stringByAppendingString:user.username];
    self.genderLabel.text = [user valueForKey:@"gender"];
    self.contactNumLabel.text = [user valueForKey:@"contact"];
    NSInteger age =[[user valueForKey:@"age"] yearsAgo];
    self.ageLabel.text = [NSString stringWithFormat: @"%ld", (long)age];
    NSInteger exp = [[user valueForKey:@"rating"] integerValue];
    self.skillLabel.text = [NSString stringWithFormat: @"%ld", (long)exp];
    
    if ([user valueForKey:@"picture"]) {
        self.pfpView.file = [user valueForKey:@"picture"];
        [self.pfpView loadInBackground];
    }
}

- (IBAction)tapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * error) {   }];
}

#pragma mark - Camera

- (IBAction)tapPic:(id)sender {
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    PFUser *user = [PFUser currentUser];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIImage *resizedImage = [self resizeImage:image withSize:CGSizeMake(1000, 1000)];

    [self.pfpView setImage:resizedImage];
    NSData *pictureData = UIImagePNGRepresentation(self.pfpView.image);
        
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:user.objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            object[@"picture"] = [PFFileObject fileObjectWithData:pictureData];
            [object saveInBackground];
            NSLog(@"picture saved");
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"settingSegue"]) {
        SettingsViewController *settingsController = [segue destinationViewController];
        
        settingsController.delegate = self;
    }
}

@end
