//
//  Number.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/1/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import "Number.h"

@implementation Number
@synthesize name,number;

- (id)initWithName:(NSString*)_name number:(NSString*)_number 
{
    self = [super init];
    if (self) {
        self.name = _name;
        self.number = _number;
    }
    return self;
}

-(void)dealloc
{
    [name release];
    [number release];
    [super dealloc];
}


@end
