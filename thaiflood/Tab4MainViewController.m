//
//  Tab4MainViewController.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Tab4MainViewController.h"
#import "Social.h"

#define TAG_FACEBOOK_SIGN_IN    801
#define TAG_TWITTER_SIGN_IN     802
#define TAG_FACEBOOK_SIGN_OUT   803
#define TAG_TWITTER_SIGN_OUT    804
#define TAG_FACEBOOK_LOADING    901
#define TAG_TWITTER_LOADING     902

#define TAG_FACEBOOK_TEXT       301
#define TAG_TWITTER_TEXT        302
#define TAG_FACEBOOK_NAME       303
#define TAG_TWITTER_NAME        304

#define TAG_FACEBOOK_ICON       41
#define TAG_TWITTER_ICON        42
#define TAG_FACEBOOK_BORDER     51
#define TAG_TWITTER_BORDER      52
#define TAG_FACEBOOK_PICTURE    31
#define TAG_TWITTER_PICTURE     32

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
    
    if ([[Social sharedSocial] isDidLogInFacebook]) {
        NSLog(@"if ([[Social sharedSocial] isDidLogInFacebook])");
        
        NSDictionary *_social = [[[Social sharedSocial] socialPlist] objectForKey:@"Facebook"];
        NSString *_name = [_social objectForKey:@"name"];
        NSLog(@"facebook name:%@",_name);
        UIImage *_picture = [UIImage imageWithContentsOfFile:[_social objectForKey:@"picture"]];
        
        UIView *_signinFB = [self.view viewWithTag:TAG_FACEBOOK_SIGN_IN];
        [_signinFB setHidden:YES];
        UIView *_signoutFB = [self.view viewWithTag:TAG_FACEBOOK_SIGN_OUT];
        [_signoutFB setHidden:NO];
        UIView *_logoFB = [self.view viewWithTag:TAG_FACEBOOK_ICON];
        [_logoFB setAlpha:0.0];
        [_logoFB setHidden:YES];
        UIView *_frameFB = [self.view viewWithTag:TAG_FACEBOOK_BORDER];
        UIImageView *_picFB = (UIImageView*)[self.view viewWithTag:TAG_FACEBOOK_PICTURE];
        [_picFB setImage:_picture];
        [_frameFB setAlpha:1.0];
        [_frameFB setHidden:NO];
        [_picFB setAlpha:1.0];
        [_picFB setHidden:NO];
        UIView *_textFB = [self.view viewWithTag:TAG_FACEBOOK_TEXT];
        [_textFB setFrame:CGRectMake(65, 47, 129, 9)];
        UILabel *_nameFB = (UILabel*)[self.view viewWithTag:TAG_FACEBOOK_NAME];
        [_nameFB setText:_name];
        [_nameFB setHidden:NO];
        [_nameFB setAlpha:1.0];
    }
    
    if ([[Social sharedSocial] isDidLogInTwitter]) {
        NSDictionary *_social = [[[Social sharedSocial] socialPlist] objectForKey:@"Twitter"];
        NSString *_name = [_social objectForKey:@"name"];
        NSLog(@"twitter name:%@",_name);
        UIImage *_picture = [UIImage imageWithContentsOfFile:[_social objectForKey:@"picture"]];
        
        UIView *_signinTW = [self.view viewWithTag:TAG_TWITTER_SIGN_IN];
        [_signinTW setHidden:YES];
        UIView *_signoutTW = [self.view viewWithTag:TAG_TWITTER_SIGN_OUT];
        [_signoutTW setHidden:NO];
        UIView *_logoTW = [self.view viewWithTag:TAG_TWITTER_ICON];
        [_logoTW setAlpha:0.0];
        [_logoTW setHidden:YES];
        UIView *_frameTW = [self.view viewWithTag:TAG_TWITTER_BORDER];
        UIImageView *_picTW = (UIImageView*)[self.view viewWithTag:TAG_TWITTER_PICTURE];
        [_picTW setImage:_picture];
        [_frameTW setAlpha:1.0];
        [_frameTW setHidden:NO];
        [_picTW setAlpha:1.0];
        [_picTW setHidden:NO];
        UIView *_textTW = [self.view viewWithTag:TAG_TWITTER_TEXT];
        [_textTW setFrame:CGRectMake(65, 103, 109, 9)];
        UILabel *_nameTW = (UILabel*)[self.view viewWithTag:TAG_TWITTER_NAME];
        [_nameTW setText:_name];
        [_nameTW setHidden:NO];
        [_nameTW setAlpha:1.0];
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

- (IBAction)facebookSignInTap:(id)sender {
    NSLog(@"facebookSignInTap");
    UIActivityIndicatorView *_loadingFB = (UIActivityIndicatorView*)[self.view viewWithTag:TAG_FACEBOOK_LOADING];
    UIView *_signinFB = [self.view viewWithTag:TAG_FACEBOOK_SIGN_IN];
    [_signinFB setHidden:YES];
    [_loadingFB setHidden:NO];
    [_loadingFB startAnimating];
    [[Social sharedSocial] logInFacebook:self];
}

- (void)facebookDidFinishLogIn
{
    NSLog(@"facebookDidFinishLogIn");
    
    UIActivityIndicatorView *_loadingFB = (UIActivityIndicatorView*)[self.view viewWithTag:TAG_FACEBOOK_LOADING];
    [_loadingFB stopAnimating];
    [_loadingFB setHidden:YES];
    UIView *_signoutFB = [self.view viewWithTag:TAG_FACEBOOK_SIGN_OUT];
    [_signoutFB setHidden:NO];
    
    NSDictionary *_social = [[[Social sharedSocial] socialPlist] objectForKey:@"Facebook"];
    UIView *_logoFB = [self.view viewWithTag:TAG_FACEBOOK_ICON];
    [UIView animateWithDuration:0.3 animations:^{
        [_logoFB setAlpha:0.0];
    } completion:^(BOOL finished){
        [_logoFB setHidden:YES];
        UIView *_frameFB = [self.view viewWithTag:TAG_FACEBOOK_BORDER];
        UIImageView *_picFB = (UIImageView*)[self.view viewWithTag:TAG_FACEBOOK_PICTURE];
        [_picFB setImage:[UIImage imageWithContentsOfFile:[_social objectForKey:@"picture"]]];
        [_frameFB setAlpha:0.0];
        [_frameFB setHidden:NO];
        [_picFB setAlpha:0.0];
        [_picFB setHidden:NO];
        [UIView animateWithDuration:0.3 animations:^{
            [_frameFB setAlpha:1.0];
            [_picFB setAlpha:1.0];
        } completion:^(BOOL finished){
            UIView *_textFB = [self.view viewWithTag:TAG_FACEBOOK_TEXT];
            UILabel *_nameFB = (UILabel*)[self.view viewWithTag:TAG_FACEBOOK_NAME];
            [_nameFB setText:[_social objectForKey:@"name"]];
            [_nameFB setHidden:NO];
            [UIView animateWithDuration:0.3 animations:^{
                [_nameFB setAlpha:1.0];
                [_textFB setFrame:CGRectMake(65, 47, 129, 9)];
            } completion:^(BOOL finished){
                
            }];
        }];
    }];
}

- (IBAction)facebookSignOutTap:(id)sender {
    NSLog(@"facebookSignOutTap");
    UIActivityIndicatorView *_loadingFB = (UIActivityIndicatorView*)[self.view viewWithTag:TAG_FACEBOOK_LOADING];
    UIView *_signoutFB = [self.view viewWithTag:TAG_FACEBOOK_SIGN_OUT];
    [_signoutFB setHidden:YES];
    [_loadingFB setHidden:NO];
    [_loadingFB startAnimating];
    [[Social sharedSocial] logOutFacebook:self];
}

- (void)facebookDidFinishLogOut
{
    NSLog(@"facebookDidFinishLogOut");
    UIActivityIndicatorView *_loadingFB = (UIActivityIndicatorView*)[self.view viewWithTag:TAG_FACEBOOK_LOADING];
    [_loadingFB stopAnimating];
    [_loadingFB setHidden:YES];
    UIView *_signinFB = [self.view viewWithTag:TAG_FACEBOOK_SIGN_IN];
    [_signinFB setHidden:NO];
    
    UIView *_textFB = [self.view viewWithTag:TAG_FACEBOOK_TEXT];
    UILabel *_nameFB = (UILabel*)[self.view viewWithTag:TAG_FACEBOOK_NAME];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [_nameFB setAlpha:0.0];
        [_textFB setFrame:CGRectMake(65, 55, 129, 9)];
        
        
    } completion:^(BOOL finished){
        [_nameFB setText:@""];
        [_nameFB setHidden:YES];
        
        
        UIView *_frameFB = [self.view viewWithTag:TAG_FACEBOOK_BORDER];
        UIImageView *_picFB = (UIImageView*)[self.view viewWithTag:TAG_FACEBOOK_PICTURE];
        [UIView animateWithDuration:0.3 animations:^{
            [_frameFB setAlpha:0.0];
            [_picFB setAlpha:0.0];
        } completion:^(BOOL finished){
            [_frameFB setHidden:YES];
            [_picFB setHidden:YES];
            
            UIView *_logoFB = [self.view viewWithTag:TAG_FACEBOOK_ICON];
            [_logoFB setHidden:NO];
            [UIView animateWithDuration:0.3 animations:^{
                [_logoFB setAlpha:1.0];
            } completion:^(BOOL finished){
                
            }];
        }];
    }];
}

