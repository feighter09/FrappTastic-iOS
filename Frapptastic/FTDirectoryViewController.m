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

@interface FTDirectoryViewController ()

@property (strong, nonatomic) NSArray *contacts;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressCircle;

@end

@implementation FTDirectoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self)
		_contacts = [[NSArray alloc] init];
	
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
	
	ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
	picker.newPersonViewDelegate = self;
	
	ABRecordRef newContact = ABPersonCreate();
	CFErrorRef error;
	NSDictionary *contact = [_contacts objectAtIndex:indexPath.row];
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

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if ([alertView.title isEqualToString:@"Whoops!"] && buttonIndex == 1) //retry on error message
		[self getTableInfo];
}

#pragma mark - ABNewPerson Delegation -

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
