//
//  Tab1MainViewController.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Tab1MainViewController.h"
#import "AnnotationView.h"
#import "CurrentLocationAnnotation.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "Tab1AddViewController.h"
#import "SBJson.h"

@interface Tab1MainViewController (Privated)
- (void)showSubMenu;
- (void)hideSubMenu;
- (void)showOrHideSearchBar;
@end

@implementation Tab1MainViewController
@synthesize mvMapView,locationManager, currentLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark -
#pragma mark Core Location
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation 
{	
	[locationManager stopUpdatingLocation];
	if(currentLocation == nil) self.currentLocation = newLocation;
	else if (newLocation.horizontalAccuracy < self.currentLocation.horizontalAccuracy) self.currentLocation = newLocation;
	
	mvMapView.region = MKCoordinateRegionMake(self.currentLocation.coordinate, MKCoordinateSpanMake(0.5f, 0.5f));	
	[mvMapView setShowsUserLocation:NO];
	
	//CurrentLocationAnnotation *annotation = [[[CurrentLocationAnnotation alloc] initWithCoordinate:self.currentLocation.coordinate addressDictionary:nil] autorelease];
	//annotation.title = @"1";
	//annotation.subtitle = @"Drag pin to set poisition.";
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{	
	NSString* errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
	UIAlertView* locationAlert = [[UIAlertView alloc] initWithTitle:@"Error Getting Location"
															message:errorType
														   delegate:nil
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
	[locationAlert show];
	[locationAlert release];
	[errorType release];
}

#pragma mark -
#pragma mark Map Kit
- (MKAnnotationView *)mapView:(MKMapView *)MapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
	MKAnnotationView *draggablePinView = [MapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
	if (draggablePinView) {
		draggablePinView.annotation = annotation;
	} else {		
		draggablePinView = [[[AnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier] autorelease];
		if ([draggablePinView isKindOfClass:[AnnotationView class]]) {
			((AnnotationView *)draggablePinView).mapView = MapView;
		}
        draggablePinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        draggablePinView.canShowCallout = YES;
	}
	return draggablePinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState 
{
	if (oldState == MKAnnotationViewDragStateDragging) {
        selectedAnnotation = (CurrentLocationAnnotation *)annotationView.annotation;
        
        NSString *_url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f2&language=th&sensor=false", selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude];
        NSString *_fixedURL = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)_url, NULL, NULL, kCFStringEncodingUTF8);
        
        
        // initiate request
        ASIFormDataRequest *request2 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:_fixedURL]];
        [request2 setDelegate:self];
        [request2 startAsynchronous];
        
        
        // add HUD
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Getting Coordinates";
        
        
        
        
        
		
		selectedAnnotation.subtitle = [NSString stringWithFormat:@"%f %f", selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude];
        //[self connectDots];
	}
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{
    MKPolylineView *polyLineView = [[[MKPolylineView alloc] initWithOverlay:overlay] autorelease];
    polyLineView.strokeColor = [UIColor redColor];
    polyLineView.lineWidth = 5.0;
    return polyLineView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    //DetailViewController *detailViewController = [[DetailViewController alloc] initWithCurrentAnnotation:selectedAnnotation];
    //[self.navigationController pushViewController:detailViewController animated:YES];
    //[detailViewController release];
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    //data 
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
}

#pragma mark - ASIHTTPRequest Delegate
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSError *error = [request error];
    NSLog(@"%@",[error localizedDescription]);
    //textView.text = [error localizedDescription];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    if (request.responseStatusCode == 200)
    {
        NSString *responseString = [request responseString];
        NSLog(@"responseString = %@",responseString);
        // create dictionary from JSON text
        NSDictionary *responseDict = [responseString JSONValue];
        
        // retrieve the longitude and latitude from JSON response
//        NSString *status = [responseDict objectForKey:@"status"];
        NSArray *results = (NSArray *)[responseDict objectForKey:@"results"];
        if([results count] > 0){
            NSDictionary *data = (NSDictionary *)[results objectAtIndex:0];
            NSArray *address_components = (NSArray *)[data objectForKey:@"address_components"];
            //NSDictionary *latlng = (NSDictionary *)[address_components objectForKey:@"long_name"];
            NSLog(@"%i",[address_components count]);
//            NSLog(@"long_name %@", [(NSDictionary *)[address_components objectAtIndex:0] objectForKey:@"long_name"]);
            [selectedAnnotation setTitle:[NSString stringWithFormat:@"%@ %@",[(NSDictionary *)[address_components objectAtIndex:0] objectForKey:@"long_name"],[(NSDictionary *)[address_components objectAtIndex:1] objectForKey:@"long_name"]]];
            [selectedAnnotation setSubtitle:[NSString stringWithFormat:@"%f,%f",selectedAnnotation.coordinate.latitude,selectedAnnotation.coordinate.longitude]];
        }else{
            [selectedAnnotation setTitle:@"Unknown"];
        }
        // change textView text        
        //textView.text = [NSString stringWithFormat:@"Latitude:%@\nLongitude:%@", [latlng objectForKey:@"lat"],[latlng objectForKey:@"lng"]];
    }
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - Map Features

- (void)addPoint
{
    selectedAnnotation = [[[CurrentLocationAnnotation alloc] initWithCoordinate:self.currentLocation.coordinate addressDictionary:nil] autorelease];
    //	annotation.title = [[NSString alloc] initWithFormat:@"%d", [mvMapView.annotations count] + 1];
    //	annotation.subtitle = @"Drag pin to set poisition.";
    //    
    //    [mvMapView addAnnotation:annotation];
    //    [annotation release];
    
    selectedAnnotation = [[[CurrentLocationAnnotation alloc] initWithCoordinate:self.currentLocation.coordinate addressDictionary:nil] autorelease];
    
    NSString *_url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f2&language=th&sensor=false", selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude];
    NSString *_fixedURL = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)_url, NULL, NULL, kCFStringEncodingUTF8);
    
    
    // initiate request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:_fixedURL]];
    [request setDelegate:self];
    [request startAsynchronous];
    
    
    // add HUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Getting Coordinates";
    
	[mvMapView addAnnotation:selectedAnnotation];
    
    //Show sub-menu
    [self showSubMenu];
}