-(void)facebookDidCancelLogIn
{
    UIActivityIndicatorView *_loadingFB = (UIActivityIndicatorView*)[self.view viewWithTag:TAG_FACEBOOK_LOADING];
    [_loadingFB stopAnimating];
    [_loadingFB setHidden:YES];
    UIView *_signinFB = [self.view viewWithTag:TAG_FACEBOOK_SIGN_IN];
    [_signinFB setHidden:NO];
}

#pragma mark - Twitter

- (IBAction)twitterSignInTap:(id)sender {
    NSLog(@"twitterSignInTap");
    UIActivityIndicatorView *_loadingTW = (UIActivityIndicatorView*)[self.view viewWithTag:TAG_TWITTER_LOADING];
    UIView *_signinTW = [self.view viewWithTag:TAG_TWITTER_SIGN_IN];
    [_signinTW setHidden:YES];
    [_loadingTW setHidden:NO];
    [_loadingTW startAnimating];
    [[Social sharedSocial] logInTwitter:self];
}

- (void)twitterDidFinishLogIn
{
    NSLog(@"twitterDidFinishLogIn");
    
    UIActivityIndicatorView *_loadingTW = (UIActivityIndicatorView*)[self.view viewWithTag:TAG_TWITTER_LOADING];
    [_loadingTW stopAnimating];
    [_loadingTW setHidden:YES];
    UIView *_signoutTW = [self.view viewWithTag:TAG_TWITTER_SIGN_OUT];
    [_signoutTW setHidden:NO];
    
    NSDictionary *_social = [[[Social sharedSocial] socialPlist] objectForKey:@"Twitter"];
    UIView *_logoTW = [self.view viewWithTag:TAG_TWITTER_ICON];
    [UIView animateWithDuration:0.3 animations:^{
        [_logoTW setAlpha:0.0];
    } completion:^(BOOL finished){
        [_logoTW setHidden:YES];
        UIView *_frameTW = [self.view viewWithTag:TAG_TWITTER_BORDER];
        UIImageView *_picTW = (UIImageView*)[self.view viewWithTag:TAG_TWITTER_PICTURE];
        [_picTW setImage:[UIImage imageWithContentsOfFile:[_social objectForKey:@"picture"]]];
        [_frameTW setAlpha:0.0];
        [_frameTW setHidden:NO];
        [_picTW setAlpha:0.0];
        [_picTW setHidden:NO];
        [UIView animateWithDuration:0.3 animations:^{
            [_frameTW setAlpha:1.0];
            [_picTW setAlpha:1.0];
        } completion:^(BOOL finished){
            UIView *_textTW = [self.view viewWithTag:TAG_TWITTER_TEXT];
            UILabel *_nameTW = (UILabel*)[self.view viewWithTag:TAG_TWITTER_NAME];
            [_nameTW setText:[_social objectForKey:@"name"]];
            [_nameTW setHidden:NO];
            [UIView animateWithDuration:0.3 animations:^{
                [_nameTW setAlpha:1.0];
                [_textTW setFrame:CGRectMake(65, 103, 109, 9)];
            } completion:^(BOOL finished){
                
            }];
        }];
    }];
}

