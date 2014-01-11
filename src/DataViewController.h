//
//  DataViewController.h
//  a-logger
//
//  Created by Andre Scherl on 30.12.09.
//  Copyright 2009 Andre Scherl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class a_loggerAppDelegate;

@interface DataViewController : UIViewController <MFMailComposeViewControllerDelegate> {
	
	a_loggerAppDelegate *appDelegate;
	
	IBOutlet UIWebView *webview;

}

@property(nonatomic, retain) UIWebView *webview;

- (IBAction)sendMail:(id)sender;

@end
