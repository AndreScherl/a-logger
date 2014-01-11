//
//  MeasureViewController.m
//  a-logger
//
//  Created by Andre Scherl on 21.12.09.
//  Copyright 2009 Andre Scherl. All rights reserved.
//

#import "MeasureViewController.h"
#import "a_loggerAppDelegate.h"
#import "AccelerometerFilter.h"
#import "AlertPrompt.h"


@implementation MeasureViewController

@synthesize xAccLabel, yAccLabel, zAccLabel, aAccLabel;
@synthesize removeGravityButton, recordButton;
@synthesize recording, noGravity, measure, time, timeIntervalDigits,filename;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// get the appDelegate to access global methods and properties
	appDelegate = (a_loggerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Start the accelerometer data receive prozess
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    // Filter
    //filter = [[LowpassFilter alloc] initWithSampleRate:1/[[appDelegate.prefs objectForKey:@"timeIntervall"] floatValue] cutoffFrequency:1.0];
    filter = [[HighpassFilter alloc] initWithSampleRate:1/(10*[[appDelegate.prefs objectForKey:@"timeIntervall"] floatValue]) cutoffFrequency:0.001];
    
    self.recording = FALSE;
	self.noGravity = FALSE;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    [self retain];
    
	// values for calibration to local gravity
	appDelegate.aForCal = 1.0;
	appDelegate.calFactor = [[appDelegate.prefs objectForKey:@"localGravity"] floatValue];
	
	// set buton text
	[appDelegate setTitle:NSLocalizedString(@"WITHOUT_GRAVITY", @"Measure") ofButton:removeGravityButton];
	[appDelegate setTitle:NSLocalizedString(@"START_MEASURE", @"Measure") ofButton:recordButton];
	
    // set up things to get the filename, but only if not recording
	if(!self.recording){
        self.filename = @"noname";
    }
	
	// set the headline of the table (array) object to save in svc-file later
	measure = [[NSMutableArray alloc] init];
	[measure addObject:@"t in s; ax in m/s2; ay in m/s2; az in m/s2; a in m/s2"];
    if([[appDelegate.prefs objectForKey:@"timeIntervall"] rangeOfString:@"."].location != NSNotFound){
        self.timeIntervalDigits = [[[[appDelegate.prefs objectForKey:@"timeIntervall"] componentsSeparatedByString:@"."] objectAtIndex:1] length];
    }else{
        self.timeIntervalDigits = 0;
    }
	
    
	// calibrate the values to local gravity
	[self calibrate];
	
	// better to do it here, so the changes of time intervall will have an effect
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:[[appDelegate.prefs objectForKey:@"timeIntervall"] floatValue]];
    
    if (self.recording) {
        [appDelegate setTitle:NSLocalizedString(@"PAUSE", @"Measure") ofButton:recordButton];
    }
    
    if (noGravity) {
		[appDelegate setTitle:NSLocalizedString(@"WITH_GRAVITY", @"Measure") ofButton:removeGravityButton];
	}
    
    appDelegate.startTime = [[NSDate alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	// stop recording
	self.recording = FALSE;
	
	// save the recorded data to svc-file in documents folder
	[[measure componentsJoinedByString:@";"] writeToFile:[NSString stringWithFormat:@"%@/%@.csv", [appDelegate getDocumentsPath], filename] 
											  atomically:YES 
												encoding:NSUTF8StringEncoding 
												   error:NULL];
}


- (void)dealloc {
    [super dealloc];
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];	
}


