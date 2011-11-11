//
//  Tab1PinDetailViewController.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/9/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tab1PinDetailViewController : UIViewController
{
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *timediffLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UITextView *descriptionLabel;
    IBOutlet UIImageView *levelImage;
}
@property (nonatomic, strong) NSDictionary *details;
- (void) startViewData:(NSDictionary*)data;
@end
