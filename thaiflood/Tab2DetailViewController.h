//
//  Tab2DetailViewController.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface Tab2DetailViewController : UIViewController <ASIHTTPRequestDelegate>
{
    
    NSDictionary *annoucementDetail;
    ASIHTTPRequest *request;
    
}

@property (nonatomic, retain) NSDictionary *annoucementDetail;
@property (retain, nonatomic) IBOutlet UITextView *detailTextView;
@property (retain, nonatomic) IBOutlet UILabel *dateDiffLabel;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) ASIHTTPRequest *request;

- (IBAction)shareFacebook:(id)sender;
- (IBAction)shareTwitter:(id)sender;
- (void)setData;

@end
