//
//  Tab3DetailViewController.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tab3DetailViewController : UIViewController
{
    NSString *call;
    NSArray *numbers;
}

@property (nonatomic,strong) NSString *call;
@property (nonatomic,strong) NSArray *numbers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forCall:(NSInteger)forCall;

@end
