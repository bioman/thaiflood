//
//  Social.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/3/54 BE.
//  Copyright 2554 Appsphere Group Co.,Ltd. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface Social : NSObject <FBSessionDelegate, FBDialogDelegate> {
    Facebook *facebook;
}

@property (nonatomic, retain) Facebook *facebook;

+ (Social*) sharedSocial;
- (void) logInFacebook;
- (void) logOutFacebook;
- (BOOL) isDidLogInFacebook;
- (void) shareFacebookFloodTitle:(NSString*)_title detail:(NSString*)_detail linkURL:(NSString*)_link imageURL:(NSString*)_image caption:(NSString*)_caption;

@end