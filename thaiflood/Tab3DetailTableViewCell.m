//
//  Tab3DetailTableViewCell.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import "Tab3DetailTableViewCell.h"

@implementation Tab3DetailTableViewCell
@synthesize tilte, number;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)callNumber:(UIButton*)sender {
    NSString *phoneLinkString = [NSString stringWithFormat:@"tel:%@", self.number.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneLinkString]];
}

@end
