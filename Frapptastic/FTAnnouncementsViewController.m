//
//  FTAnnouncementsViewController.m
//  Frapptastic
//
//  Created by Austin Feight on 5/27/13.
//  Copyright (c) 2013 Lost In Flight Studios. All rights reserved.
//

#import "FTAnnouncementsViewController.h"

@interface FTAnnouncementsViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progress;

@end

@implementation FTAnnouncementsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.webView.delegate = self;
	
	self.webView.scalesPageToFit = YES;
	
	NSURL *url = [NSURL URLWithString:@"http://www.triangleumich.com/announcements.php"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
	[self showProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self hideProgress];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showProgress {
	[self.progress setHidden:NO];
	[self.progress setHidesWhenStopped:YES];
	[self.progress startAnimating];
}

- (void)hideProgress {
	[self.progress stopAnimating];
}

@end
