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
#import "MBProgressHUD.h"

#define TAG_SETTING         200
#define TAG_LOGO            201

#define TAG_SHARE_NAME      101
#define TAG_SHARE_DATE      102
#define TAG_SHARE_FRAME     104
#define TAG_SHARE_PICTURE   105

#define TAG_MESSAGE_BOX     106
#define TAG_DESCRIPTION_BOX 107
#define TAG_TITLE_BOX       108

@interface Tab2ShareFacebookViewController (Privated)
- (UIView*)getView:(NSInteger)_tag;
@end

@implementation Tab2ShareFacebookViewController
@synthesize shareDetail,request;

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
    
    [((UILabel*)[self getView:TAG_TITLE_BOX]) setText:[shareDetail objectForKey:@"title"]];
    
    NSString *_newline = @"\n\n\n\n\n\n\n\n";
    NSRange textRange = [[shareDetail objectForKey:@"picture"] rangeOfString:@"water_level"];
    if(textRange.location == NSNotFound)
    {
        UIActivityIndicatorView *_loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_loadingView setTag:66];
        [_loadingView setFrame:CGRectMake(140, 60, 20, 20)];
        [_loadingView startAnimating];
        [((UITextView*)[self getView:TAG_DESCRIPTION_BOX]) addSubview:_loadingView];
        [_loadingView release];
        
        [self.request setDelegate:nil];
        [self.request cancel];
        [self.request release];
        NSURL *_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[shareDetail objectForKey:@"picture"]]];
        self.request = [ASIHTTPRequest requestWithURL:_url];
        [self.request setDelegate:self];
        [self.request startAsynchronous];
    }else{
        _newline = @"";
    }
    
    NSString *_substr = [shareDetail objectForKey:@"description"];
    if ([[shareDetail objectForKey:@"description"] length] > 50) {
        _substr = [[shareDetail objectForKey:@"description"] substringToIndex:50];
        [((UITextView*)[self getView:TAG_DESCRIPTION_BOX]) setText:[NSString stringWithFormat:@"%@%@", _newline, [NSString stringWithFormat:@"%@...", _substr]]];
    }else{
        [((UITextView*)[self getView:TAG_DESCRIPTION_BOX]) setText:[NSString stringWithFormat:@"%@%@", _newline, [NSString stringWithFormat:@"%@", _substr]]];
    }

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

-(void)dealloc
{
    [self.request setDelegate:nil];
    [self.request cancel];
    [self.request release];
    [shareDetail release];
    [super dealloc];
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
    [[self getView:TAG_MESSAGE_BOX] resignFirstResponder];
    [[self getView:TAG_DESCRIPTION_BOX] resignFirstResponder];
    
    NSString *_title2 = [shareDetail objectForKey:@"title"];
    NSString *_type = [shareDetail objectForKey:@"type"];
    NSString *_message = ((UITextView*)[self getView:TAG_MESSAGE_BOX]).text;
    NSString *_description = [shareDetail objectForKey:@"description"];
    NSString *_image = [shareDetail objectForKey:@"picture"];
    NSLog(@"image: %@",[shareDetail objectForKey:@"picture"]);
    
    // add HUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Posting";
    
    [[Social sharedSocial] shareFacebookFloodTitle:_title2 detail:_description linkURL:@"http://www.appspheregroup.com" imageURL:_image caption:_type messsage:_message withDelegate:self];
}

-(void) didFinishShare
{
    NSLog(@"Share Successful");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismissKeyboard:(id)sender {
    [[self getView:TAG_MESSAGE_BOX] resignFirstResponder];
    [[self getView:TAG_DESCRIPTION_BOX] resignFirstResponder];
}

#pragma mark - Request
- (void)requestFinished:(ASIHTTPRequest *)_request
{
    UITextView *_detailTextView = (UITextView*)[self getView:TAG_DESCRIPTION_BOX];
    NSData *responseData = [_request responseData];
    UIImageView *_pic = [[UIImageView alloc]initWithImage:[UIImage imageWithData:responseData]];
    [_pic setFrame:CGRectMake(62, 6, 175, 128)];
    [_pic setClipsToBounds:YES];
    [_pic setContentMode:UIViewContentModeScaleAspectFill];
    [_detailTextView addSubview:_pic];
    [_pic release];
    UIImageView *_border = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_border_big.png"]];
    [_border setFrame:CGRectMake(54, -2, 190, 143)];
    [_detailTextView addSubview:_border];
    [_border release];
    
    UIActivityIndicatorView *_loadingView = (UIActivityIndicatorView*)[_detailTextView viewWithTag:66];
    [_loadingView stopAnimating];
    [_loadingView removeFromSuperview];
}

- (void)requestFailed:(ASIHTTPRequest *)_request
{
    //NSError *error = [request error];
}
@end
