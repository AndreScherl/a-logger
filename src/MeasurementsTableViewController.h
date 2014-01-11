//
//  MeasurementsTableViewController.h
//  a-logger
//
//  Created by Andre Scherl on 21.12.09.
//  Copyright 2009 Andre Scherl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class a_loggerAppDelegate;
@class DataViewController;

@interface MeasurementsTableViewController : UITableViewController {

	a_loggerAppDelegate *appDelegate;
	
	NSMutableArray *measures;
}

@property(nonatomic, retain) NSMutableArray *measures;

- (NSMutableArray *)getFilesAtPath:(NSString *)path withExtension:(NSString *)extension;

@end
