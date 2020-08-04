//
//  MapViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/14/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "MapViewController.h"
#import "SuggestViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Court.h"
#import "Player.h"
#import "CourtDetailViewController.h"
#import "MaterialActivityIndicator.h"
@import Parse;

static NSString * const clientID = @"YQR5YWMSDL0VOFJKHK2CVOX5MVUGUFQ1FOPYNWUAHY4U3EPY";
static NSString * const clientSecret = @"DEIPIBDNNY5IH5D5T4I35GORXFJ3VIBVR3LSIU3FMH10KDFJ";

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapview;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray<Court*> *courts;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (strong, nonatomic) IBOutlet MDCActivityIndicator *activityIndicator;

@property (nonatomic, strong) MKAnnotationView *selectedCourt;

@end

@implementation MapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self.tabBarController.viewControllers[1];
    
    [self loadingIndicatorSetUp];
    [self mapSetUp];
    [self clearExistingCourt];
}

- (void)clearExistingCourt {
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"courts"];
    PFQuery *query = [relation query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (Court *court in objects) {
            [relation removeObject:court];
        }
        NSLog(@"deleted");
        [self fetchCourtsnear];
    }];
}

- (void)loadingIndicatorSetUp {
    self.activityIndicator = [[MDCActivityIndicator alloc] init];
    
    UIColor *myPink = [[UIColor alloc] initWithRed:246.0/255.0 green:106.0/255.0 blue:172.0/255.0 alpha:1];
    UIColor *myLightPink = [[UIColor alloc] initWithRed:255.0/255.0 green:204.0/255.0 blue:238.0/255.0 alpha:1];
    
    self.activityIndicator.cycleColors =  @[myPink, myLightPink];
    
    [self.activityIndicator sizeToFit];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width  / 2, self.view.frame.size.height / 2);

    self.view.userInteractionEnabled = NO;
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    [self.activityIndicator startAnimating];
}

- (void)fetchCourtsnear {
    NSString *baseURLString = @"https://api.foursquare.com/v2/venues/search?";
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&ll=%f,%f&query=tennis&limit=10", clientID, clientSecret, self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *venues= [responseDictionary valueForKeyPath:@"response.venues"];
            self.courts = [Court courtsWithDictionaries:venues];
            
            self.delegate.courts = self.courts;
            
            [Court courtInParseAndAddRelations:self.courts withBlock:^(void) {
                [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                    [self.activityIndicator stopAnimating];
                    self.view.userInteractionEnabled = YES;
                    self.tabBarController.tabBar.userInteractionEnabled = YES;
                }];
            }];
        
            [self displayCourts];
        }
    }];
    [task resume];
}

- (void)displayCourts {
    for (Court* court in self.courts) {
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        annotation.coordinate = court.coordinates;
        annotation.title = court.name;
        [self.mapview addAnnotation:annotation];
    }
    NSLog(@"added map annotations");
}

#pragma mark - Viewing the map

-(void)mapSetUp {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.mapview.delegate = self;
    self.mapview.showsUserLocation = YES;
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
    [self performSegueWithIdentifier:@"courtDetailSegue" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"courtDetailSegue"]) {
        
        UINavigationController *navControl = [segue destinationViewController];
        CourtDetailViewController *viewControl = (CourtDetailViewController*)navControl.topViewController;
        
        PFQuery *findCourtRefQuery = [Court query];
        [findCourtRefQuery whereKey: @"name" equalTo:self.selectedCourt.annotation.title];
        [findCourtRefQuery whereKey:@"lat" equalTo:[NSNumber numberWithDouble:self.selectedCourt.annotation.coordinate.latitude]];
        [findCourtRefQuery whereKey:@"lng" equalTo:[NSNumber numberWithDouble:self.selectedCourt.annotation.coordinate.longitude]];
        
        [findCourtRefQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            
            if (!error) {
                viewControl.court = [[Court alloc] initWithPFObject:object];
            }
        
            [viewControl mapSetUp];
            [viewControl getMatches];
        }];
    }
}

@end
