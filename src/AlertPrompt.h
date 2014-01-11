//
//  AlertPrompt.h
//
//  Created by Jeff LaMarche on 2/26/09
//  

#import <Foundation/Foundation.h>


@interface AlertPrompt : UIAlertView {

	UITextField *textField;
}

@property(nonatomic, retain) UITextField *textField;
@property(readonly) NSString *enteredText;

- (id)initWithTitle:(NSString *)myTitle message:(NSString *)myMessage delegate:(id)myDelegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;

@end
