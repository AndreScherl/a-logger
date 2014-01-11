//
//  AlertPrompt.m
//
//  Created by Jeff LaMarche on 2/26/09
//

#import "AlertPrompt.h"


@implementation AlertPrompt

@synthesize textField;

- (id)initWithTitle:(NSString *)myTitle message:(NSString *)myMessage delegate:(id)myDelegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle {
	
	if (self == [super initWithTitle:myTitle message:[NSString stringWithFormat:@"%@\n\n\n", myMessage] delegate:myDelegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okButtonTitle, nil]) {
		
		textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 100.0, 260.0, 25.0)];
		[textField setBackgroundColor:[UIColor whiteColor]];
		[self addSubview:textField];
		[textField release];
        
        // check the version of os to translate the alert prompt
        NSArray *systemComponents = [(NSString *)[[UIDevice alloc] systemVersion] componentsSeparatedByString:@"."];
        
        if([[systemComponents objectAtIndex:0] intValue] < 4){
            CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0);
            [self setTransform:translate];
        }
	}
	return self;
}

- (void)show {
	[textField becomeFirstResponder];
	[super show];
}

- (NSString *)enteredText {
	return textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)myTextField {
	[textField resignFirstResponder];
	return YES;
}

- (void)dealloc {
	[textField release];
	[super dealloc];
}

@end
