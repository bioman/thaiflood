//
//  Database.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/1/54 BE.
//  Copyright 2554 Appsphere Group Co.,Ltd. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>
#import "Number.h"

@interface Database : NSObject {
    NSDictionary *numbers;
}

@property (nonatomic, strong) NSDictionary *numbers;

+ (Database*) sharedDatabase;
- (NSMutableArray*) emergencyNumbers;
- (NSMutableArray*) hospitalNumbers;
- (NSMutableArray*) askTheWayNumbers;
- (NSMutableArray*) policeNumbers;
- (NSMutableArray*) otherNumbers;

@end
