//
//  Tab1PinDetailViewController.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/9/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Tab1PinDetailViewController.h"

@implementation Tab1PinDetailViewController
@synthesize details, request;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *buttonImage = [UIImage imageNamed:@"button_back.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:customBarItem];
    [customBarItem release];
    
    CGColorRef darkColor = [[UIColor blackColor] colorWithAlphaComponent:.3f].CGColor;
    CGColorRef lightColor = [UIColor clearColor].CGColor;
    CGFloat navigationBarBottom = 0.0;
    CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];
    newShadow.frame = CGRectMake(0,navigationBarBottom, self.view.frame.size.width, 3);
    newShadow.colors = [NSArray arrayWithObjects:(id)darkColor, (id)lightColor, nil];
    [self.view.layer addSublayer:newShadow];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:[details objectForKey:@"date_diff"]];
    [dateLabel setText:[details objectForKey:@"date"]];
    [timeLabel setText:[details objectForKey:@"time"]];
    [timediffLabel setText:[details objectForKey:@"date_diff"]];
    NSString *_urlStr = [details objectForKey:@"pic"];
    NSRange textRange = [_urlStr rangeOfString:@"googleapis"];
    if(textRange.location == NSNotFound)
    {
        [descriptionLabel setText:[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n%@",[details objectForKey:@"description"]]];
        UIActivityIndicatorView *_loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_loadingView setTag:66];
        [_loadingView setFrame:CGRectMake(118, 102, 20, 20)];
        [_loadingView startAnimating];
        [descriptionLabel addSubview:_loadingView];
        [_loadingView release];
        
        [self.request setDelegate:nil];
        [self.request cancel];
        [self.request release];
        NSURL *_url = [NSURL URLWithString:_urlStr];
        self.request = [ASIHTTPRequest requestWithURL:_url];
        [self.request setDelegate:self];
        [self.request startAsynchronous];
    }else{
        [descriptionLabel setText:[NSString stringWithFormat:@"%@",[details objectForKey:@"description"]]];
    }
    
    
    
}

- (void)viewDidUnload
{
    [dateLabel release];
    dateLabel = nil;
    [timeLabel release];
    timeLabel = nil;
    [descriptionLabel release];
    descriptionLabel = nil;
    [timediffLabel release];
    timediffLabel = nil;
    [levelImage release];
    levelImage = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) startViewData:(NSDictionary*)data
{
    [self setDetails:data];
}

- (void) backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [self.request setDelegate:nil];
    [self.request cancel];
    [self.request release];
    [details release];
    [dateLabel release];
    [timeLabel release];
    [descriptionLabel release];
    [timediffLabel release];
    [levelImage release];
    [super dealloc];
}

#pragma mark Request
- (void)requestFinished:(ASIHTTPRequest *)_request
{
    NSData *responseData = [_request responseData];
    UIImageView *_pic = [[UIImageView alloc]initWithImage:[UIImage imageWithData:responseData]];
    [_pic setFrame:CGRectMake(28, 12, 200, 200)];
    [_pic setClipsToBounds:YES];
    [_pic setContentMode:UIViewContentModeScaleAspectFill];
    [descriptionLabel addSubview:_pic];
    [_pic release];
    UIImageView *_border = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_border_pic.png"]];
    [_border setFrame:CGRectMake(28, 12, 200, 200)];
    [descriptionLabel addSubview:_border];
    [_border release];
    
    UIActivityIndicatorView *_loadingView = (UIActivityIndicatorView*)[descriptionLabel viewWithTag:66];
    [_loadingView stopAnimating];
    [_loadingView removeFromSuperview];
}

- (void)requestFailed:(ASIHTTPRequest *)_request
{
    //NSError *error = [request error];
}
@end
