//
//  Tab1MainViewController.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@class CurrentLocationAnnotation;
@interface Tab1MainViewController : UIViewController < MKMapViewDelegate, CLLocationManagerDelegate> {
    MKMapView *mvMapView;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CurrentLocationAnnotation *selectedAnnotation;
    NSMutableArray *mapAnnotations;
    NSString *address1;
    NSString *address2;
}

@property (nonatomic, strong) IBOutlet MKMapView *mvMapView;
@property (retain, nonatomic) CurrentLocationAnnotation *selectedAnnotation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;
@property (retain, nonatomic) IBOutlet NSString *address1;
@property (retain, nonatomic) IBOutlet NSString *address2;

- (IBAction)cancleAdd:(UIButton*)sender;
- (IBAction)submitAdd:(UIButton*)sender;
- (void)getAllPin;
- (void) viewDetail;
@end
