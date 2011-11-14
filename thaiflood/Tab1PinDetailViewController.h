//
//  Tab1PinDetailViewController.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/9/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface Tab1PinDetailViewController : UIViewController <ASIHTTPRequestDelegate>
{
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *timediffLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UITextView *descriptionLabel;
    IBOutlet UIImageView *levelImage;
    ASIHTTPRequest *request;
}
@property (nonatomic, strong) NSDictionary *details;
@property (nonatomic, retain) ASIHTTPRequest *request;
- (void) startViewData:(NSDictionary*)data;
@end
