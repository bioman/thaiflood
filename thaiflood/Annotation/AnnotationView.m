//
//  AnnotationView.m
//  iOS4DragDrop
//
//  Created by Trent Kocurek on 7/21/10.
//  Copyright Urban Coding 2010. All rights reserved.
//

#import "AnnotationView.h"
#import "CurrentLocationAnnotation.h"
#import <QuartzCore/QuartzCore.h>

#define kDropCompressAmount 0.1

@interface AnnotationView () 
@property (nonatomic, assign) BOOL hasBuiltInDraggingSupport;
@end

@implementation AnnotationView
@synthesize hasBuiltInDraggingSupport;
@synthesize mapView;

- (void)dealloc {
	[super dealloc];
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	
	//self.hasBuiltInDraggingSupport = [[MKAnnotationView class] instancesRespondToSelector:NSSelectorFromString(@"isDraggable")];
	
	//if (self.hasBuiltInDraggingSupport) {
		if ((self = (AnnotationView*)[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])) {
			//[self performSelector:NSSelectorFromString(@"setDraggable:") withObject:[NSNumber numberWithBool:YES]];
		}
	//}
    self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    UIImage *pinImage = [UIImage imageNamed:@"pin_shadow.png"];
    self.image = pinImage;
    //self.frame = CGRectMake(self.frame.origin.x-50, self.frame.origin.y-50, self.frame.size.width, self.frame.size.height);
    //self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //self.canShowCallout = YES;
    self.draggable = NO;
	//self.canShowCallout = YES;
	self.frame = CGRectMake( 0,0,46,38);
    self.centerOffset = CGPointMake(12, -15);
	self.calloutOffset = CGPointMake(-10, 0);
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    NSLog(@"123123131");
    [super setSelected:selected animated:animated];
    
    if(selected)
    {
        //Add your custom view to self...
    }
    else
    {
        //Remove your custom view...
    }
}

- (void)initRedraw {
    NSLog(@"initRedraw");
    self.frame = CGRectMake(0,0,40,40);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"in draw rect");
}

- (void)didMoveToSuperview {
    NSLog(@"didMoveToSuperview");
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -400, 0)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.duration = 0.10;
    animation2.beginTime = animation.duration;
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation2.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(0, self.layer.frame.size.height*kDropCompressAmount, 0), 1.0, 1.0-kDropCompressAmount, 1.0)];
    animation2.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation3.duration = 0.15;
    animation3.beginTime = animation.duration+animation2.duration;
    animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation3.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation3.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:animation, animation2, animation3, nil];
    group.duration = animation.duration+animation2.duration+animation3.duration;
    group.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:group forKey:nil];
}


@end
