//
//  thaifloodAppDelegate.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 10/30/11.
//  Copyright 2011 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface thaifloodAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
