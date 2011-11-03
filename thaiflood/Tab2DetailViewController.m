//
//  Tab2DetailViewController.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Tab2DetailViewController.h"
#import "Tab2ShareFacebookViewController.h"
#import "Tab2ShareTwitterViewController.h"

@implementation Tab2DetailViewController
@synthesize annoucementDetail;
@synthesize detailTextView;
@synthesize dateDiffLabel;
@synthesize titleLabel;
@synthesize request;

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
    // Do any additional setup after loading the view from its nib.[self.navigationItem setTitle:@""];
    UIImageView *_titleText = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"text_announcement.png"]];
    [self.navigationItem setTitleView:_titleText];
    [_titleText release];
    
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
    
    //set data
    [self setData];
    
    
}

- (void)viewDidUnload
{
    [self setDetailTextView:nil];
    [self setDateDiffLabel:nil];
    [self setAnnoucementDetail:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [self.request setDelegate:nil];
    [self.request cancel];
    [self.request release];
    [detailTextView release];
    [dateDiffLabel release];
    [annoucementDetail release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-
#pragma mark Custom Method
-(NSString *)dateDiff:(NSString *)origDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *convertedDate = [df dateFromString:origDate];
    [df release];
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"just now";
    } else      if (ti < 60) {
        int diff = round(ti);
        return [NSString stringWithFormat:@"%d seconds ago", diff];
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
        return @"never";
    }   
}

-(NSString *)getDateFrom:(NSString *)origDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *convertedDate = [df dateFromString:origDate];
    [df setDateFormat:@"d/MM/yyyy"];
    NSString *dateOnly = [NSString stringWithString:[df stringFromDate:convertedDate]];
    [df release];
    return dateOnly; 
}

-(NSString *)getTimeFrom:(NSString *)origDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *convertedDate = [df dateFromString:origDate];
    [df setDateFormat:@"HH:mm:ss"];
    NSString *timeOnly = [NSString stringWithString:[df stringFromDate:convertedDate]];
    [df release];
    return timeOnly; 
}

- (void)setData
{
    //set value
    [self.dateDiffLabel setText:[self dateDiff:[annoucementDetail objectForKey:@"created_date"]]];
    [self.titleLabel setText:[annoucementDetail objectForKey:@"title"]];
    [self.detailTextView setText:[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n%@",[annoucementDetail objectForKey:@"description"]]];
    
    UIActivityIndicatorView *_loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_loadingView setTag:66];
    [_loadingView setFrame:CGRectMake(150, 71, 20, 20)];
    [_loadingView startAnimating];
    [self.detailTextView addSubview:_loadingView];
    [_loadingView release];
    
    [self.request setDelegate:nil];
    [self.request cancel];
    [self.request release];
    NSURL *_url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.appspheregroup.com/flood/thumbnail/%@",[annoucementDetail objectForKey:@"picture"]]];
    self.request = [ASIHTTPRequest requestWithURL:_url];
    [self.request setDelegate:self];
    [self.request startAsynchronous];
    
}

- (IBAction)shareFacebook:(id)sender {
    Tab2ShareFacebookViewController *detailViewController = [[Tab2ShareFacebookViewController alloc] initWithNibName:@"Tab2ShareFacebookViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (IBAction)shareTwitter:(id)sender {
    Tab2ShareTwitterViewController *detailViewController = [[Tab2ShareTwitterViewController alloc] initWithNibName:@"Tab2ShareTwitterViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

#pragma mark Request
- (void)requestFinished:(ASIHTTPRequest *)_request
{
    NSData *responseData = [_request responseData];
    UIImageView *_pic = [[UIImageView alloc]initWithImage:[UIImage imageWithData:responseData]];
    [_pic setFrame:CGRectMake(72, 17, 175, 128)];
    [self.detailTextView addSubview:_pic];
    [_pic release];
    UIImageView *_border = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_border_big.png"]];
    [_border setFrame:CGRectMake(64, 9, 190, 143)];
    [self.detailTextView addSubview:_border];
    [_border release];
    
    UIActivityIndicatorView *_loadingView = (UIActivityIndicatorView*)[self.detailTextView viewWithTag:66];
    [_loadingView stopAnimating];
    [_loadingView removeFromSuperview];
}

- (void)requestFailed:(ASIHTTPRequest *)_request
{
    //NSError *error = [request error];
}
@end
