//
//  MatchRequestViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/21/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "MatchRequestViewController.h"
#import "SuggestViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Match.h"
@import MaterialComponents;

@interface MatchRequestViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapview;
@property (weak, nonatomic) IBOutlet UILabel *courtNameLabel;
@property (weak, nonatomic) IBOutlet MDCButton *confirmButton;

@property (nonatomic, strong) MKAnnotationView *selectedCourt;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MDCActivityIndicator *activityIndicator;

@end

@implementation MatchRequestViewController

@synthesize courts;
@synthesize player;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buttonSetUp];
    [self loadingIndicatorSetUp];

    self.courtNameLabel.alpha = 0;
    self.sentReq = NO;
}

- (void)loadingIndicatorSetUp {
    self.activityIndicator = [[MDCActivityIndicator alloc] init];
    
    UIColor *myPink = [[UIColor alloc] initWithRed:246.0/255.0 green:106.0/255.0 blue:172.0/255.0 alpha:1];
    UIColor *myLightPink = [[UIColor alloc] initWithRed:255.0/255.0 green:204.0/255.0 blue:238.0/255.0 alpha:1];
    self.activityIndicator.cycleColors =  @[myPink,myLightPink];
    
    [self.activityIndicator sizeToFit];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width  / 2, self.view.frame.size.height / 2);

    [self.activityIndicator startAnimating];
}

- (void)buttonSetUp {
    
    self.confirmButton.enabled = NO;
    
    MDCContainerScheme *containerScheme = [[MDCContainerScheme alloc] init];
    containerScheme.colorScheme.primaryColor = [[UIColor alloc] initWithRed:246.0/255.0 green:106.0/255.0 blue:172.0/255.0 alpha:1];
    
    [self.confirmButton applyTextThemeWithScheme:containerScheme];
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    
    [self.confirmButton setTitleFont:font forState:UIControlStateSelected];
    [self.confirmButton setTitleFont:font forState:UIControlStateNormal];
    
    self.confirmButton.minimumSize = CGSizeMake(64, 36);
    
    CGFloat verticalInset = MIN(0, -(48 - CGRectGetHeight(self.confirmButton.bounds)) / 2);
    CGFloat horizontalInset = MIN(0, -(48 - CGRectGetWidth(self.confirmButton.bounds)) / 2);
    self.confirmButton.hitAreaInsets = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
}

- (void) findSharedCourts{
    PFRelation *relation = [self.player.user relationForKey:@"courts"];
    PFQuery *query = [relation query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSMutableSet *myCourts = [[NSMutableSet alloc] init];
            for (Court* court in self.courts) {
                [myCourts addObject:court.name];
            }
            
            NSMutableSet *theirCourts = [[NSMutableSet alloc] init];
            
            for (PFObject *court in objects) {
                [theirCourts addObject:[court valueForKey:@"name"]];
            }
            
            [myCourts intersectSet: theirCourts];
            
            NSMutableArray *newCourts = [[NSMutableArray alloc] init];
            
            for (NSString *name in myCourts) {
                for (Court* court in self.courts) {
                    if ([court.name isEqualToString:name]) {
                        [newCourts addObject:court];
                        continue;
                    }
                }
            }
            self.courts = newCourts;
            
            [self mapSetUp];
            [self displayCourts];
        }
    }];
}

- (IBAction)tapConfirm:(id)sender {
    self.sentReq = YES;
    
    if (self.sentReq) {
        [self.delegate.players removeObject:self.player];
    }
    
    self.delegate.currPlayer =self.delegate.currPlayer % self.delegate.players.count;
    [self.delegate.suggestedview setPlayer:self.delegate.players[self.delegate.currPlayer]];
    
    Match *newMatch = [Match object];
    newMatch.sender = [PFUser currentUser];
    newMatch.receiver = self.player.user;
    newMatch.confirmed = NO;
    newMatch.completed = NO;
    
    PFQuery *findCourtRefQuery = [Court query];
    [findCourtRefQuery whereKey: @"name" equalTo:self.selectedCourt.annotation.title];
    [findCourtRefQuery whereKey:@"lat" equalTo:[NSNumber numberWithDouble:self.selectedCourt.annotation.coordinate.latitude]];
    [findCourtRefQuery whereKey:@"lng" equalTo:[NSNumber numberWithDouble:self.selectedCourt.annotation.coordinate.longitude]];
    
    [findCourtRefQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            newMatch.court = [[Court alloc] initWithPFObject:object];
            [newMatch saveInBackground];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Map Set up

-(void)mapSetUp {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.mapview.delegate = self;
    self.mapview.showsUserLocation = YES;
}

- (void)displayCourts {
    for (Court* court in self.courts) {
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        annotation.coordinate = court.coordinates;
        annotation.title = court.name;
        [self.mapview addAnnotation:annotation];
    }
    [self.activityIndicator stopAnimating];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *lastLocation = [locations lastObject];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(.1, .1);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapview setRegion:region];
    [self.locationManager stopUpdatingLocation];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    self.selectedCourt = view;
    [UIView animateWithDuration:1 animations:^{
        self.courtNameLabel.text = view.annotation.title;
        self.courtNameLabel.alpha = 1;
        self.confirmButton.enabled = YES;
    }];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [UIView animateWithDuration:1 animations:^{
        self.courtNameLabel.alpha = 0;
        self.confirmButton.enabled = NO;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
