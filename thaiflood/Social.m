//
//  Social.m
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/3/54 BE.
//  Copyright 2554 Appsphere Group Co.,Ltd. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89	
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#define FACEBOOK_APP_ID              @"270426946332947"
#define FACEBOOK_TOKENKEY            @"FBAccessTokenKey"
#define FACEBOOK_EXPIRE_DATE         @"FBExpirationDateKey"
#define PERMISSION_EMAIL             @"email"
#define PERMISSION_STREAM            @"publish_stream"
#define FEED_LINK                    @"link"
#define FEED_PICTURE                 @"picture"
#define FEED_NAME                    @"name"
#define FEED_CAPTION                 @"caption"
#define FEED_DESCRIPTION             @"description"
#define FEED_MESSAGE                 @"message"

#import "Social.h"

static Social *_instance;
@implementation Social
@synthesize facebook;

#pragma mark -
#pragma mark Singleton Methods

+ (Social*)sharedSocial
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[self alloc] init];
            
            _instance.facebook = [[Facebook alloc] initWithAppId:@"270426946332947" andDelegate:_instance];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:@"FBAccessTokenKey"] 
                && [defaults objectForKey:@"FBExpirationDateKey"]) {
                _instance.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
                _instance.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
            }
            
            if (![_instance.facebook isSessionValid]) {
                [_instance.facebook authorize:nil];
            }
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [super allocWithZone:zone];			
            return _instance;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;	
}

#pragma mark -
#pragma mark Facbook

- (void)fbDidLogin 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_instance.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[_instance.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}

- (void) fbDidLogout 
{
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

- (void) logInFacebook
{
    if (![_instance.facebook isSessionValid]) {
        NSArray* permissions =  [NSArray arrayWithObjects: PERMISSION_EMAIL, PERMISSION_STREAM, nil];
        [facebook authorize:permissions];
    }
}

- (void) logOutFacebook
{
    [_instance.facebook logout:_instance];
}

- (BOOL) isDidLogInFacebook
{
    if (![_instance.facebook isSessionValid]) {
        return NO;
    }else{
        return YES;
    }
}


- (void) shareFacebookFloodTitle:(NSString*)_title detail:(NSString*)_detail linkURL:(NSString*)_link imageURL:(NSString*)_image caption:(NSString*)_caption 
{
    NSString *shortDetail = [NSString stringWithFormat:@"%@...", [_detail substringToIndex:100]];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _link, FEED_LINK,
                                   _image, FEED_PICTURE,
                                   _title, FEED_NAME,
                                   _caption, FEED_CAPTION,
                                   shortDetail, FEED_DESCRIPTION,
                                   @"",  FEED_MESSAGE,
                                   nil];
    
    [facebook dialog:@"feed"
           andParams:params
         andDelegate:_instance];
}

@end
