//
//  Tab3DetailTableViewCell.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tab3DetailTableViewCell : UITableViewCell
{
    IBOutlet UILabel *tilte;
    IBOutlet UILabel *number;
}

@property (nonatomic, strong) IBOutlet UILabel *tilte;
@property (nonatomic, strong) IBOutlet UILabel *number;


- (IBAction)callNumber:(UIButton*)sender;
@end
