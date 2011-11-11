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
@synthesize details;

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
    [descriptionLabel setText:[details objectForKey:@"description"]];
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
    [details release];
    [dateLabel release];
    [timeLabel release];
    [descriptionLabel release];
    [timediffLabel release];
    [levelImage release];
    [super dealloc];
}
@end
