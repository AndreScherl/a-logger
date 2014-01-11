//
//  a_loggerAppDelegate.m
//  a-logger
//
//  Created by Andre Scherl on 21.12.09.
//  Copyright Andre Scherl 2009. All rights reserved.
//

#import "a_loggerAppDelegate.h"


@implementation a_loggerAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize measureView, measuresTableView, preferencesView, timerView;
@synthesize xAcc, yAcc, zAcc, aAcc, aForCal, calFactor, prefs, choosenFile, startTime;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
	
	measureView.title = NSLocalizedString(@"MEASURE_VIEW", @"Tab Bar");
	measuresTableView.title = NSLocalizedString(@"MEASURES_TABLEVIEW", @"Tab Bar");
	preferencesView.title = NSLocalizedString(@"PREFERENCES", @"Tab Bar");
    timerView.title = NSLocalizedString(@"TIMER_VIEW", @"Tab Bar");
	
	[self readLocalData];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *libraryDir = [paths objectAtIndex:0];
	[prefs writeToFile:[libraryDir stringByAppendingString:@"/prefs.plist"] atomically:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *libraryDir = [paths objectAtIndex:0];
	[prefs writeToFile:[libraryDir stringByAppendingString:@"/prefs.plist"] atomically:YES];
}



- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}


#pragma mark -
#pragma mark global button methods

- (void)setTitle:(NSString *)title ofButton:(UIButton *)button {

	[button setTitle:title forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateHighlighted];
	[button setTitle:title forState:UIControlStateDisabled];
	[button setTitle:title forState:UIControlStateSelected];
}

#pragma mark -
#pragma mark local data methods

- (NSString *)getDocumentsPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

- (void)readLocalData {
	// read the stored prefs
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *libraryDir = [paths objectAtIndex:0];
    
	if(![[NSFileManager defaultManager] fileExistsAtPath:[libraryDir stringByAppendingString:@"/prefs.plist"]]){
		self.prefs = [NSMutableDictionary dictionary];
		[prefs setObject:@"9.81" forKey:@"localGravity"];
		[prefs setObject:@"1.0" forKey:@"timeIntervall"];
		[prefs setObject:@"2" forKey:@"digits"];
	}else{
		self.prefs = [NSMutableDictionary dictionaryWithContentsOfFile:[libraryDir stringByAppendingString:@"/prefs.plist"]];
	}
}

@end

