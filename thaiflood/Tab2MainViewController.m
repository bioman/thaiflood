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

@interface Tab2MainViewController (Privated)
-(void)startActivity;
-(void)stopActivity;
@end

@implementation Tab2MainViewController

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

- (void) refreshFeed
{
    if (isLoading) {
        [self stopActivity];
    }else{
        [self startActivity];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.separatorColor = [UIColor grayColor];
    return 5;
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
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tab2DetailViewController *detailViewController = [[Tab2DetailViewController alloc] initWithNibName:@"Tab2DetailViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)startActivity{
    isLoading = YES;
    [(UIActivityIndicatorView *)[self navigationItem].leftBarButtonItem.customView startAnimating];
}

-(void)stopActivity{
    isLoading = NO;
    [(UIActivityIndicatorView *)[self navigationItem].leftBarButtonItem.customView stopAnimating];
}

-(void)dealloc{
    [super dealloc];
}

@end
