//
//  MapViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/14/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Court.h"

static NSString * const clientID = @"YQR5YWMSDL0VOFJKHK2CVOX5MVUGUFQ1FOPYNWUAHY4U3EPY";
static NSString * const clientSecret = @"DEIPIBDNNY5IH5D5T4I35GORXFJ3VIBVR3LSIU3FMH10KDFJ";

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapview;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mapSetUp];
    [self fetchCourtsnear];
}

- (void)fetchCourtsnear {
    NSString *baseURLString = @"https://api.foursquare.com/v2/venues/search?";
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&ll=%f,%f&categoryId=4e39a956bd410d7aed40cbc3&limit=10", clientID, clientSecret, self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"response: %@", responseDictionary);
            NSArray *venues= [responseDictionary valueForKeyPath:@"response.venues"];
            self.courts = [Court courtsWithDictionaries:venues];
            //[self updatePFUserWithCourts];
        } else {
            NSLog(@"%@", error);
        }
    }];
    [task resume];
}

- (void)updatePFUserWithCourts {
    PFUser *user = [PFUser currentUser];

    for (Court* court in self.courts) {
        // check if already has a parse object for this
        // if yes, add relation
        // if not,
    }
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) { }];
    
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
    MKCoordinateSpan span = MKCoordinateSpanMake(.05, .05);
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
