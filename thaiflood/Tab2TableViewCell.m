//
//  Tab2TableViewCell.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import "Tab2TableViewCell.h"

@implementation Tab2TableViewCell
@synthesize loadingIndicator;
@synthesize mainView;
@synthesize time, tilte, detail, thumb;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)startLoading
{
    [loadingIndicator setHidden:NO];
    [loadingIndicator startAnimating];
}

- (void)stopLoading
{
    [loadingIndicator stopAnimating];
    [loadingIndicator setHidden:YES];
}

- (void)dealloc {
    [time release];
    [tilte release];
    [detail release];
    [loadingIndicator release];
    [mainView release];
    [super dealloc];
}
@end
