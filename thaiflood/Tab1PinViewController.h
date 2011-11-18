//
//  Tab1PinViewController.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/9/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@class  CurrentLocationAnnotation;
@interface Tab1PinViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate>
{
    NSString *latlong;
    CurrentLocationAnnotation *selectedAnnotation;
}

@property (nonatomic, strong) NSMutableArray *details;
@property (nonatomic, strong) NSString *latlong;
@property (retain, nonatomic) CurrentLocationAnnotation *selectedAnnotation;

- (void) startViewData:(NSDictionary*)data;

@end
