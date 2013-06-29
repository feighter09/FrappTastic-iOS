//
//  FTMainMenuViewController.m
//  Frapptastic
//
//  Created by Austin Feight on 6/16/13.
//  Copyright (c) 2013 Lost In Flight Studios. All rights reserved.
//

#import "FTMainMenuViewController.h"

#import "FTPersistence.h"

@interface FTMainMenuViewController ()
- (IBAction)logOut:(id)sender;

@end

@implementation FTMainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOut:(id)sender {
	[FTPersistence clearSavedData];
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
