//
//  Tab4MainViewController.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Social2Tab4Delegate.h"

@interface Tab4MainViewController : UIViewController <Social2Tab4Delegate>


- (IBAction)facebookSignInTap:(id)sender;
- (IBAction)twitterSignInTap:(id)sender;
- (IBAction)facebookSignOutTap:(id)sender;
- (IBAction)twitterSignOutTap:(id)sender;

-(void)facebookDidCancelLogIn;

@end
