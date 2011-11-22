//
//  CalloutView.h
//  thaiflood
//
//  Created by Khanit Khanitvidthayanon on 11/15/54 BE.
//  Copyright (c) 2554 khanit.k@appspheregroup.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CurrentLocationAnnotation;
@interface CalloutView : UIView <UIGestureRecognizerDelegate>
{

}

@property (nonatomic,retain) CurrentLocationAnnotation *currentAnnotation;

- (id)initWithAnnotation:(CurrentLocationAnnotation*)_currentAnnotation;
- (void) animateIn;
- (void) viewDetail:(UITapGestureRecognizer *)gestureRecognizer;
- (UIViewController *)viewController;
@end
