//
//  CalloutView.m
//  thaiflood
//
//  Created by Khanit Khanitvidthayanon on 11/15/54 BE.
//  Copyright (c) 2554 khanit.k@appspheregroup.com. All rights reserved.
//

#import "CalloutView.h"
#import "CurrentLocationAnnotation.h"
#import "Tab1PinViewController.h"

@implementation CalloutView
@synthesize currentAnnotation;

- (id)initWithAnnotation:(CurrentLocationAnnotation*)_currentAnnotation
{
    self = [super init];
    if (self) {
        //self.frame = CGRectMake(-81, -62 , 100, 50);
        self.currentAnnotation = _currentAnnotation;
        [self animateIn];
    }
    return self;
}

- (void)animateIn
{   
    float myBubbleWidth = 178;
    float myBubbleHeight = 62;
    
    
    UIImageView *balloonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"balloon.png"]];
    [balloonImageView setTag:3411004];
    [self addSubview:balloonImageView];
    [balloonImageView release];
    
    UIImageView *numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_number.png"]];
    [numberImageView setFrame:CGRectMake(10, 11, 27, 27)];
    [self addSubview:numberImageView];
    [numberImageView release];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 10, 25, 25)];
    [numberLabel setText:@"1"];
    [numberLabel setTextAlignment:UITextAlignmentCenter];
    [numberLabel setTextColor:[UIColor whiteColor]];
    [numberLabel setBackgroundColor:[UIColor clearColor]];
    [numberLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self addSubview:numberLabel];
    [numberLabel release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 7, 150, 20)];
    [titleLabel setText:[self.currentAnnotation title]];
    [titleLabel setTextAlignment:UITextAlignmentLeft];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    [self addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 22, 150, 20)];
    [detailLabel setText:[NSString stringWithFormat:@"%f,%f",[self.currentAnnotation coordinate].latitude,[self.currentAnnotation coordinate].longitude]];
    [detailLabel setTextAlignment:UITextAlignmentLeft];
    [detailLabel setTextColor:[UIColor whiteColor]];
    [detailLabel setBackgroundColor:[UIColor clearColor]];
    [detailLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [self addSubview:detailLabel];
    [detailLabel release];
    
//    UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_detail.png"]];
//    [accessoryImageView setFrame:CGRectMake(150, 11, 27, 27)];
//    [self addSubview:accessoryImageView];
//    [accessoryImageView release];
    
    UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [accessoryButton setFrame:CGRectMake(150, 11, 27, 27)];
    [accessoryButton setTag:101];
    //[accessoryButton setUserInteractionEnabled:YES];
    [accessoryButton setImage:[UIImage imageNamed:@"button_detail.png"] forState:UIControlStateNormal];
    //[accessoryButton addTarget:self action:@selector(viewDetail) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDetail:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [accessoryButton addGestureRecognizer:tap];
    [tap release];
    
    [self addSubview:accessoryButton];
    
    
    //[self.superview addSubview:self];
    self.frame = CGRectMake(-round(myBubbleWidth/2-8), -myBubbleHeight+10, myBubbleWidth, myBubbleHeight);
    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^(void) {
        self.frame = CGRectMake(-round(myBubbleWidth/2-8), -myBubbleHeight-5, myBubbleWidth, myBubbleHeight);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.0 animations:^(void) {
            self.frame = CGRectMake(-round(myBubbleWidth/2-8), -myBubbleHeight+3, myBubbleWidth, myBubbleHeight);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.0 animations:^(void) {
                self.frame = CGRectMake(-round(myBubbleWidth/2-8), -myBubbleHeight-2, myBubbleWidth, myBubbleHeight);
                
            } completion:^(BOOL finished) {
                
                [self bringSubviewToFront:accessoryButton];
            }];
        }];
    }];
}

- (void)didMoveToSuperview
{
    NSLog(@"didMoveToSuperview");
    [self.superview.superview bringSubviewToFront:self.superview];
}

- (void)viewDetail:(UITapGestureRecognizer *)gestureRecognizer 
{
    NSLog(@"viewDetail");
    NSMutableDictionary *_pinData = [[NSMutableDictionary alloc] init];
    [_pinData setObject:[self.currentAnnotation title] forKey:@"title"];
    [_pinData setObject:[self.currentAnnotation tag] forKey:@"id"];
    [_pinData setObject:[self.currentAnnotation latlong] forKey:@"latlong"];
    
    Tab1PinViewController *pinViewController = [[Tab1PinViewController alloc] initWithNibName:@"Tab1PinViewController" bundle:nil];
    [pinViewController startViewData:_pinData];
    [_pinData release];
    [[self viewController].navigationController pushViewController:pinViewController animated:YES];
    [pinViewController release];
}

- (UIViewController *)viewController;
{
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else {
        return nil;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"42213424324325324");
    return YES;
}

@end
