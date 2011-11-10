//
//  Tab1PinTableViewCell.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/9/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface Tab1PinTableViewCell : UITableViewCell<ASIHTTPRequestDelegate>
{
    IBOutlet UILabel *time;
    IBOutlet UILabel *description;
    IBOutlet UIImageView *level;
    IBOutlet UIImageView *pic;
    ASIHTTPRequest *request;
}

@property (nonatomic ,strong) IBOutlet UILabel *time;
@property (nonatomic ,strong) IBOutlet UILabel *description;
@property (nonatomic ,strong) IBOutlet UIImageView *level;
@property (nonatomic ,strong) IBOutlet UIImageView *pic;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) ASIHTTPRequest *request;

- (void)startLoading;
- (void)stopLoading;
- (void)thumbnailFromURL:(NSURL*)url;
@end
