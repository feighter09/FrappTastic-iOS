//
//  FTDirectoryViewController.m
//  Frapptastic
//
//  Created by Austin Feight on 5/27/13.
//  Copyright (c) 2013 Lost In Flight Studios. All rights reserved.
//

#import "FTDirectoryViewController.h"

#import "AFJSONRequestOperation.h"
#import "FTUtilityMethods.h"

enum ButtonIndexes {
	CALL = 1,
	SEND_TEXT_MESSAGE = 2,
	ADD_CONTACT = 3
	};

@interface FTDirectoryViewController ()

@property (strong, nonatomic) NSArray *contacts;
@property (strong, nonatomic) NSDictionary *selectedContact;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progressCircle;

@end

@implementation FTDirectoryViewController

- (id)initWithStyle:(UITableViewStyle)style {

	if (self = [super initWithStyle:style]) {
		self.contacts = [[NSArray alloc] init];
		self.selectedContact = [[NSDictionary alloc] init];
	}
	
	return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	[self getTableInfo];
	
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
 
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return [_contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
  // Configure the cell...
	NSString *first = [[_contacts objectAtIndex:indexPath.row] objectForKey:@"first"],
			 *last = [[_contacts objectAtIndex:indexPath.row] objectForKey:@"last"],
			 *name = [NSString stringWithFormat:@"%@ %@", first, last];
	cell.textLabel.text = name;
    
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self setSelectedContact:[self.contacts objectAtIndex:indexPath.row]];
	[self showSelectedCellMenu];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showSelectedCellMenu {
	
	UIAlertView *menu = [[UIAlertView alloc] initWithTitle:@"What would you like to do?"
												   message:nil
												  delegate:self
										 cancelButtonTitle:@"Cancel"
										 otherButtonTitles:@"Call", @"Send Text Message", @"Add to Contacts", nil];
	[menu show];
}

- (void)alertView:alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == CALL)
		[self callContact];
	else if (buttonIndex == SEND_TEXT_MESSAGE)
		[self textContact];
	else if	(buttonIndex == ADD_CONTACT)
		[self showNewPersonViewController];
	else if ([[alertView title] isEqualToString:@"Whoops!"] && buttonIndex == 1) //retry on error message
		[self getTableInfo];
}

- (void)callContact {
	
	NSLog(@"Calling contact: %@ %@, phone number: %@", [self.selectedContact objectForKey:@"first"],
														[self.selectedContact objectForKey:@"last"],
														[self.selectedContact objectForKey:@"phone"]);
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [self.selectedContact objectForKey:@"phone"]]]];
}

- (void)textContact {
	
	if (![MFMessageComposeViewController canSendText])
		return;
	
	NSLog(@"Sending text to: %@ %@, phone number: %@", [self.selectedContact objectForKey:@"first"],
		  [self.selectedContact objectForKey:@"last"],
		  [self.selectedContact objectForKey:@"phone"]);
	MFMessageComposeViewController *texter = [[MFMessageComposeViewController alloc] init];
//	[texter setDelegate:self];
	[texter setRecipients:@[[self.selectedContact objectForKey:@"phone"]]];
	[self presentViewController:texter animated:YES completion:nil];
}

#pragma mark - Network Calls

- (void)getTableInfo {
	
	NSURL *url = [NSURL URLWithString:@"http://www.triangleumich.com/mobile_directory.php"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
	
		_contacts = JSON;
		NSLog(@"JSON received: %@", [JSON description]);
		NSLog(@"JSON received: %@", [_contacts description]);
		
		[self refreshControl];
		[self.tableView reloadData];
		[_progressCircle stopAnimating];
	
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
	
		NSLog(@"Error grabbing contacts: %@", error);
		NSString *message = @"Failed to grab directory contact information.";
		[FTUtilityMethods raiseError:message withDelegate:self];
	
	}];
	[op start];
}

#pragma mark - ABNewPerson Delegation -

- (void)showNewPersonViewController {
	
	ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
	picker.newPersonViewDelegate = self;
	
	ABRecordRef newContact = ABPersonCreate();
	CFErrorRef error;
	NSDictionary *contact = [self selectedContact];
	ABRecordSetValue(newContact, kABPersonFirstNameProperty, (__bridge CFTypeRef)[contact objectForKey:@"first"], &error);
	ABRecordSetValue(newContact, kABPersonLastNameProperty, (__bridge CFTypeRef)[contact objectForKey:@"last"], &error);
	
	ABMutableMultiValueRef phoneInfo = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	ABMultiValueAddValueAndLabel(phoneInfo, (__bridge CFTypeRef)[contact objectForKey:@"phone"], kABPersonPhoneMobileLabel, NULL);
	ABRecordSetValue(newContact, kABPersonPhoneProperty, phoneInfo, nil);
	
	ABMutableMultiValueRef emailInfo = ABMultiValueCreateMutable(kABPersonEmailProperty);
	ABMultiValueAddValueAndLabel(emailInfo, (__bridge CFTypeRef)[[contact objectForKey:@"email"] stringByAppendingString:@"@umich.edu"], kABWorkLabel, NULL);
	ABRecordSetValue(newContact, kABPersonEmailProperty, emailInfo, nil);
	
	picker.displayedPerson = newContact;
	
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
	
	[self presentViewController:navigation animated:YES completion:nil];
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person {
	
	[self dismissViewControllerAnimated:YES completion:^{
		if (person) {
			id firstName = (__bridge id)(ABRecordCopyValue(person, kABPersonFirstNameProperty)),
				 lastName = (__bridge id)(ABRecordCopyValue(person, kABPersonLastNameProperty));
			NSLog(@"Person saved: %@ %@", firstName, lastName);
			
			NSString *title = @"Success", *message = [NSString stringWithFormat:@"\"%@ %@\" was saved to contacts", firstName, lastName];
			[FTUtilityMethods showAlert:title withMessage:message andDelegate:nil];
		}
	}];
}

@end
