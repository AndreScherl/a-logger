//
//  PreferencesViewController.m
//  a-logger
//
//  Created by Andre Scherl on 22.12.09.
//  Copyright 2009 Andre Scherl. All rights reserved.
//

#import "PreferencesViewController.h"
#import "a_loggerAppDelegate.h"


@implementation PreferencesViewController

@synthesize localGravity, timeIntervall, calibrationButton, digitsSlider;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// get the appDelegate to access global methods and properties
	appDelegate = (a_loggerAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	localGravityLabel.text = NSLocalizedString(@"GRAVITY", @"Preferences");
	timeIntervallLabel.text = NSLocalizedString(@"TIMEINTERVAL", @"Preferences");
	
	localGravity.text = [appDelegate.prefs objectForKey:@"localGravity"];
	timeIntervall.text = [appDelegate.prefs objectForKey:@"timeIntervall"];
	
	// set buton text
	[appDelegate setTitle:NSLocalizedString(@"CALIBRATE", @"Preferences") ofButton:calibrationButton];
	
	digitsLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"DIGITS", @"Preferences"), [appDelegate.prefs objectForKey:@"digits"]];
	digitsSlider.minimumValue = 0;
	digitsSlider.maximumValue = 7;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [digitsSlider setValue:[[appDelegate.prefs objectForKey:@"digits"] floatValue] animated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark text field methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	[appDelegate.prefs setObject:localGravity.text forKey:@"localGravity"];
	[appDelegate.prefs setObject:timeIntervall.text forKey:@"timeIntervall"];
	
	return YES;
}

#pragma mark -
#pragma mark button methods

- (void)calibrate:(id)sender {
	appDelegate.calFactor = [[appDelegate.prefs objectForKey:@"localGravity"] floatValue]/appDelegate.aForCal;
}

- (void)setDigits:(id)sender {
	[appDelegate.prefs setObject:[NSString stringWithFormat:@"%.f", digitsSlider.value] forKey:@"digits"];
	digitsLabel.text = [NSString stringWithFormat:@"%@: %.f", NSLocalizedString(@"DIGITS", @"Preferences"), digitsSlider.value];
}

@end
