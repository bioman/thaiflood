/*
 * Copyright (c) 2010-2010 Sebastian Celis
 * All rights reserved.
 */

#import <UIKit/UIKit.h>

#define kSCNavigationBarBackgroundImageTag 6183746
#define kSCNavigationBarTintColor [UIColor colorWithRed:56.0f/255.0f green:174.0f/255.0f blue:253.0f/255.0f alpha:1.0]

@interface SCAppUtils : NSObject
{
}

+ (void)customizeNavigationController:(UINavigationController *)navController;

@end
