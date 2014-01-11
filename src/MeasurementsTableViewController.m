//
//  MeasurementsTableViewController.m
//  a-logger
//
//  Created by Andre Scherl on 21.12.09.
//  Copyright 2009 Andre Scherl. All rights reserved.
//

#import "MeasurementsTableViewController.h"
#import "a_loggerAppDelegate.h"
#import "DataViewController.h"

@implementation MeasurementsTableViewController

@synthesize measures;


- (void)viewDidLoad {
    [super viewDidLoad];

    // get the appDelegate to access global methods and properties
	appDelegate = (a_loggerAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	self.title = NSLocalizedString(@"MEASURES_TABLEVIEW", @"Tab Bar");
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	// get the files saved on device
	self.measures = [self getFilesAtPath:[appDelegate getDocumentsPath] withExtension:@"csv"];
	[measures removeObject:@"noname.csv"];
	NSLog(@"%@", measures);
	[[self tableView] reloadData];
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [measures count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[measures objectAtIndex:indexPath.row] stringByDeletingPathExtension];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	appDelegate.choosenFile = [measures objectAtIndex:indexPath.row];
	
	DataViewController *dvc = [[DataViewController alloc] initWithNibName:@"DataView" bundle:nil];
	[self.navigationController pushViewController:dvc animated:YES];
	[dvc release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
		// Delete the row from the data source
		NSString *filepath = [NSString stringWithFormat:@"%@/%@", [appDelegate getDocumentsPath], [measures objectAtIndex:indexPath.row]];
		[measures removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
		// Delete file from documents folder
		NSFileManager *myManager = [NSFileManager defaultManager];
		NSError *error;
		[myManager removeItemAtPath:filepath error:&error];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark file system methods

- (NSMutableArray *)getFilesAtPath:(NSString *)path withExtension:(NSString *)extension {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSMutableArray *files = [[[NSMutableArray alloc] init] autorelease];
	NSArray *contents = [fileManager subpathsOfDirectoryAtPath:path error:nil];
	for (NSString *file in contents) {
		if ([[file pathExtension] isEqualToString:extension]) {
			[files addObject:file];
		}
	}
	return files;
}

@end

