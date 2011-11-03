//
//  Tab2TableViewCell.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tab2TableViewCell : UITableViewCell
{
    IBOutlet UILabel *time;
    IBOutlet UILabel *tilte;
    IBOutlet UILabel *detail;
}

@property (nonatomic, strong) IBOutlet UILabel *time;
@property (nonatomic, strong) IBOutlet UILabel *tilte;
@property (nonatomic, strong) IBOutlet UILabel *detail;
@property (nonatomic, strong) IBOutlet UIImageView *thumb;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (retain, nonatomic) IBOutlet UIView *mainView;

- (void)startLoading;
- (void)stopLoading;

@end
