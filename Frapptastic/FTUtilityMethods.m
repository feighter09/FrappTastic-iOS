//
//  FTUtilityMethods.m
//  Frapptastic
//
//  Created by Austin Feight on 6/10/13.
//  Copyright (c) 2013 Lost In Flight Studios. All rights reserved.
//

#import "FTUtilityMethods.h"

@implementation FTUtilityMethods

+ (void)showAlert:(NSString *)title withMessage:(NSString *)message andDelegate:(id)delegate {

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:nil];
	[alert show];
}

+ (void)raiseError:(NSString*)message withDelegate:(id)delegate {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!"
													message:message
												   delegate:delegate
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"Retry", nil];
	[alert show];
}


@end
