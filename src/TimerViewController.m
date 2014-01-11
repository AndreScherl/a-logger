//
//  TimerViewController.m
//  a-logger
//
//  Created by Andre Scherl on 19.12.10.
//  Copyright 2010 Andre Scherl. All rights reserved.
//

#import "TimerViewController.h"
#import "a_loggerAppDelegate.h"
#import "MeasureViewController.h"


@implementation TimerViewController

@synthesize timerSegment, measureTime, startButton, timerLabel, repeatingTimer, startMeasureTime, countDownRunning;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // get the appDelegate to access global methods and properties
	appDelegate = (a_loggerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // set title of segemented controller buttons
    [self.timerSegment setTitle:NSLocalizedString(@"COUNTDOWN", @"Timer")forSegmentAtIndex:0];
    [self.timerSegment setTitle:NSLocalizedString(@"CLOCK", @"Timer") forSegmentAtIndex:1];
    [self.timerSegment setTitle:NSLocalizedString(@"FIVESEC", @"Timer") forSegmentAtIndex:2];
    
    // set the mode of date picker
    if(timerSegment.selectedSegmentIndex == 0){
        self.measureTime.datePickerMode = UIDatePickerModeCountDownTimer; 
    }else{
        self.measureTime.datePickerMode = UIDatePickerModeDateAndTime;
        [self.measureTime setDate:[[NSDate alloc]init] animated:YES];
    }
    self.measureTime.locale = [NSLocale currentLocale];
    
    // set button text
    [appDelegate setTitle:NSLocalizedString(@"SAVETIME", @"Timer") ofButton:self.startButton];
    
    self.timerLabel.text = @"";
    
    self.countDownRunning = NO;
    
    // load the count down sound and prepare to play
    NSBundle *mainBundle = [NSBundle mainBundle];
	NSError *error;
	NSURL *soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/countdown.m4a", [mainBundle resourcePath]]];
	audioplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
	if (!audioplayer) {
		NSLog(@"no soundPlayer: %@", [error localizedDescription]);    
	}
	[audioplayer prepareToPlay];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.timerSegment.selectedSegmentIndex = 0;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [measureTime release];
    [timerSegment release];
    [timerLabel release];
    [startButton release];
    [super dealloc];
}

#pragma mark -
- (IBAction)changeTimerMode:(id)sender {
    switch (timerSegment.selectedSegmentIndex) {
        case 0:
            self.measureTime.datePickerMode = UIDatePickerModeCountDownTimer;
            break;
        case 1:
            self.measureTime.datePickerMode = UIDatePickerModeDateAndTime;
            [self.measureTime setDate:[[NSDate alloc]init] animated:YES];
            break;
        case 2:
            [self startCountDown:self];
            break;
        default:
            break;
    }
}

- (IBAction)startCountDown:(id)sender {
    if(!self.countDownRunning){
        switch (timerSegment.selectedSegmentIndex) {
            case 0:
                self.startMeasureTime = [[[NSDate alloc]init] dateByAddingTimeInterval:self.measureTime.countDownDuration];
                break;
            case 1:
                self.startMeasureTime = self.measureTime.date;
                self.startMeasureTime = [self.startMeasureTime dateByAddingTimeInterval:-(int)[self.startMeasureTime timeIntervalSince1970]%60];
                break;
            case 2:
                self.startMeasureTime = [[[NSDate alloc]init] dateByAddingTimeInterval:7];
                break;
            default:
                break;
        }

        // set timer object
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
        self.repeatingTimer = timer;
        [appDelegate setTitle:NSLocalizedString(@"STOPCOUNTDOWN", @"Timer") ofButton:self.startButton];
    }else{
        [self.repeatingTimer invalidate];
        [appDelegate setTitle:NSLocalizedString(@"SAVETIME", @"Timer") ofButton:self.startButton];
    }
    self.countDownRunning = !self.countDownRunning;
    self.timerLabel.text = @"";
}

- (void)countDown:(NSTimer *)aTimer {
    int seconds = (int)[self.startMeasureTime timeIntervalSinceNow];
    if(seconds/3600>0){
        self.timerLabel.text = [NSString stringWithFormat:@"%ih %imin %is", seconds/3600, seconds%3600/60, seconds%60];
    }else if(seconds%3600/60>0){
        self.timerLabel.text = [NSString stringWithFormat:@"%imin %is",seconds%3600/60, seconds%60];
    }else{
         self.timerLabel.text = [NSString stringWithFormat:@"Start in %is",seconds%60];
    }
    
    if(seconds == 3) {
        [audioplayer play];
    }
    
    if(seconds <= 0) {
        [self.repeatingTimer invalidate];
        
        NSArray *views = appDelegate.tabBarController.viewControllers;
        MeasureViewController *mvc = [[views objectAtIndex:0] autorelease];
        mvc.filename = [self.startMeasureTime description];
        mvc.recording = YES;
        appDelegate.tabBarController.selectedViewController = mvc;
        
        [self startCountDown:self];
        
    }
}
@end
