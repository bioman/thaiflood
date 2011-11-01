//
//  Number.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/1/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Number : NSObject
{
    NSString *name;
    NSString *number;
}

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *number;

- (id)initWithName:(NSString*)_name number:(NSString*)_number;

@end
