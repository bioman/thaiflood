//
//  Tab2TableViewCell.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface Tab2TableViewCell : UITableViewCell <ASIHTTPRequestDelegate>
{
    IBOutlet UILabel *time;
    IBOutlet UILabel *tilte;
    IBOutlet UILabel *detail;
    ASIHTTPRequest *request;
}

@property (nonatomic, strong) IBOutlet UILabel *time;
@property (nonatomic, strong) IBOutlet UILabel *tilte;
@property (nonatomic, strong) IBOutlet UILabel *detail;
@property (nonatomic, strong) IBOutlet UIImageView *thumb;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) ASIHTTPRequest *request;

- (void)startLoading;
- (void)stopLoading;
- (void)thumbnailFromURL:(NSURL*)url;

@end
