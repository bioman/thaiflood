//
//  Social2Tab4Delegate.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/4/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Social2Tab4Delegate <NSObject>
- (void) facebookDidFinishLogIn;
- (void) facebookDidFinishLogOut;
- (void) twitterDidFinishLogIn;
- (void) twitterDidFinishLogOut;
@end
