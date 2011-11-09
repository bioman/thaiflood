//
//  Tab1AddViewController.h
//  thaiflood
//
//  Created by Sunchai Pitakchonlasup on 11/1/54 BE.
//  Copyright (c) 2554 Appsphere Group Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CurrentLocationAnnotation;
@interface Tab1AddViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
{
    CurrentLocationAnnotation *selectedAnnotation;
    UIImage *selectedImage;
    NSData *imageData;
    
    NSString *address1;
    NSString *address2;
    int water_level;
}

@property (retain, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (retain, nonatomic) CurrentLocationAnnotation *selectedAnnotation;
@property (retain, nonatomic) UIImage *selectedImage;
@property (retain, nonatomic) NSData *imageData;
@property (retain, nonatomic) IBOutlet UILabel *coordinateLabel;
@property (retain, nonatomic) IBOutlet UIImageView *staticMapImageView;
@property (retain, nonatomic) IBOutlet UITextField *address;
@property (retain, nonatomic) IBOutlet UIView *floodLevelView;
@property (retain, nonatomic) IBOutlet UIScrollView *floodLevelScrollView;
@property (retain, nonatomic) IBOutlet UIImageView *selectedimageView;
@property (retain, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (retain, nonatomic) IBOutlet NSString *address1;
@property (retain, nonatomic) IBOutlet NSString *address2;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *staticMapIndicator;


- (IBAction)dismissKeyboard:(id)sender;
- (void) initialData;
- (IBAction)browseImage:(id)sender;
- (IBAction)openCamera:(id)sender;

@end
