//
//  Tab1MainViewController.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Tab1MainViewController.h"
#import "AnnotationView.h"
#import "CurrentLocationAnnotation.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "Tab1AddViewController.h"
#import "Tab1PinViewController.h"
#import "SBJson.h"
#import "CalloutView.h"

@interface Tab1MainViewController (Privated)
- (void)showSubMenu;
- (void)hideSubMenu;
- (void)showOrHideSearchBar;
@end

@implementation Tab1MainViewController
@synthesize mvMapView,locationManager, currentLocation, selectedAnnotation;
@synthesize mapAnnotations;
@synthesize address1,address2;

NSString * const GMAP_ANNOTATION_SELECTED = @"gmapselected";

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
- (void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV; 
    
    for (aV in views) {
        
        // Don't pin drop if annotation is user location
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.view.frame.size.height, aV.frame.size.width, aV.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04*[views indexOfObject:aV] options:UIViewAnimationCurveLinear animations:^{
            
            aV.frame = endFrame;
            
            // Animate squash
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                }completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            aV.transform = CGAffineTransformIdentity;
                        }];
                    }
                }];
            }
        }];
    }
    
}

- (void)viewDetail:(UITapGestureRecognizer *)gestureRecognizer 
{
    NSLog(@"viewDetail");
//    NSMutableDictionary *_pinData = [[NSMutableDictionary alloc] init];
//    [_pinData setObject:[self.currentAnnotation title] forKey:@"title"];
//    [_pinData setObject:[self.currentAnnotation tag] forKey:@"id"];
//    [_pinData setObject:[self.currentAnnotation latlong] forKey:@"latlong"];
//    
//    Tab1PinViewController *pinViewController = [[Tab1PinViewController alloc] initWithNibName:@"Tab1PinViewController" bundle:nil];
//    [pinViewController startViewData:_pinData];
//    [_pinData release];
//    [[self viewController].navigationController pushViewController:pinViewController animated:YES];
//    [pinViewController release];
}

- (MKAnnotationView *)mapView:(MKMapView *)MapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(@"viewForAnnotation");
    
    //annotation 
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
	//MKAnnotationView *draggablePinView = [MapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
    AnnotationView *draggablePinView = [[[AnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier] autorelease];
    //return draggablePinView;
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        NSLog(@"MKUserLocation");
        MKAnnotationView *draggablePinView = [MapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
        return draggablePinView;
    }
        
//    
	if (draggablePinView) {
//        NSLog(@"old pin");
//        
        if( [[((CurrentLocationAnnotation*)annotation) type] isEqualToString:@"normal"] ) {
//            UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [accessoryButton setFrame:CGRectMake(60, 11, 27, 27)];
//            [accessoryButton setTag:101];
//            //[accessoryButton setUserInteractionEnabled:YES];
//            [accessoryButton setImage:[UIImage imageNamed:@"button_detail.png"] forState:UIControlStateNormal];
//            //[accessoryButton addTarget:self action:@selector(viewDetail) forControlEvents:UIControlEventTouchUpInside];
//            
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDetail:)];
//            tap.numberOfTapsRequired = 1;
//            //tap.delegate = self;
//            [accessoryButton addGestureRecognizer:tap];
//            [tap release];
//            
//            [draggablePinView addSubview:accessoryButton];
//            NSLog(@"normal pin");
//            if ([draggablePinView isKindOfClass:[AnnotationView class]]) {
//                ((AnnotationView *)draggablePinView).mapView = MapView;
//            }
//            UIImage *pinImage = [UIImage imageNamed:@"pin_shadow.png"];
//            draggablePinView.image = pinImage;
            UIImageView *numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_number.png"]];
            [numberImageView setFrame:CGRectMake(0, 0, 27, 27)];
            
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 27, 25)];
            [numberLabel setText:[((CurrentLocationAnnotation*)annotation) updateCount]];
            [numberLabel setTextAlignment:UITextAlignmentCenter];
            [numberLabel setTextColor:[UIColor whiteColor]];
            [numberLabel setBackgroundColor:[UIColor clearColor]];
            [numberLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
            [numberImageView addSubview:numberLabel];
            [numberLabel release];
            draggablePinView.leftCalloutAccessoryView = numberImageView;[numberImageView release];
            
            
            draggablePinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            draggablePinView.canShowCallout = YES;
            draggablePinView.draggable = NO;
        }else if ( [[((CurrentLocationAnnotation*)annotation) type] isEqualToString:@"critical"] ){
            UIImageView *numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_number.png"]];
            [numberImageView setFrame:CGRectMake(0, 0, 27, 27)];
            
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 27, 25)];
            [numberLabel setText:[((CurrentLocationAnnotation*)annotation) updateCount]];
            [numberLabel setTextAlignment:UITextAlignmentCenter];
            [numberLabel setTextColor:[UIColor whiteColor]];
            [numberLabel setBackgroundColor:[UIColor clearColor]];
            [numberLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
            [numberImageView addSubview:numberLabel];
            [numberLabel release];draggablePinView.leftCalloutAccessoryView = numberImageView;
            [numberImageView release];
            
            
            UIImage *pinImage = [UIImage imageNamed:@"pin_red.png"];
            draggablePinView.image = pinImage;
            draggablePinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            draggablePinView.canShowCallout = YES;
            draggablePinView.draggable = NO;
        }else if ( [[((CurrentLocationAnnotation*)annotation) type] isEqualToString:@"new"] ){
//            NSLog(@"new pin");
//            if ([draggablePinView isKindOfClass:[AnnotationView class]]) {
//                ((AnnotationView *)draggablePinView).mapView = MapView;
//            }
            draggablePinView.rightCalloutAccessoryView = nil;
            UIImage *pinImage = [UIImage imageNamed:@"pin_add.png"];
            draggablePinView.image = pinImage;
            draggablePinView.canShowCallout = YES;
            draggablePinView.draggable = YES;
            [draggablePinView setSelected:YES animated:YES];
        }
