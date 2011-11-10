//
//  Tab1AddViewController.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/1/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import "Tab1AddViewController.h"
#import "CurrentLocationAnnotation.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@implementation Tab1AddViewController
@synthesize dateTimeLabel;
@synthesize selectedAnnotation;
@synthesize selectedImage;
@synthesize coordinateLabel;
@synthesize staticMapImageView;
@synthesize address;
@synthesize floodLevelView;
@synthesize floodLevelScrollView;
@synthesize selectedimageView;
@synthesize descriptionTextView;
@synthesize imageData;
@synthesize address1;
@synthesize address2;
@synthesize staticMapIndicator;

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
    
    UIScrollView *_scrollView = (UIScrollView*)[self.view viewWithTag:1111];
    [_scrollView setContentSize:CGSizeMake(320, 1200)];
    
    UIImage *buttonImage = [UIImage imageNamed:@"button_back.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:customBarItem];
    [customBarItem release];
    
    UIImage *buttonImage2 = [UIImage imageNamed:@"button_post.png"];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 addTarget:self action:@selector(postUpdate) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:buttonImage2 forState:UIControlStateNormal];
    button2.frame = CGRectMake(0, 0, buttonImage2.size.width, buttonImage2.size.height);
    UIBarButtonItem *customBarItem2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    [self.navigationItem setRightBarButtonItem:customBarItem2];
    [customBarItem2 release];
    
    
    NSLog(@"address1 :%@",address1);
    NSLog(@"address2 :%@",address2);
    [self initialData];
    
}

- (void)viewDidUnload
{
    [self setAddress2:nil];
    [self setAddress1:nil];
    [self setImageData:nil];
    [self setSelectedImage:nil];
    [self setSelectedAnnotation:nil];
    [self setDateTimeLabel:nil];
    [self setCoordinateLabel:nil];
    [self setStaticMapImageView:nil];
    [self setAddress:nil];
    [self setFloodLevelView:nil];
    [self setFloodLevelScrollView:nil];
    [self setSelectedimageView:nil];
    [self setDescriptionTextView:nil];
    [self setStaticMapIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)dismissKeyboard:(id)sender {
    UIView *_text = [self.view viewWithTag:21];
    UIView *_text2 = [self.view viewWithTag:22];
    [_text resignFirstResponder];
    [_text2 resignFirstResponder];
}

- (void)dealloc {
    
    [address2 release];
    [address1 release];
    [imageData release];
    [selectedImage release];
    [selectedAnnotation release];
    [dateTimeLabel release];
    [coordinateLabel release];
    [staticMapImageView release];
    [address release];
    [floodLevelView release];
    [floodLevelScrollView release];
    [selectedimageView release];
    [descriptionTextView release];
    [staticMapIndicator release];
    [super dealloc];
}


#pragma mark - ASIHTTPRequest Delegate
- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    NSError *error = [request error];
    NSLog(@"error %@",[error localizedDescription]);
    UIAlertView* locationAlert = [[UIAlertView alloc] initWithTitle:@"Error Getting Location"
															message:[error description]
														   delegate:nil
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
	[locationAlert show];
	[locationAlert release]; 
    //textView.text = [error localizedDescription];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [staticMapIndicator stopAnimating];
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"requestStarted");
    if(request.tag == 1)
    {
        
    }else if(request.tag == 2)
    {
        NSLog(@"2");
    }
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"requestFinished");
    if (request.responseStatusCode == 200)
    {
        if(request.tag == 1)
        {
            NSData *responseData = [request responseData];
            NSLog(@"responseData %@",[NSString stringWithCString:[responseData bytes] encoding:NSUTF8StringEncoding]);
            [self.staticMapImageView setImage:[UIImage imageWithData:responseData]];
            [staticMapIndicator stopAnimating];
        }else if(request.tag == 2)
        {
            NSData *responseData = [request responseData];
            NSLog(@"responseData %@",[NSString stringWithCString:[responseData bytes] encoding:NSUTF8StringEncoding]);
            // hide HUD
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	//[self.responseVote setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	//[self.responseVote appendData:data];
    NSString *_result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"result %@",_result);

    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Failed" message:[NSString stringWithFormat:@"Please try again later. Error: %@", [error description]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
}

