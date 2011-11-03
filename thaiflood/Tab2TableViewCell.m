//
//  Tab2TableViewCell.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import "Tab2TableViewCell.h"

@implementation Tab2TableViewCell
@synthesize loadingIndicator;
@synthesize mainView;
@synthesize time, tilte, detail, thumb, request;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)startLoading
{
    [loadingIndicator setHidden:NO];
    [loadingIndicator startAnimating];
}

- (void)stopLoading
{
    [loadingIndicator stopAnimating];
    [loadingIndicator setHidden:YES];
}

- (void)thumbnailFromURL:(NSURL*)url
{
    [self startLoading];
    [self.request setDelegate:nil];
    [self.request cancel];
    [self.request release];
    self.request = [ASIHTTPRequest requestWithURL:url];
    [self.request setDelegate:self];
    [self.request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)_request
{
    NSData *responseData = [_request responseData];
    [self.thumb setImage:[UIImage imageWithData:responseData]];
    [self stopLoading];
}

- (void)requestFailed:(ASIHTTPRequest *)_request
{
    //NSError *error = [request error];
    [self stopLoading];
}

- (void)dealloc {
    [self.request setDelegate:nil];
    [self.request cancel];
    [self.request release];
    [time release];
    [tilte release];
    [detail release];
    [loadingIndicator release];
    [mainView release];
    [super dealloc];
}
@end
