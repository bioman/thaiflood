//
//  Tab3DetailViewController.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Tab3DetailViewController.h"
#import "Tab3DetailTableViewCell.h"
#import "Database.h"

@implementation Tab3DetailViewController
@synthesize call, numbers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forCall:(NSInteger)forCall;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSArray *_array = [NSArray arrayWithObjects:@"emergency", @"hospital", @"ask", @"police", @"other", nil];
        self.call = [_array objectAtIndex:forCall];
        switch (forCall) {
            case 0:
            {
                self.numbers = [[Database sharedDatabase] emergencyNumbers];
            }
                break;
            case 1:
            {
                self.numbers = [[Database sharedDatabase] hospitalNumbers];
            }
                break;
            case 2:
            {
                self.numbers = [[Database sharedDatabase] askTheWayNumbers];
            }
                break;
            case 3:
            {
                self.numbers = [[Database sharedDatabase] policeNumbers];
            }
                break;
            case 4:
            {
                self.numbers = [[Database sharedDatabase] otherNumbers];
            }
                break;
            default:
                break;
        }
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
    UIImageView *_titleText = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"text_%@.png",self.call]]];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.separatorColor = [UIColor grayColor];
    return [self.numbers count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    static NSString *CellIdentifier = @"Cell"; 
    Tab3DetailTableViewCell *cell = (Tab3DetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    if (cell == nil) {
        
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Tab3DetailTableViewCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (Tab3DetailTableViewCell *) currentObject;
				break;
			}
		}
	}
    Number *number = (Number*)[self.numbers objectAtIndex:indexPath.row];
    cell.tilte.text = [number name];
    cell.number.text = [number number];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    [call release];
    [numbers release];
    [super dealloc];
}


@end