#pragma mark - UINavigationController Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating Height %f",[scrollView contentOffset].y);

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging Height %f",[scrollView contentOffset].y);
    if([scrollView contentOffset].y > 124)
    {
        water_level = 8;
    }else if([scrollView contentOffset].y >= 112 && [scrollView contentOffset].y < 124)
    {
        water_level = 7;
    }else if([scrollView contentOffset].y >= 96 && [scrollView contentOffset].y < 112)
    {
        water_level = 6;
    }else if([scrollView contentOffset].y >= 80 && [scrollView contentOffset].y < 96)
    {
        water_level = 5;
    }else if([scrollView contentOffset].y >= 64 && [scrollView contentOffset].y < 80)
    {
        water_level = 4;
    }else if([scrollView contentOffset].y >= 48 && [scrollView contentOffset].y < 64)
    {
        water_level = 3;
    }else if([scrollView contentOffset].y >= 32 && [scrollView contentOffset].y < 48)
    {
        water_level = 2;
    }else if([scrollView contentOffset].y >= 16 && [scrollView contentOffset].y < 32)
    {
        water_level = 1;
    }else if([scrollView contentOffset].y < 16)
    {
        water_level = 0;
    }
    NSLog(@"water level %i",water_level);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"Height %f",[scrollView contentOffset].y);
}

#pragma mark - ImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"didFinishPickingImage");
    [self setSelectedImage:image];
    [self setImageData:UIImageJPEGRepresentation(image, 0.5)];
    [self.selectedimageView setImage:selectedImage];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"didFinishPickingMediaWithInfo");
    
    // Access the uncropped image from info dictionary
    //UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self setSelectedImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    // Save image
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self dismissModalViewControllerAnimated:YES];
    [self setImageData:UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 0.5 )];
    [self.selectedimageView setImage:selectedImage];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"didFinishSavingWithError");
    UIAlertView *alert;
    
    // Unable to save the image  
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Unable to save image to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                           message:@"Image saved to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    [alert show];
    [alert release];
}



#pragma mark - Custom Method

- (void) backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) uploadPin
{
    NSLog(@"uploadImage");
    NSString *_url = [NSString stringWithString:@"http://appspheregroup.com/flood/addpin.php"];
    ASIFormDataRequest *request2 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:_url]];
    NSLog(@"selectedAnnotation %f %f",selectedAnnotation.coordinate.latitude,selectedAnnotation.coordinate.longitude);
    [request2 setPostValue:[NSString stringWithFormat:@"[{\"lat\":%f,\"lng\":%f,\"address1\":\"%@\",\"address2\":\"%@\",\"address_custom\":\"%@\",\"pin_type\":1,\"created_by\":0,\"description\":\"%@\",\"water_level\":%i}]",selectedAnnotation.coordinate.latitude,selectedAnnotation.coordinate.longitude,address1,address2,@"",descriptionTextView .text,water_level] forKey:@"data"];
    [request2 setPostValue:[NSString stringWithFormat:@"%f",selectedAnnotation.coordinate.latitude] forKey:@"latitude"];
    [request2 setPostValue:[NSString stringWithFormat:@"%f",selectedAnnotation.coordinate.longitude] forKey:@"longitude"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYYMMddHHmmss"];
    
    if (imageData) {
        NSLog(@"have image data");
        [request2 setData:imageData withFileName:[NSString stringWithFormat:@"%@.jpg",[df stringFromDate:[NSDate date]]] andContentType:@"image/jpeg" forKey:@"userfile"];
    }else{
        NSLog(@"not have image data");
    }
    
    
    [request2 setRequestMethod:@"POST"];
    [request2 setTag:2];
    request2.delegate = self;
    [request2 startSynchronous];
    [df release];
    
}