- (IBAction)twitterSignOutTap:(id)sender 
{
    NSLog(@"twitterSignOutTap");
    UIActivityIndicatorView *_loadingTW = (UIActivityIndicatorView*)[self.view viewWithTag:TAG_TWITTER_LOADING];
    UIView *_signoutTW = [self.view viewWithTag:TAG_TWITTER_SIGN_OUT];
    [_signoutTW setHidden:YES];
    [_loadingTW setHidden:NO];
    [_loadingTW startAnimating];
    [[Social sharedSocial] logOutTwitter:self];
}

- (void)twitterDidFinishLogOut
{
    NSLog(@"twitterDidFinishLogOut");
    UIActivityIndicatorView *_loadingTW = (UIActivityIndicatorView*)[self.view viewWithTag:TAG_TWITTER_LOADING];
    [_loadingTW stopAnimating];
    [_loadingTW setHidden:YES];
    UIView *_signinTW = [self.view viewWithTag:TAG_TWITTER_SIGN_IN];
    [_signinTW setHidden:NO];
    
    UIView *_textTW = [self.view viewWithTag:TAG_TWITTER_TEXT];
    UILabel *_nameTW = (UILabel*)[self.view viewWithTag:TAG_TWITTER_NAME];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [_nameTW setAlpha:0.0];
        [_textTW setFrame:CGRectMake(65, 111, 109, 9)];
        
        
    } completion:^(BOOL finished){
        [_nameTW setText:@""];
        [_nameTW setHidden:YES];
        
        
        UIView *_frameTW = [self.view viewWithTag:TAG_TWITTER_BORDER];
        UIImageView *_picTW = (UIImageView*)[self.view viewWithTag:TAG_TWITTER_PICTURE];
        [UIView animateWithDuration:0.3 animations:^{
            [_frameTW setAlpha:0.0];
            [_picTW setAlpha:0.0];
        } completion:^(BOOL finished){
            [_frameTW setHidden:YES];
            [_picTW setHidden:YES];
            
            UIView *_logoTW = [self.view viewWithTag:TAG_TWITTER_ICON];
            [_logoTW setHidden:NO];
            [UIView animateWithDuration:0.3 animations:^{
                [_logoTW setAlpha:1.0];
            } completion:^(BOOL finished){
                
            }];
        }];
    }];
}

-(void)twitterDidCancelLogIn
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Account"
                                                        message:@"There are no Twitter Account on your device. Please go to Setting > Twitter to sign in your account." delegate:self 
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    UIActivityIndicatorView *_loadingTW = (UIActivityIndicatorView*)[self.view viewWithTag:TAG_TWITTER_LOADING];
    [_loadingTW stopAnimating];
    [_loadingTW setHidden:YES];
    UIView *_signinTW = [self.view viewWithTag:TAG_TWITTER_SIGN_IN];
    [_signinTW setHidden:NO];
}

@end
