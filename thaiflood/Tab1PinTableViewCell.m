//
//  Tab1PinTableViewCell.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/9/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import "Tab1PinTableViewCell.h"

@implementation Tab1PinTableViewCell
@synthesize time, description, level, pic, request,loadingIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    [self.pic setImage:[UIImage imageWithData:responseData]];
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
    [level release];
    [description release];
    [loadingIndicator release];
    [pic release];
    [super dealloc];
}
@end
