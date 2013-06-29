//
//  FTViewController.m
//  Frapptastic
//
//  Created by Austin Feight on 5/27/13.
//  Copyright (c) 2013 Lost In Flight Studios. All rights reserved.
//

#import "FTLoginViewController.h"

#import "FTUtilityMethods.h"
#import "FTPersistence.h"

@interface FTLoginViewController ()

@property (strong, nonatomic) NSString *uniqname, *password;

@property (weak, nonatomic) IBOutlet UITextField *uniqnameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressCircle;
@property (weak, nonatomic) IBOutlet UIButton *button;

- (IBAction)logInBegin:(id)sender;

@end

@implementation FTLoginViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	[self autoLogIn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field Delegation -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.view endEditing:YES];
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - POST Request -

- (IBAction)logInBegin:(id)sender {

	if ([[_uniqnameField text] isEqualToString:@""] || [[_passwordField text] isEqualToString:@""]) {
		[FTUtilityMethods showAlert:@"Whoops!" withMessage:@"Please enter uniqname and password" andDelegate:nil];
		return;
	} else {
		_uniqname = [_uniqnameField text];
		_password = [_passwordField text];
	}
	
	NSURL *url = [NSURL URLWithString:@"http://www.triangleumich.com/mobile_login_check.php"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPMethod:@"POST"];
	
	NSString *postData = [NSString stringWithFormat:@"name=%@&password=%@", _uniqname , _password];
	[request setHTTPBody:[NSData dataWithBytes:[postData UTF8String] length:[postData length]]];
	
	[self showProgress];
	[NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

		if (error)
			[self performSelectorOnMainThread:@selector(logInError:) withObject:error waitUntilDone:NO];
		else
			[self performSelectorOnMainThread:@selector(finishLogIn:) withObject:data waitUntilDone:NO];
		
	}];
}

#pragma mark - Log In -

- (void)autoLogIn {
	
	_uniqname = [FTPersistence getUniqname];
	_password = [FTPersistence getPassword];
	if (_uniqname && _password) {
		[_uniqnameField setText:_uniqname];
		[_passwordField setText:_password];
		[self logInBegin:nil];
	}
}

- (void)logInError:(NSError *)error {
	
	[self hideProgress];
	NSLog(@"Log in request error: %@", error);
	[self raiseError:@"Something went wrong, please check internet connection and try again."];
	return;
}

- (void)finishLogIn:(NSData *)data {
	
	[self hideProgress];
	NSDictionary *reply = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
	NSLog(@"Server reply: %@", reply);
	
	if ([[reply objectForKey:@"success"] boolValue]) {
		[self saveLogIn:[reply objectForKey:@"firstName"] :[reply objectForKey:@"lastName"]];
		[self performSegueWithIdentifier:@"Log In" sender:self];
	} else {
		[self raiseError:[reply objectForKey:@"error"]];
	}
}

- (void)saveLogIn:(NSString *)firstName :(NSString *)lastName {
	[FTPersistence saveName:firstName lastName:lastName];
	[FTPersistence saveUniqname:_uniqname];
	[FTPersistence savePassword:_password];
}

#pragma mark - Progress Indicator -

- (void)showProgress {
	[_progressCircle setHidden:NO];
	[_progressCircle startAnimating];
	[_button setHidden:YES];
}

- (void)hideProgress {
	[_progressCircle stopAnimating];
	[_button setHidden:NO];
}

#pragma mark - Error handling -

- (void)raiseError:(NSString *)message {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
																									message:message
																								 delegate:self
																				cancelButtonTitle:@"OK"
																				otherButtonTitles:nil];
	[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

- (void)receivedData:(NSData*)data {
	NSLog(@"Data: %@", data);
	NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"Response: %@", response);
}

- (void)httpError:(NSError*)error {
	if (!error)
		NSLog(@"Error: received empty response");
	else
		NSLog(@"Error: %@", error);
}

#pragma mark - Log Out -

- (void)logOut {

	[self dismissViewControllerAnimated:YES completion:^{
		[FTPersistence clearSavedData];
	}];
}


@end
