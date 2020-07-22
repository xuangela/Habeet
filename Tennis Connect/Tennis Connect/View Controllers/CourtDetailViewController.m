//
//  CourtDetailViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/22/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "CourtDetailViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CourtDetailViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapview;
@property (weak, nonatomic) IBOutlet UILabel *etaLabel;
@property (weak, nonatomic) IBOutlet UILabel *courtnameLabel;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation CourtDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

#pragma mark - Map set up 

-(void)mapSetUp {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.mapview.delegate = self;
    self.mapview.showsUserLocation = YES;
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = self.court.coordinates;
    annotation.title = self.court.name;
    [self.mapview addAnnotation:annotation];
    
    [self directionsSetUp];
    self.courtnameLabel.text = self.court.name;
}

- (void) directionsSetUp {
    MKDirectionsRequest* request = [[MKDirectionsRequest alloc] init];
    
    MKPlacemark *userPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.mapview.userLocation.location.coordinate];
    request.source = [[MKMapItem alloc] initWithPlacemark:userPlacemark];
    MKPlacemark *courtPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.court.coordinates];
    request.destination = [[MKMapItem alloc] initWithPlacemark:courtPlacemark];
    
    request.requestsAlternateRoutes = NO;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            MKRoute *route = response.routes[0] ;
            [self.mapview addOverlay:route.polyline];
            double travelTimeSec = route.expectedTravelTime;
            double travelTimeMin = travelTimeSec / 60;
            NSString *travelTimeString = @"Travel time: ";
            
            if (travelTimeMin >= 60) {
                double travelHour = travelTimeMin / 60;
                travelTimeString = [travelTimeString stringByAppendingString:[NSString stringWithFormat:@"%f h ", travelHour]];
            }
            travelTimeString = [travelTimeString stringByAppendingString:[NSString stringWithFormat:@"%.0f min", travelTimeMin]];
            
            self.etaLabel.text = travelTimeString;
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *lastLocation = [locations lastObject];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(.1, .1);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapview setRegion:region];
    [self.locationManager stopUpdatingLocation];
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
