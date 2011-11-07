//
//  Social.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "Social2Tab4Delegate.h"
#import "Social2ShareDelegate.h"

@interface Social : NSObject <FBSessionDelegate, FBDialogDelegate, FBRequestDelegate> {
    Facebook *facebook;
    id<Social2Tab4Delegate> tab4Delegate;
    id<Social2ShareDelegate> shareDelegate;
    
    NSMutableDictionary *socialPlist;
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) id<Social2Tab4Delegate> tab4Delegate;
@property (nonatomic, retain) id<Social2ShareDelegate> shareDelegate;
@property (nonatomic, retain) NSMutableDictionary *socialPlist;

+ (Social*) sharedSocial;
- (void) logInFacebook:(id<Social2Tab4Delegate>)delegate;
- (void) logOutFacebook:(id<Social2Tab4Delegate>)delegate;
- (BOOL) isDidLogInFacebook;
- (void) shareFacebookFloodTitle:(NSString*)_title detail:(NSString*)_detail linkURL:(NSString*)_link imageURL:(NSString*)_image caption:(NSString*)_caption messsage:(NSString*)_message withDelegate:(id<Social2ShareDelegate>)delegate;

- (void) logInTwitter:(id<Social2Tab4Delegate>)delegate;
- (void) logOutTwitter:(id<Social2Tab4Delegate>)delegate;
- (BOOL) isDidLogInTwitter;

@end