//        
        return draggablePinView;
	} else {
        if( [[((CurrentLocationAnnotation*)annotation) type] isEqualToString:@"normal"] ) {
            UIImageView *numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_number.png"]];
            [numberImageView setFrame:CGRectMake(0, 0, 27, 27)];
            
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 27, 25)];
            [numberLabel setText:[((CurrentLocationAnnotation*)annotation) updateCount]];
            [numberLabel setTextAlignment:UITextAlignmentCenter];
            [numberLabel setTextColor:[UIColor whiteColor]];
            [numberLabel setBackgroundColor:[UIColor clearColor]];
            [numberLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
            [numberImageView addSubview:numberLabel];
            [numberLabel release];draggablePinView.leftCalloutAccessoryView = numberImageView;
            [numberImageView release];
            
            draggablePinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            draggablePinView.canShowCallout = YES;
            draggablePinView.draggable = NO;
        }else if ( [[((CurrentLocationAnnotation*)annotation) type] isEqualToString:@"critical"] ){
            UIImageView *numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_number.png"]];
            [numberImageView setFrame:CGRectMake(0, 0, 27, 27)];
            
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 27, 25)];
            [numberLabel setText:[((CurrentLocationAnnotation*)annotation) updateCount]];
            [numberLabel setTextAlignment:UITextAlignmentCenter];
            [numberLabel setTextColor:[UIColor whiteColor]];
            [numberLabel setBackgroundColor:[UIColor clearColor]];
            [numberLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
            [numberImageView addSubview:numberLabel];
            [numberLabel release];draggablePinView.leftCalloutAccessoryView = numberImageView;
            [numberImageView release];
            
            UIImage *pinImage = [UIImage imageNamed:@"pin_red.png"];
            draggablePinView.image = pinImage;
            draggablePinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            draggablePinView.canShowCallout = YES;
            draggablePinView.draggable = NO;
        }else if ( [[((CurrentLocationAnnotation*)annotation) type] isEqualToString:@"new"] ){
//            NSLog(@"new pin");
//            if ([draggablePinView isKindOfClass:[AnnotationView class]]) {
//                ((AnnotationView *)draggablePinView).mapView = MapView;
//            }
            draggablePinView.rightCalloutAccessoryView = nil;
            UIImage *pinImage = [UIImage imageNamed:@"pin_add.png"];
            draggablePinView.image = pinImage;
            draggablePinView.canShowCallout = YES;
            draggablePinView.draggable = YES;
            [draggablePinView setSelected:YES animated:YES];
        }else{
//            NSLog(@"others pin");
//            if ([draggablePinView isKindOfClass:[AnnotationView class]]) {
//                ((AnnotationView *)draggablePinView).mapView = MapView;
//            }
//            UIImage *pinImage = [UIImage imageNamed:@"pin_shadow.png"];
//            draggablePinView.image = pinImage;
//            draggablePinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            draggablePinView.canShowCallout = YES;
//            //draggablePinView.tag
//
        }

        return draggablePinView;