- (void)searchPoint
{
    [self showOrHideSearchBar];
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@""];
    UIImageView *_titleText = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"text_map.png"]];
    [self.navigationItem setTitleView:_titleText];
    [_titleText release];
    
    CGColorRef darkColor = [[UIColor blackColor] colorWithAlphaComponent:.3f].CGColor;
    CGColorRef lightColor = [UIColor clearColor].CGColor;
    CGFloat navigationBarBottom = 0.0;
    CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];
    newShadow.frame = CGRectMake(0,navigationBarBottom, self.view.frame.size.width, 3);
    newShadow.colors = [NSArray arrayWithObjects:(id)darkColor, (id)lightColor, nil];
    [self.view.layer addSublayer:newShadow];
    
    UIImage *buttonImage = [UIImage imageNamed:@"button_add.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addPoint) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:customBarItem];
    [customBarItem release];
    
    UIImage *buttonImage2 = [UIImage imageNamed:@"button_search.png"];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:buttonImage2 forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(searchPoint) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(0, 0, buttonImage2.size.width, buttonImage2.size.height);
    UIBarButtonItem *customBarItem2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    [self.navigationItem setLeftBarButtonItem:customBarItem2];
    [customBarItem2 release];
    
    
    
    [mvMapView setMapType:MKMapTypeHybrid];
	[mvMapView setDelegate:self];
    
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDelegate:self];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	if(![CLLocationManager locationServicesEnabled]) {
		UIAlertView *locationServiceDisabledAlert = [[UIAlertView alloc] 
													 initWithTitle:@"Location Services Disabled"
													 message:@"Location Service is disabled on this device. To enable Location Services go to Settings -> General and set the Location Services switch to ON"
													 delegate:self
													 cancelButtonTitle:@"Ok"
													 otherButtonTitles:nil];
		[locationServiceDisabledAlert show];
		[locationServiceDisabledAlert release];
	}
    
    [locationManager startUpdatingLocation];

}


- (void)viewDidUnload
{
    [self setMvMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [mvMapView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Sub Menu

- (void)showSubMenu
{
    UIView *_subMenuView = [self.view viewWithTag:66];
    [UIView animateWithDuration:0.3 animations:^{
        [_subMenuView setFrame:CGRectMake(0, 0, _subMenuView.frame.size.width, _subMenuView.frame.size.height)];
    } completion:^(BOOL finished){
        
    }];
}

- (void)hideSubMenu
{
    UIView *_subMenuView = [self.view viewWithTag:66];
    [UIView animateWithDuration:0.3 animations:^{
        [_subMenuView setFrame:CGRectMake(0, -40, _subMenuView.frame.size.width, _subMenuView.frame.size.height)];
    } completion:^(BOOL finished){
        
    }];
}

- (IBAction)cancleAdd:(UIButton*)sender {
    
    //#Tong Please remove the pin here
    
    [self hideSubMenu];
}

- (IBAction)submitAdd:(UIButton*)sender {
    Tab1AddViewController *addViewController = [[Tab1AddViewController alloc] initWithNibName:@"Tab1AddViewController" bundle:nil];
    [self.navigationController pushViewController:addViewController animated:YES];
    [addViewController release];
    [self hideSubMenu];
}

- (void)showOrHideSearchBar
{
    UIView *_searchBar = [self.view viewWithTag:77];
    NSInteger currentY = _searchBar.frame.origin.y;
    if (currentY == -44) {
        [UIView animateWithDuration:0.3 animations:^{
            [_searchBar setFrame:CGRectMake(0, 0, _searchBar.frame.size.width, _searchBar.frame.size.height)];
        } completion:^(BOOL finished){
            
        }];
    }else{
        [_searchBar resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            [_searchBar setFrame:CGRectMake(0, -44, _searchBar.frame.size.width, _searchBar.frame.size.height)];
        } completion:^(BOOL finished){
            
        }];
    }
    
}


@end