- (void) postUpdate
{ 
    [self dismissKeyboard:self];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.labelText = @"Uploading";
    NSLog(@"post");
    
    //self.responseVote = [NSMutableData data];
    //NSString *_url = [NSString stringWithFormat:@"http://appspheregroup.com/flood/addpin.php?data=[{\"lat\":%f,\"lng\":%f,\"address1\":\"%@\",\"address2\":\"%@\",\"pin_type\":1,\"created_by\":0}]",selectedAnnotation.coordinate.latitude,selectedAnnotation.coordinate.longitude,@"AAA",@"BBB"];
    //    NSLog(@"url %@",_url);
    //    NSString *_fixedURL = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)_url, NULL, NULL, kCFStringEncodingUTF8);
    //    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_fixedURL]];
    //    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(uploadPin) userInfo:nil repeats:NO];
    
}


- (IBAction)browseImage:(id)sender {
    // create picker
    UIImagePickerController *picker = [[UIImagePickerController alloc] initWithRootViewController:nil];
    picker.delegate = self;
    
    // set custom action title and block
    //    picker.actionTitle = @"Upload";
    //    picker.actionBlock = ^(NSURL *URL, BOOL *stop) {
    //        // block to perform on each selected item
    //    };
    
    // show and release
    [self presentModalViewController:picker animated:YES];
    [picker release];
}




- (IBAction)openCamera:(id)sender {
    
    // Create image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    // Delegate is self
    imagePicker.delegate = self;
    
    // Allow editing of image ?
    imagePicker.allowsEditing = NO;
    
    // Show image picker
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
    
}

- (void) initialData
{
    // set imageData to nil
    [self setImageData:nil];
    water_level = 0;
    
    // now datetime
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"d MMMM yyyy hh:mm a"];
    [self.dateTimeLabel setText:[df stringFromDate:[NSDate date]]];
    [df release];
    
    // static map
    NSString *_url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%f,%f&zoom=15&size=174x119&markers=%f,%f&sensor=false", selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude, selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude];
    NSString *_fixedURL = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)_url, NULL, NULL, kCFStringEncodingUTF8);
    
    // initiate request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:_fixedURL]];
    [request setDelegate:self];
    [request setTag:1];
    [request startAsynchronous];
    [staticMapIndicator startAnimating];
    
    // address
    [self.address setText:[NSString stringWithFormat:@"%@",[selectedAnnotation title]]];
    
    // latitude
    [self.coordinateLabel setText:[NSString stringWithFormat:@"(%f , %f)",selectedAnnotation.coordinate.latitude,selectedAnnotation.coordinate.longitude]];
    
    
    // flood level scroolView
    [self.floodLevelScrollView setContentSize:CGSizeMake(140, 260)];
    
    UIImageView *floodAnimatedLevel = [[UIImageView alloc] init];
    [floodAnimatedLevel setFrame:CGRectMake(0, 130, 140, 26)];
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    [imageArray addObject:[UIImage imageNamed:@"water_01.png"]];
    [imageArray addObject:[UIImage imageNamed:@"water_02.png"]];
    [imageArray addObject:[UIImage imageNamed:@"water_03.png"]];
    [floodAnimatedLevel setAnimationImages:imageArray];
    [imageArray release];
    [floodAnimatedLevel setAnimationDuration:1];
    [floodAnimatedLevel startAnimating];
    
    UIView *waterView = [[UIView alloc] initWithFrame:CGRectMake(0, 156, 140, 234)];
    [waterView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3]];
    [self.floodLevelScrollView addSubview:floodAnimatedLevel];
    [self.floodLevelScrollView addSubview:waterView];
    
    [waterView release];
    [floodAnimatedLevel release];
    
}

@end