//        [draggablePinView addObserver:self
//                  forKeyPath:@"selected"
//                     options:NSKeyValueObservingOptionNew
//                     context:GMAP_ANNOTATION_SELECTED];
	}
    //UIImage *pinImage = [UIImage imageNamed:@"pin.png"];
    //draggablePinView.image = pinImage;
	return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState 
{

    NSLog(@"dragggg");
    if (oldState == MKAnnotationViewDragStateStarting) {
        NSLog(@"MKAnnotationViewDragStateDragging");
        
        
        selectedAnnotation = (CurrentLocationAnnotation *)annotationView.annotation;
        
        NSString *_url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f2&language=th&sensor=false", selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude];
        NSString *_fixedURL = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)_url, NULL, NULL, kCFStringEncodingUTF8);
        
        
        // initiate request
        ASIFormDataRequest *request2 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:_fixedURL]];
        [request2 setTag:515];
        [request2 setDelegate:self];
        [request2 startAsynchronous];
        
        
        // add HUD
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Getting Coordinates";
        
        
        
		selectedAnnotation.title = [NSString stringWithString:@"Loading...                     "];
        selectedAnnotation.subtitle = [NSString stringWithFormat:@"%f %f", selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude];
        
        [annotationView setDragState:MKAnnotationViewDragStateNone];
        //[self connectDots];
	}else if (oldState == MKAnnotationViewDragStateStarting) {
        NSLog(@"MKAnnotationViewDragStateStarting");
        //[annotationView setDragState:MKAnnotationViewDragStateDragging];
    }else if (oldState == MKAnnotationViewDragStateEnding) {
        NSLog(@"MKAnnotationViewDragStateEnding");
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
	
    
    NSString *action = (NSString*)context;
	
    if([action isEqualToString:GMAP_ANNOTATION_SELECTED]){
		BOOL annotationAppeared = [[change valueForKey:@"new"] boolValue];
		if (annotationAppeared) {
			NSLog(@"annotation selected %@", ((AnnotationView*) object).annotation.title);
			//[self showAnnotation:((MyAnnotationView*) object).annotation];
			//((AnnotationView*) object).image = [UIImage imageNamed:@"pin.png"];
		}
		else {
			NSLog(@"annotation deselected %@", ((AnnotationView*) object).annotation.title);
			//[self hideAnnotation];
			//((AnnotationView*) object).image = [UIImage imageNamed:@"pin.png"];
		}
	}
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"didDeselectAnnotationView");
//    for (UIView *views in [view subviews]) {
//        if([views isKindOfClass:[CalloutView class]])
//        {
//            NSLog(@"remove callout");
//            [views removeFromSuperview];
//        }
//    }
    //view.image = [UIImage imageNamed:@"pin.png"];
    //UIImage *pinImage = [UIImage imageNamed:@"pin_shadow.png"];
    //view.image = pinImage;

}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //I think here you will be adding a annotation(my assumption)
    NSLog(@"didSelectAnnotationView");
    [self setSelectedAnnotation:view.annotation];
    //view.image = [UIImage imageNamed:@"pin.png"];
    //[mapView addAnnotation:yourAnnotation];
    //This will call viewForAnnotation again
    //UIImage *pinImage = [UIImage imageNamed:@"pin_shadow.png"];
    //view.image = pinImage;
    NSLog(@"Title %@",[(CurrentLocationAnnotation*)view.annotation title]);
    
//    /[mapView setCenterCoordinate:((CurrentLocationAnnotation*)view.annotation).coordinate  animated:YES];

    
//    CalloutView *callOutView = [[CalloutView alloc] initWithAnnotation:(CurrentLocationAnnotation*)view.annotation];
//    //[callOutView setFrame:CGRectMake(100, 100, 100, 100)];
//    [view setFrame:CGRectMake(0, 0, 100, 100)];
//    //[callOutView setFrame:view.frame];
//    [mapView addSubview:callOutView];
//    [view setBackgroundColor:[UIColor redColor]];
//    for (UIView *calloutview in [view subviews]) {
//        NSLog(@"%@",[calloutview description]);
//        for (UIView *accview in [calloutview subviews]) {
//            
//            if (accview.tag == 101) {
//                NSLog(@"101 %@",[accview description]);
//                [calloutview bringSubviewToFront:accview];
//            }
//        }
//        [view bringSubviewToFront:calloutview];
//    }
//    
//    
//    [callOutView release];
    
}

