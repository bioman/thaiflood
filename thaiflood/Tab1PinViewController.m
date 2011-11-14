//
//  Tab1PinViewController.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/9/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Tab1PinViewController.h"
#import "Tab1PinTableViewCell.h"
#import "Tab1PinDetailViewController.h"
#import "MBProgressHUD.h"
#import "SBJson.h"

@interface Tab1PinViewController (Privated)
-(NSString *)dateDiff:(NSString *)origDate;
@end

@implementation Tab1PinViewController
@synthesize details, latlong;


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
    
    UIImage *buttonImage2 = [UIImage imageNamed:@"button_add.png"];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:buttonImage2 forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(addDetail) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(0, 0, buttonImage2.size.width, buttonImage2.size.height);
    UIBarButtonItem *customBarItem2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    [self.navigationItem setRightBarButtonItem:customBarItem2];
    [customBarItem2 release];
    
    CGColorRef darkColor = [[UIColor blackColor] colorWithAlphaComponent:.3f].CGColor;
    CGColorRef lightColor = [UIColor clearColor].CGColor;
    CGFloat navigationBarBottom = 0.0;
    CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];
    newShadow.frame = CGRectMake(0,navigationBarBottom, self.view.frame.size.width, 3);
    newShadow.colors = [NSArray arrayWithObjects:(id)darkColor, (id)lightColor, nil];
    [self.view.layer addSublayer:newShadow];
}

- (void) startViewData:(NSDictionary*)data
{
    [self.navigationItem setTitle:[data objectForKey:@"title"]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
    self.latlong = [data objectForKey:@"latlong"];
    
    NSString *_url = [NSString stringWithFormat:@"http://www.appspheregroup.com/flood/getpindetail.php?id=%d", [[data objectForKey:@"id"] intValue]];
    NSLog(@"startViewData URL: %@",_url);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_url]];
    [request setTag:616];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.navigationItem setTitle:self.addressTitle];
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

- (void) backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    [details release];
    [latlong release];
    [super dealloc];
}

#pragma mark-
#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Lasted Update";
    }else{
        if ([self.details count] - 1 == 0) {
            return @"";
        }else{
            return @"Past Update";
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return [self.details count] - 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 270;
    }else{
        return 99;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    static NSString *CellIdentifier = @"Cell"; 
    
    Tab1PinTableViewCell *cell = (Tab1PinTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    if (cell == nil) {
        NSString *_nib = @"Tab1PinTableViewCell";
        if (indexPath.section == 0) {
            _nib = @"Tab1LastedPinTableViewCell";
        }
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:_nib owner:self options:nil];
        
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (Tab1PinTableViewCell *) currentObject;
				break;
			}
		}
	}
    NSInteger _index = indexPath.row;
    if (indexPath.section == 1) {
        _index++;
    }
    NSDictionary *_dic = [details objectAtIndex:_index];
    [cell.time setText:[self dateDiff:[_dic objectForKey:@"created_date"]]];
    [cell.description setText:[_dic objectForKey:@"description"]];
    [cell.level setImage:[UIImage imageNamed:[NSString stringWithFormat:@"water_level_0%d.png",[[_dic objectForKey:@"water_level"] intValue]]]];
    NSString *_url = [_dic objectForKey:@"pic_path"];
    if (indexPath.section == 0) {
        NSLog(@"URL: %@",_url);
        [cell thumbnailFromURL:[NSURL URLWithString:_url]];
    }else{
        NSRange textRange = [_url rangeOfString:@"googleapis"];
        if(textRange.location == NSNotFound)
        {
            [cell showCamera:YES];
        }else{
            [cell showCamera:NO];
        }
    }
//    NSLog(@"%@",[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"http://www.appspheregroup.com/flood/picture/%@/%@",latlong,[_dic objectForKey:@"pic_path"]]]);
    return cell;
}

#pragma mark-
#pragma mark UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *_dic; 
    if (indexPath.section == 0) {
        _dic = [details objectAtIndex:indexPath.row];
    }else{
        _dic = [details objectAtIndex:indexPath.row+1];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *convertedDate = [df dateFromString:[_dic objectForKey:@"created_date"]];
    [df release];
    df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"d MMMM yyyy"];
    NSString *_date = [df stringFromDate:convertedDate];
    [df release];
    df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"hh:mm a"];
    NSString *_time = [df stringFromDate:convertedDate];
    [df release];
    
    NSMutableDictionary *_pinData = [[NSMutableDictionary alloc] init];
    [_pinData setObject:self.navigationItem.title forKey:@"title"];
    [_pinData setObject:[self dateDiff:[_dic objectForKey:@"created_date"]] forKey:@"date_diff"];
    [_pinData setObject:_date forKey:@"date"]; NSLog(@"_date %@", _date);
    [_pinData setObject:_time forKey:@"time"];
    [_pinData setObject:[_dic objectForKey:@"water_level"] forKey:@"level"];
    [_pinData setObject:[_dic objectForKey:@"description"] forKey:@"description"];
    [_pinData setObject:[_dic objectForKey:@"pic_path"] forKey:@"pic"];
    
    Tab1PinDetailViewController *detailViewController = [[Tab1PinDetailViewController alloc] initWithNibName:@"Tab1PinDetailViewController" bundle:nil];
    [detailViewController startViewData:_pinData];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    [_pinData release];
}

#pragma mark ASIHTTPRequest Delegate

-(void) requestFinished: (ASIHTTPRequest *) request 
{
    NSString *_strResult = [[[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
    self.details = [_strResult JSONValue];
    UITableView *_table = (UITableView*)[self.view viewWithTag:7];
    [_table reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSError *error = [request error];
    NSLog(@"%@",[error localizedDescription]);
}

#pragma mark Custom Method
-(NSString *)dateDiff:(NSString *)origDate 
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *convertedDate = [df dateFromString:origDate];
    [df release];
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    NSString *_s = @"";
    if(ti < 1) {
        return @"just now";
    } else      if (ti < 60) {
        int diff = round(ti);
        if (diff>1) {
            _s = @"s";
        }
        return [NSString stringWithFormat:@"%d second%@ ago", diff,_s];
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        if (diff>1) {
            _s = @"s";
        }
        return [NSString stringWithFormat:@"%d minute%@ ago", diff,_s];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        if (diff>1) {
            _s = @"s";
        }
        return[NSString stringWithFormat:@"%d hour%@ ago", diff,_s];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        if (diff>1) {
            _s = @"s";
        }
        return[NSString stringWithFormat:@"%d day%@ ago", diff,_s];
    } else {
        return @"never";
    }   
}

- (void)addDetail
{
    
}

@end
