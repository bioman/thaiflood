//
//  Tab2ShareFacebook.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Social2ShareDelegate.h"
#import "ASIHTTPRequest.h"

@interface Tab2ShareFacebookViewController : UIViewController <Social2ShareDelegate, ASIHTTPRequestDelegate>
{
    NSDictionary *shareDetail;
    ASIHTTPRequest *request;
}
@property (nonatomic, retain) NSDictionary *shareDetail;
@property (nonatomic, retain) ASIHTTPRequest *request;

- (IBAction)dismissKeyboard:(id)sender;
@end