//-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{
//    MKPolylineView *polyLineView = [[[MKPolylineView alloc] initWithOverlay:overlay] autorelease];
//    polyLineView.strokeColor = [UIColor redColor];
//    polyLineView.lineWidth = 5.0;
//    return polyLineView;
//}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CurrentLocationAnnotation *_annotation = (CurrentLocationAnnotation *)view.annotation;
    
    NSMutableDictionary *_pinData = [[NSMutableDictionary alloc] init];
    [_pinData setObject:_annotation.title forKey:@"title"];
    [_pinData setObject:_annotation.tag forKey:@"id"];
    [_pinData setObject:_annotation.latlong forKey:@"latlong"];
    
    Tab1PinViewController *pinViewController = [[Tab1PinViewController alloc] initWithNibName:@"Tab1PinViewController" bundle:nil];
    [pinViewController startViewData:_pinData];
    [pinViewController setSelectedAnnotation:selectedAnnotation];
    [_pinData release];
    [self.navigationController pushViewController:pinViewController animated:YES];
    [pinViewController release];
    
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
        if(request.tag == 414)
        {
            NSString *responseString = [request responseString];
            NSLog(@"responseString1 = %@",responseString);
            // create dictionary from JSON text
            NSArray *responseArray = [responseString JSONValue];
            
            [mapAnnotations removeAllObjects];
            
            //NSArray *results = (NSArray *)[responseDict objectForKey:@"results"];
            NSLog(@"results %i",[responseArray count]);
            for (NSDictionary* dict in responseArray) {
                NSLog(@"%@",[dict objectForKey:@"pin_id"]);
                NSLog(@"%@",[dict objectForKey:@"lat"]);
                NSLog(@"%@",[dict objectForKey:@"lng"]);
                NSLog(@"%@",[dict objectForKey:@"address1"]);
                NSLog(@"%@",[NSString stringWithFormat:@"%@_%@",[dict objectForKey:@"lat"],[dict objectForKey:@"lng"]]);
                NSString *addtitle = [dict objectForKey:@"address_custom"];
                if ([addtitle isEqualToString:@""]) {
                    addtitle = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"address1"],[dict objectForKey:@"address2"]];
                }
            
                CLLocationCoordinate2D theCoordinate;
                double latitude = [[dict objectForKey:@"lat"] doubleValue];
                double longitude = [[dict objectForKey:@"lng"] doubleValue];
                theCoordinate.latitude = latitude;
                theCoordinate.longitude = longitude;
                
                CurrentLocationAnnotation *theLocation = [[[CurrentLocationAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil] autorelease];
                [theLocation setTitle:addtitle];
                [theLocation setSubtitle:[NSString stringWithFormat:@"%@,%@",[dict objectForKey:@"lat"],[dict objectForKey:@"lng"]]];
                [theLocation setLatlong:[NSString stringWithFormat:@"%@_%@",[dict objectForKey:@"lat"],[dict objectForKey:@"lng"]]];
                if([[dict objectForKey:@"pin_type"] intValue] == 1){
                    [theLocation setType:@"critical"];
                }else{
                    [theLocation setType:@"normal"];
                }
                [theLocation setTag:[dict objectForKey:@"pin_id"]];
                [theLocation setUpdateCount:[dict objectForKey:@"update_count"]];
                [mapAnnotations addObject:theLocation];
                
            }
            [mvMapView addAnnotations:mapAnnotations];
            [mvMapView setDelegate:self];
            
        }else if (request.tag == 515){
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
                NSLog(@"- %@",[(NSDictionary *)[address_components objectAtIndex:0] objectForKey:@"long_name"]);
                NSLog(@"- %@",[(NSDictionary *)[address_components objectAtIndex:1] objectForKey:@"long_name"]);
                //            NSLog(@"long_name %@", [(NSDictionary *)[address_components objectAtIndex:0] objectForKey:@"long_name"]);
                if ([address_components count] > 2) {
                    
                    [self setAddress1:[(NSDictionary *)[address_components objectAtIndex:0] objectForKey:@"long_name"]];
                    [self setAddress2:[(NSDictionary *)[address_components objectAtIndex:1] objectForKey:@"long_name"]];
                    [selectedAnnotation setTitle:[NSString stringWithFormat:@"%@ %@",[(NSDictionary *)[address_components objectAtIndex:0] objectForKey:@"long_name"],[(NSDictionary *)[address_components objectAtIndex:1] objectForKey:@"long_name"]]];
                }else if([address_components count] > 1) {
                    
                    [self setAddress1:[(NSDictionary *)[address_components objectAtIndex:0] objectForKey:@"long_name"]];
                    [self setAddress2:@""];
                    [selectedAnnotation setTitle:[NSString stringWithFormat:@"%@",[(NSDictionary *)[address_components objectAtIndex:0] objectForKey:@"long_name"]]];
                }else{
                    [selectedAnnotation setTitle:@"Unknown"];
                }
                //[selectedAnnotation setSubtitle:[NSString stringWithFormat:@"%f,%f",selectedAnnotation.coordinate.latitude,selectedAnnotation.coordinate.longitude]];
            }else{
                [selectedAnnotation setTitle:@"Unknown"];
            }
        }else if (request.tag == 616){
            
        }
    }
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - Map Features

