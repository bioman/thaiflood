//
//  CurrentLocationAnnotation.h
//  iOS4DragDrop
//
//  Created by Trent Kocurek on 7/21/10.
//  Copyright Urban Coding 2010. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CurrentLocationAnnotation : MKPlacemark {
	
}

@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *tag;

@end