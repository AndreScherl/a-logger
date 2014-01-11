//
//  DataViewController.m
//  a-logger
//
//  Created by Andre Scherl on 30.12.09.
//  Copyright 2009 Andre Scherl. All rights reserved.
//

#import "DataViewController.h"
#import "a_loggerAppDelegate.h"


@implementation DataViewController

@synthesize webview;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	// get the appDelegate to access global methods and properties
	appDelegate = (a_loggerAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	self.title = appDelegate.choosenFile;
	
	// Add our custom add button as the nav bar's custom right view
	UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                            target:self
                            action:@selector(sendMail:)];
	self.navigationItem.rightBarButtonItem = sendButton;
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [appDelegate getDocumentsPath], appDelegate.choosenFile]]];
	
	[webview loadRequest:request];
	[request release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark mail methods

- (IBAction)sendMail:(id)sender {
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"SUBJECT", @"Email"), [appDelegate.choosenFile stringByDeletingPathExtension]]];
	
	// Attach the measure to the email
    NSData *myData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [appDelegate getDocumentsPath], appDelegate.choosenFile]];
	[picker addAttachmentData:myData mimeType:@"text/csv" fileName:[appDelegate.choosenFile stringByDeletingPathExtension]];
	
	// Fill out the email body text
	NSString *emailBody = NSLocalizedString(@"BODY", @"Email");
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	[self dismissModalViewControllerAnimated:YES];
}

@end
