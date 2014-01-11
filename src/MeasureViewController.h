//
//  MeasureViewController.h
//  a-logger
//
//  Created by Andre Scherl on 21.12.09.
//  Copyright 2009 Andre Scherl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class a_loggerAppDelegate;
@class AccelerometerFilter;
@class LowpassFilter;
@class HighpassFilter;
@class AlertPrompt;

@interface MeasureViewController : UIViewController<UIAccelerometerDelegate> {
	
	a_loggerAppDelegate *appDelegate;
	
	//AccelerometerFilter *filter;
    //LowpassFilter *filter;
	HighpassFilter *filter;
    
	IBOutlet UILabel *xAccLabel;
	IBOutlet UILabel *yAccLabel;
	IBOutlet UILabel *zAccLabel;
	IBOutlet UILabel *aAccLabel;
	
	IBOutlet UIButton *removeGravityButton;
	IBOutlet UIButton *recordButton;
	
	BOOL recording;
	BOOL noGravity;
	NSMutableArray *measure;
	NSString *time;
    int timeIntervalDigits;
	
	NSString *filename;
}

@property(nonatomic, retain) UILabel *xAccLabel;
@property(nonatomic, retain) UILabel *yAccLabel;
@property(nonatomic, retain) UILabel *zAccLabel;
@property(nonatomic, retain) UILabel *aAccLabel;

@property(nonatomic, retain) UIButton *removeGravityButton;
@property(nonatomic, retain) UIButton *recordButton;

@property(nonatomic, readwrite) BOOL recording;
@property(nonatomic, readwrite) BOOL noGravity;
@property(nonatomic, retain) NSMutableArray *measure;
@property(nonatomic, retain) NSString *time;
@property(nonatomic, readwrite) int timeIntervalDigits;

@property(nonatomic, retain) NSString *filename;


- (void)calibrate;

- (void)record:(id)sender;
- (void)filterGravity:(id)sender;


@end
