//
//  a_loggerAppDelegate.h
//  a-logger
//
//  Created by Andre Scherl on 21.12.09.
//  Copyright Andre Scherl 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface a_loggerAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	
	IBOutlet UITabBarItem *measureView;
	IBOutlet UITabBarItem *measuresTableView;
	IBOutlet UITabBarItem *preferencesView;
    IBOutlet UITabBarItem *timerView;
	
	NSString *xAcc;
	NSString *yAcc;
	NSString *zAcc;
	NSString *aAcc;
	
	float aForCal;
	float calFactor;
    
    NSDate *startTime;
	
	NSMutableDictionary *prefs;
	
	NSString *choosenFile;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property(nonatomic, retain) IBOutlet UITabBarItem *measureView;
@property(nonatomic, retain) IBOutlet UITabBarItem *measuresTableView;
@property(nonatomic, retain) IBOutlet UITabBarItem *preferencesView;
@property(nonatomic, retain) IBOutlet UITabBarItem *timerView;

@property (nonatomic, retain) NSString *xAcc;
@property (nonatomic, retain) NSString *yAcc;
@property (nonatomic, retain) NSString *zAcc;
@property (nonatomic, retain) NSString *aAcc;

@property(nonatomic, readwrite) float aForCal;
@property(nonatomic, readwrite) float calFactor;

@property(nonatomic, retain) NSDate *startTime;

@property (nonatomic, retain) NSMutableDictionary *prefs;

@property(nonatomic, retain) NSString *choosenFile;


- (NSString *)getDocumentsPath;
- (void)readLocalData;
- (void)setTitle:(NSString *)title ofButton:(UIButton *)button;

@end
