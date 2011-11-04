//
//  Tab4MainViewController.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Tab4MainViewController.h"
#import "Social.h"

@implementation Tab4MainViewController

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
    [self.navigationItem setTitle:@""];
    UIImageView *_titleText = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"text_setting.png"]];
    [self.navigationItem setTitleView:_titleText];
    [_titleText release];
    
    CGColorRef darkColor = [[UIColor blackColor] colorWithAlphaComponent:.3f].CGColor;
    CGColorRef lightColor = [UIColor clearColor].CGColor;
    CGFloat navigationBarBottom = 0.0;
    CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];
    newShadow.frame = CGRectMake(0,navigationBarBottom, self.view.frame.size.width, 3);
    newShadow.colors = [NSArray arrayWithObjects:(id)darkColor, (id)lightColor, nil];
    [self.view.layer addSublayer:newShadow];
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

- (IBAction)facebookSignInTap:(id)sender {
    [[Social sharedSocial] logInFacebook:self];
}

- (IBAction)twitterSignInTap:(id)sender {
    
}

- (void)facebookDidFinishLogIn
{
    NSDictionary *_social = [[[Social sharedSocial] socialPlist] objectForKey:@"Facebook"];
    UIView *_logoFB = [self.view viewWithTag:41];
    [UIView animateWithDuration:0.3 animations:^{
        [_logoFB setAlpha:0.0];
        [_logoFB setHidden:YES];
    } completion:^(BOOL finished){
        UIView *_frameFB = [self.view viewWithTag:51];
        UIImageView *_picFB = (UIImageView*)[self.view viewWithTag:31];
        [_picFB setImage:[UIImage imageWithContentsOfFile:[_social objectForKey:@"picture"]]];
        [_frameFB setAlpha:0.0];
        [_frameFB setHidden:NO];
        [_picFB setAlpha:0.0];
        [_picFB setHidden:NO];
        [UIView animateWithDuration:0.3 animations:^{
            [_frameFB setAlpha:1.0];
            [_picFB setAlpha:1.0];
        } completion:^(BOOL finished){
            
        }];
    }];
}

- (void)facebookDidFinishLogOut
{
    
}

- (void)twitterDidFinishLogIn
{
    
}

- (void)twitterDidFinishLogOut
{
    
}

@end
