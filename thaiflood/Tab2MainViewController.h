//
//  Tab2MainViewController.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"


@interface Tab2MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate>
{
    BOOL isLoading;
    
    NSMutableArray *annoucementArray;
    
}

@property (retain, nonatomic) IBOutlet UITableView *annoucementTableView;
@property (nonatomic, retain) NSMutableArray *annoucementArray;

//Custom Method
- (void)makeRequestAnnoucement;
- (NSString *)dateDiff:(NSString *)origDate;
@end
