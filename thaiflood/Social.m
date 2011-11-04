//
//  Social.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/31/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

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
@synthesize facebook, tab4Delegate;
@synthesize socialPlist;

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
            
            NSString *databasePlistPath = [NSString stringWithFormat: @"%@/SocialData.plist", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0]];
            if (![[NSFileManager defaultManager] fileExistsAtPath: databasePlistPath]){                 NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SocialData" ofType:@"plist"];
                NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
                NSString *documentsDir = [paths objectAtIndex:0];
                NSString *fullPath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"SocialData.plist"]]; 
                [plist writeToFile:fullPath atomically:YES];
                _instance.socialPlist = plist;
                [plist release];
            }else{ //database.plist is available.
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:@"database.plist"]];
                NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
                _instance.socialPlist = plist;
                [plist release];
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

- (void) logInFacebook:(id<Social2Tab4Delegate>)delegate
{
    self.tab4Delegate = delegate;
    if (![_instance.facebook isSessionValid]) {
        NSArray* permissions =  [NSArray arrayWithObjects: PERMISSION_EMAIL, PERMISSION_STREAM, nil];
        [facebook authorize:permissions];
    }
}

- (void) logOutFacebook:(id<Social2Tab4Delegate>)delegate
{
    self.tab4Delegate = delegate;
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

- (void)getFBUserInfo{
    [_instance.facebook requestWithGraphPath:@"me" andDelegate:self];
    [_instance.facebook requestWithGraphPath:@"me/picture" andDelegate:self];
}

- (void)fbDidLogin 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_instance.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[_instance.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [_instance getFBUserInfo];
}

-(void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"did not login"); //be called when user cancle
}

- (void) fbDidLogout 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    
    NSMutableDictionary *_facebook = [[NSMutableDictionary alloc] init];
    [_facebook setObject:@"" forKey:@"name"];
    [_facebook setObject:@"" forKey:@"picture"];
    [_instance.socialPlist setObject:_facebook forKey:@"Facebook"];
    [_facebook release];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"SocialData.plist"]]; 
    [_instance.socialPlist writeToFile:fullPath atomically:YES];
    
    [tab4Delegate facebookDidFinishLogOut];
    [tab4Delegate release];
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
    
    [_instance.facebook dialog:@"feed"
           andParams:params
         andDelegate:_instance];
}

-(void)dialogDidComplete:(FBDialog *)dialog
{
        //did share
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response");
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    if (![result isKindOfClass:[NSData class]]) {
        NSLog(@"didLoad for name");
        NSString *_name = [result objectForKey:@"name"];
        NSMutableDictionary *_facebook = [[NSMutableDictionary alloc] init];
        [_facebook setObject:_name forKey:@"name"];
        [_facebook setObject:[[_instance.socialPlist objectForKey:@"Facebook"] objectForKey:@"picture"] forKey:@"picture"];
        [_instance.socialPlist setObject:_facebook forKey:@"Facebook"];
        [_facebook release];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        NSString *fullPath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"SocialData.plist"]]; 
        [_instance.socialPlist writeToFile:fullPath atomically:YES];
    }else{
        NSLog(@"didLoad for picture");
        UIImage *_pic = [UIImage imageWithData:result];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        NSString *fullPath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"fbpic.png"]]; 
        [UIImagePNGRepresentation(_pic) writeToFile:fullPath atomically:YES];
        
        NSMutableDictionary *_facebook = [[NSMutableDictionary alloc] init];
        [_facebook setObject:[[_instance.socialPlist objectForKey:@"Facebook"] objectForKey:@"name"]  forKey:@"name"];
        [_facebook setObject:fullPath forKey:@"picture"];
        [_instance.socialPlist setObject:_facebook forKey:@"Facebook"];
        [_facebook release];
        fullPath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"SocialData.plist"]]; 
        [_instance.socialPlist writeToFile:fullPath atomically:YES];
        
        [tab4Delegate facebookDidFinishLogIn];
        [tab4Delegate release];
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

@end