- (void)addPoint
{
    //selectedAnnotation = [[[CurrentLocationAnnotation alloc] initWithCoordinate:self.currentLocation.coordinate addressDictionary:nil] autorelease];
    //	annotation.title = [[NSString alloc] initWithFormat:@"%d", [mvMapView.annotations count] + 1];
    //	annotation.subtitle = @"Drag pin to set poisition.";
    //    
    //    [mvMapView addAnnotation:annotation];
    //    [annotation release];
    
    selectedAnnotation = [[[CurrentLocationAnnotation alloc] initWithCoordinate:self.currentLocation.coordinate addressDictionary:nil] autorelease];
    
    NSString *_url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f2&language=th&sensor=false", selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude];
    NSString *_fixedURL = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)_url, NULL, NULL, kCFStringEncodingUTF8);
    [selectedAnnotation setType:@"new"];
    
    // initiate request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:_fixedURL]];
    [request setTag:515];
    [request setDelegate:self];
    [request startAsynchronous];
    
    
    // add HUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Getting Coordinates";
    
    
    //[mvMapView removeAnnotations:mapAnnotations];
    [mapAnnotations addObject:selectedAnnotation];
	[mvMapView addAnnotation:selectedAnnotation];
    
    
    [mvMapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude), MKCoordinateSpanMake(0.001, 0.001)) animated:YES];
    
    //Show sub-menu
    [self showSubMenu];
    
    
    //disable add point button
    [[self.navigationItem rightBarButtonItem] setEnabled:NO];
}

- (void)searchPoint
{
    [self showOrHideSearchBar];
}


#pragma mark
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
    
    
    mapAnnotations = [[NSMutableArray alloc] init];
    [mvMapView setMapType:MKMapTypeStandard];
	[mvMapView setDelegate:self];
    [mvMapView setShowsUserLocation:YES];
    
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [mvMapView removeAnnotations:mapAnnotations]; 
    [self getAllPin];
}

- (void)viewDidUnload
{
    [self setSelectedAnnotation:nil];
    [self setAddress2:nil];
    [self setAddress1:nil];
    [self setMapAnnotations:nil];
    [self setMvMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [selectedAnnotation release];
    [address2 release];
    [address1 release];
    [mapAnnotations release];
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

- (void)getAllPin
{
    NSString *_url = [NSString stringWithFormat:@"http://www.appspheregroup.com/flood/getallpin.php"];
    NSString *_fixedURL = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)_url, NULL, NULL, kCFStringEncodingUTF8);
    
    
    // initiate request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:_fixedURL]];
    [request setDelegate:self];
    [request startAsynchronous];
    [request setTag:414];
    
    // add HUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
}

- (IBAction)cancleAdd:(UIButton*)sender {
    
    //#Tong Please remove the pin here
    [mvMapView removeAnnotation:selectedAnnotation];
    
    
    [self hideSubMenu];
    //enable add point button
    [[self.navigationItem rightBarButtonItem] setEnabled:YES];
}

- (IBAction)submitAdd:(UIButton*)sender {
    Tab1AddViewController *addViewController = [[Tab1AddViewController alloc] initWithNibName:@"Tab1AddViewController" bundle:nil];
    [addViewController setSelectedAnnotation:selectedAnnotation];
    [addViewController setAddress1:address1];
    [addViewController setAddress2:address2];
    [self.navigationController pushViewController:addViewController animated:YES];
    [addViewController release];
    [self hideSubMenu];
    
    //enable add point button
    [[self.navigationItem rightBarButtonItem] setEnabled:YES];
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
