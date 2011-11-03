//
//  Tab2MainViewController.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "Tab2MainViewController.h"
#import "Tab2TableViewCell.h"
#import "Tab2DetailViewController.h"
#import "MBProgressHUD.h"

#import "SBJson.h"

@interface Tab2MainViewController (Privated)
-(void)startActivity;
-(void)stopActivity;
@end

@implementation Tab2MainViewController
@synthesize annoucementTableView;
@synthesize annoucementArray;

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
    UIImageView *_titleText = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"text_announcement.png"]];
    [self.navigationItem setTitleView:_titleText];
    [_titleText release];
    
    UIImage *buttonImage = [UIImage imageNamed:@"button_refresh.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(refreshFeed) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:customBarItem];
    [customBarItem release];
    
    UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem *loadingBarItem = [[UIBarButtonItem alloc] initWithCustomView:loadingIndicator];
    [loadingIndicator release];
    [self.navigationItem setLeftBarButtonItem:loadingBarItem];
    [loadingBarItem release];
    isLoading = NO;
    
    CGColorRef darkColor = [[UIColor blackColor] colorWithAlphaComponent:.3f].CGColor;
    CGColorRef lightColor = [UIColor clearColor].CGColor;
    CGFloat navigationBarBottom = 0.0;
    CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];
    newShadow.frame = CGRectMake(0,navigationBarBottom, self.view.frame.size.width, 3);
    newShadow.colors = [NSArray arrayWithObjects:(id)darkColor, (id)lightColor, nil];
    [self.view.layer addSublayer:newShadow];
    
    //initial array
    annoucementArray = [[NSMutableArray alloc] init];
    //request for data
    [self makeRequestAnnoucement];
}

- (void)viewDidUnload
{
    self.annoucementArray = nil;
    [self setAnnoucementTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)dealloc{
    [annoucementArray release];
    [annoucementTableView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark-
#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.separatorColor = [UIColor grayColor];
    int count = [self.annoucementArray count];
    if (count == 0) {
        count = 1;
    }
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    static NSString *CellIdentifier = @"Cell"; 
    Tab2TableViewCell *cell = (Tab2TableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    if (cell == nil) {
        
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Tab2TableViewCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (Tab2TableViewCell *) currentObject;
                
                
				break;
			}
		}
	}
    int count = [self.annoucementArray count];
    if (count == 0) {
        // add HUD
        [cell.mainView setHidden:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading";
    }else{
        [cell.mainView setHidden:NO];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dict = [annoucementArray objectAtIndex:indexPath.row];
        [cell.tilte setText:[dict objectForKey:@"title"]];
        [cell.detail setText:[dict objectForKey:@"description"]];
        [cell.time setText:[self dateDiff:[dict objectForKey:@"created_date"]]];
        [cell thumbnailFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.appspheregroup.com/flood/thumbnail/%@",[dict objectForKey:@"thumbnail"]]]];
    }
    
    return cell;
}

#pragma mark-
#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tab2DetailViewController *detailViewController = [[Tab2DetailViewController alloc] initWithNibName:@"Tab2DetailViewController" bundle:nil];
    [detailViewController setAnnoucementDetail:[annoucementArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark-
#pragma mark ASIHTTPRequest Delegate
-(void) requestFinished: (ASIHTTPRequest *) request {
    
    NSString *_strResult = [[[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
    
    [self.annoucementArray removeAllObjects];
    [self.annoucementArray setArray:[_strResult JSONValue]];
    
    // reload tableView
    [annoucementTableView reloadData];
    // stop activityIndicator
    [self stopActivity];
    
}

#pragma mark-
#pragma mark Custom Private Method
-(void)startActivity{
    // add HUD
    isLoading = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    [(UIActivityIndicatorView *)[self navigationItem].leftBarButtonItem.customView startAnimating];
}

-(void)stopActivity{
    isLoading = NO;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [(UIActivityIndicatorView *)[self navigationItem].leftBarButtonItem.customView stopAnimating];
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

- (void) refreshFeed
{
//    if (isLoading) {
//        [self stopActivity];
//    }else{
//        [self startActivity];
//    }
    [self startActivity];
    [self makeRequestAnnoucement];
}

- (IBAction)makeRequestAnnoucement
{
    // The url to make the request to
    NSURL *annoucementURL = [NSURL URLWithString:@"http://www.appspheregroup.com/flood/getannoucement.php"];
    
    //The actual request
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:annoucementURL];
    
    // Becoming the request delegate
    //To get callbacks like requestFinished: or requestFailed:
    [request setDelegate:self];
    
    // Fire off the request
    [request startAsynchronous];
}

@end
