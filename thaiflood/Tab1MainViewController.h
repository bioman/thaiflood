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
}

@property (nonatomic, retain) IBOutlet MKMapView *mvMapView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocation;

- (IBAction)addPin:(id)sender;

@end