#pragma mark -
#pragma mark acceleration value methods

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	appDelegate.aForCal = sqrt(acceleration.x*acceleration.x+acceleration.y*acceleration.y+acceleration.z*acceleration.z);
	NSString *formatString = [NSString stringWithFormat:@"%@%@f", @"%.", [appDelegate.prefs objectForKey:@"digits"]];
    NSString *formatStringTime = [NSString stringWithFormat:@"%@%df", @"%.", self.timeIntervalDigits];
	
    self.time = [NSString localizedStringWithFormat:formatStringTime, [[[NSDate alloc] init] timeIntervalSinceDate:appDelegate.startTime]];
    
	if (self.noGravity) {
		
		[filter addAcceleration:acceleration];
		float aNorm = sqrt(filter.x*filter.x+filter.y*filter.y+filter.z*filter.z);
		appDelegate.xAcc = [NSString localizedStringWithFormat:formatString, filter.x*appDelegate.calFactor];
		appDelegate.yAcc = [NSString localizedStringWithFormat:formatString, filter.y*appDelegate.calFactor];
		appDelegate.zAcc = [NSString localizedStringWithFormat:formatString, filter.z*appDelegate.calFactor];
		appDelegate.aAcc = [NSString localizedStringWithFormat:formatString, aNorm*appDelegate.calFactor];
        
	}else{
		
		appDelegate.xAcc = [NSString localizedStringWithFormat:formatString, acceleration.x*appDelegate.calFactor];
		appDelegate.yAcc = [NSString localizedStringWithFormat:formatString, acceleration.y*appDelegate.calFactor];
		appDelegate.zAcc = [NSString localizedStringWithFormat:formatString, acceleration.z*appDelegate.calFactor];
		appDelegate.aAcc = [NSString localizedStringWithFormat:formatString, appDelegate.aForCal*appDelegate.calFactor];
	}
	
	// Put values into the labels
	xAccLabel.text = appDelegate.xAcc;
	yAccLabel.text = appDelegate.yAcc;
	zAccLabel.text = appDelegate.zAcc;
	aAccLabel.text = appDelegate.aAcc;
	
	// put the measure values into the measure array
	if (self.recording) {
		
		[measure addObject:[NSString localizedStringWithFormat:@"\n%@; %@; %@; %@; %@",
							self.time, 
							appDelegate.xAcc, 
							appDelegate.yAcc, 
							appDelegate.zAcc, 
							appDelegate.aAcc]];
    }
	
}
 
- (void)calibrate {
	appDelegate.calFactor = [[appDelegate.prefs objectForKey:@"localGravity"] floatValue]/appDelegate.aForCal;
}


#pragma mark -
#pragma mark button methods

- (void)record:(id)sender {
	
	if ([filename isEqualToString:@"noname"]) {
		AlertPrompt *filenamePrompt = [[AlertPrompt alloc] initWithTitle:NSLocalizedString(@"MEASURE_TITLE", @"Measure") message:NSLocalizedString(@"PROMPT_COMMAND", @"Measure") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Measure") okButtonTitle:NSLocalizedString(@"START", @"Measure")];
		[filenamePrompt show];
		//[filenamePrompt release];
	}else {
		recording = !recording;
		if (recording) {
			[appDelegate setTitle:NSLocalizedString(@"PAUSE", @"Measure") ofButton:recordButton];
		}else {
			[appDelegate setTitle:NSLocalizedString(@"RESUME", @"Measure") ofButton:recordButton];
		}
	}
}

- (void)filterGravity:(id)sender {
	noGravity = !noGravity;
	
	if (noGravity) {
		[appDelegate setTitle:NSLocalizedString(@"WITH_GRAVITY", @"Measure") ofButton:removeGravityButton];
	}else {
		[appDelegate setTitle:NSLocalizedString(@"WITHOUT_GRAVITY", @"Measure") ofButton:removeGravityButton];
	}
	
	filter = [[HighpassFilter alloc] initWithSampleRate:1.0/[[appDelegate.prefs objectForKey:@"timeIntervall"] floatValue] cutoffFrequency:2.0/[[appDelegate.prefs objectForKey:@"timeIntervall"] floatValue]];
	
}


#pragma mark -
#pragma mark AlertPrompt methods

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex != [alertView cancelButtonIndex]) {
		self.filename = [(AlertPrompt *)alertView enteredText];
		recording = !recording;
        appDelegate.startTime = [[NSDate alloc] init];
		[appDelegate setTitle:NSLocalizedString(@"PAUSE", @"Measure") ofButton:recordButton];
		[[(AlertPrompt *)alertView textField] resignFirstResponder];
	}
	
	[self release];
}


@end
