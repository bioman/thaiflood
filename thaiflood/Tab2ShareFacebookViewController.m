//
//  Tab2ShareFacebook.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Tab2ShareFacebookViewController.h"
#import "Social.h"

#define TAG_SETTING         200
#define TAG_LOGO            201

#define TAG_SHARE_NAME      101
#define TAG_SHARE_DATE      102
#define TAG_SHARE_FRAME     104
#define TAG_SHARE_PICTURE   105

#define TAG_MESSAGE_BOX     106

@implementation Tab2ShareFacebookViewController

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
    // Do any additional setup after loading the view from its nib.
    UIImageView *_titleText = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"text_share.png"]];
    [self.navigationItem setTitleView:_titleText];
    [_titleText release];
    
    UIImage *buttonImage = [UIImage imageNamed:@"button_back.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(backToDetail) forControlEvents:UIControlEventTouchUpInside];
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

- (UIView*)getView:(NSInteger)_tag
{
    return [self.view viewWithTag:_tag];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (![[Social sharedSocial] isDidLogInFacebook]) {
        [[self getView:TAG_SETTING] setHidden:NO];
        [[self getView:TAG_LOGO] setHidden:NO];
        
        [[self getView:TAG_SHARE_NAME] setHidden:YES];
        [[self getView:TAG_SHARE_DATE] setHidden:YES]; 
        [[self getView:TAG_SHARE_FRAME] setHidden:YES];
        [[self getView:TAG_SHARE_PICTURE] setHidden:YES];
        
        UIImage *buttonImage2 = [UIImage imageNamed:@"button_post.png"];
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 addTarget:self action:@selector(postFacebook) forControlEvents:UIControlEventTouchUpInside];
        [button2 setEnabled:NO];
        [button2 setImage:buttonImage2 forState:UIControlStateNormal];
        button2.frame = CGRectMake(0, 0, buttonImage2.size.width, buttonImage2.size.height);
        UIBarButtonItem *customBarItem2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
        [self.navigationItem setRightBarButtonItem:customBarItem2];
        [customBarItem2 release];
    }else{
        [[self getView:TAG_SETTING] setHidden:YES];
        [[self getView:TAG_LOGO] setHidden:YES];
        
        [[self getView:TAG_SHARE_NAME] setHidden:NO];
        [[self getView:TAG_SHARE_DATE] setHidden:NO]; 
        [[self getView:TAG_SHARE_FRAME] setHidden:NO];
        [[self getView:TAG_SHARE_PICTURE] setHidden:NO];
        
        UILabel *_name = (UILabel*)[self getView:TAG_SHARE_NAME];
        UILabel *_date = (UILabel*)[self getView:TAG_SHARE_DATE];
        UIImageView *_pic = (UIImageView*)[self getView:TAG_SHARE_PICTURE];
        NSDictionary *_social = [[[Social sharedSocial] socialPlist] objectForKey:@"Facebook"];
        [_name setText:[_social objectForKey:@"name"]];
        [_pic setImage:[UIImage imageWithContentsOfFile:[_social objectForKey:@"picture"]]];
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMMM,dd yyyy hh:mm a"];
        NSString *dateString = [dateFormat stringFromDate:today];
        [_date setText:dateString];
        [dateFormat release];
        
        UIImage *buttonImage2 = [UIImage imageNamed:@"button_post.png"];
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 addTarget:self action:@selector(postFacebook) forControlEvents:UIControlEventTouchUpInside];
        [button2 setEnabled:YES];
        [button2 setImage:buttonImage2 forState:UIControlStateNormal];
        button2.frame = CGRectMake(0, 0, buttonImage2.size.width, buttonImage2.size.height);
        UIBarButtonItem *customBarItem2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
        [self.navigationItem setRightBarButtonItem:customBarItem2];
        [customBarItem2 release];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) backToDetail
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) postFacebook
{
    
}

- (IBAction)dismissKeyboard:(id)sender {
    [[self getView:TAG_MESSAGE_BOX] resignFirstResponder];
}

@end
