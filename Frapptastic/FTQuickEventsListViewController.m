//
//  FTQuickEventsListViewController.m
//  Frapptastic
//
//  Created by Austin Feight on 7/6/13.
//  Copyright (c) 2013 Lost In Flight Studios. All rights reserved.
//

#import "FTQuickEventsListViewController.h"

#import "FTUtilityMethods.h"

#import	"FTNetworkCalls.h"

@interface FTQuickEventsListViewController ()

@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) IBOutlet UITableView *eventsList;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progressCircle;

@end

@implementation FTQuickEventsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.eventsList setDataSource:self];
	[self.eventsList setDelegate:self];
	
	[self loadEvents];
}

#pragma mark - Table Data Functions - 

- (void)loadEvents {
	
	[self.progressCircle startAnimating];
	[FTNetworkCalls loadEventsWithSuccess:^(id JSON) {
		
		[self.progressCircle stopAnimating];
		[self setTableData:JSON];
		
	} failure:^(id JSON) {
		
		[self.progressCircle stopAnimating];
		NSString *message = @"Something went wrong loading the events list. Retry?";
		[FTUtilityMethods raiseError:message withDelegate:self];
		
	}];
}

- (void)setTableData:(NSArray *)receivedEvents {
	
	if (![receivedEvents count]) {
		NSString *alertTitle = @"No Events Found", *message = @"There are no active events to be shown";
		[FTUtilityMethods showAlert:alertTitle
						withMessage:message
						andDelegate:nil];
	}
	self.events = [[NSArray alloc] initWithArray:receivedEvents];
	[self.eventsList reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *simpleTableId = @"Quick Event Info";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableId];
	
	[cell.textLabel setText:[[self.events objectAtIndex:indexPath.row] objectForKey:@"title"]];
	NSString *organizerText = [NSString stringWithFormat:@"Organizer: %@", [[self.events objectAtIndex:indexPath.row] objectForKey:@"creator"]];
	[cell.detailTextLabel setText:organizerText];
	return cell;
}

#pragma mark - Error Handling -

- (void)alertView:alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 1)
		[self loadEvents];
}

@end
