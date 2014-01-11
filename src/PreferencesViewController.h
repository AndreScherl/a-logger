//
//  PreferencesViewController.h
//  a-logger
//
//  Created by Andre Scherl on 22.12.09.
//  Copyright 2009 Andre Scherl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class a_loggerAppDelegate;
@class MeasureViewController;

@interface PreferencesViewController : UIViewController {

	a_loggerAppDelegate *appDelegate;
	
	IBOutlet UILabel *localGravityLabel;
	IBOutlet UITextField *localGravity;
	
	IBOutlet UILabel *timeIntervallLabel;
	IBOutlet UITextField *timeIntervall;	
	
	IBOutlet UIButton *calibrationButton;
	
	IBOutlet UILabel *digitsLabel;
	IBOutlet UISlider *digitsSlider;
}

@property(nonatomic, retain) UITextField *localGravity;
@property(nonatomic, retain) UITextField *timeIntervall;

@property(nonatomic, retain) UIButton *calibrationButton;

@property(nonatomic, retain) UISlider *digitsSlider;

- (void)calibrate:(id)sender;
- (void)setDigits:(id)sender;

@end
