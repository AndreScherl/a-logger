//
//  TimerViewController.h
//  a-logger
//
//  Created by Andre Scherl on 19.12.10.
//  Copyright 2010 Andre Scherl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class a_loggerAppDelegate;
@class MeasureViewController;

@interface TimerViewController : UIViewController {
    a_loggerAppDelegate *appDelegate;
    
    IBOutlet UISegmentedControl *timerSegment;
    IBOutlet UIDatePicker *measureTime;
    IBOutlet UILabel *timerLabel;
    IBOutlet UIButton *startButton;
    
    NSDate *startMeasureTime;
    NSTimer *repeatingTimer;
    
    BOOL countDownRunning;
    
    AVAudioPlayer *audioplayer;
    
}
@property(nonatomic, retain) IBOutlet UISegmentedControl *timerSegment;
@property(nonatomic, retain) IBOutlet UIDatePicker *measureTime;
@property(nonatomic, retain) IBOutlet UIButton *startButton;
@property(nonatomic, retain) IBOutlet UILabel *timerLabel;
@property(readwrite, retain) NSDate *startMeasureTime;
@property(readwrite, retain) NSTimer *repeatingTimer;

@property(readwrite) BOOL countDownRunning;

- (IBAction)changeTimerMode:(id)sender;
- (IBAction)startCountDown:(id)sender;
- (void)countDown:(NSTimer *)aTimer;

@end
