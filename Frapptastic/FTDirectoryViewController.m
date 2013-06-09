//
//  FTDirectoryViewController.m
//  Frapptastic
//
//  Created by Austin Feight on 5/27/13.
//  Copyright (c) 2013 Lost In Flight Studios. All rights reserved.
//

#import "FTDirectoryViewController.h"
#import "AFJSONRequestOperation.h"

@interface FTDirectoryViewController ()

@end

@implementation FTDirectoryViewController {
	NSArray *contacts;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		contacts = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSLog(@"here");
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
    return [contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
	NSString *first = [[contacts objectAtIndex:indexPath.row] objectForKey:@"first"],
			 *last = [[contacts objectAtIndex:indexPath.row] objectForKey:@"last"],
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Network Calls

- (void)getTableInfo {
	/*
	NSArray *JSON = @[@{@"Index":@"93",@"rank":@"4",@"first":@"Yoav",@"last":@"Amaral",@"position":@"",@"email":@"yoav",@"password":@"noturnonred",@"phone":@"410-493-4109",@"major":@"Aerospace Engineering",@"housing":@"Live-Out"},@{@"Index":@"160",@"rank":@"4",@"first":@"Alexander",@"last":@"Arams",@"position":@"",@"email":@"aharams",@"password":@"noturnonred",@"phone":@"201-410-3154",@"major":@"Chemical Engineering",@"housing":@""},@{@"Index":@"83",@"rank":@"1",@"first":@"Noah",@"last":@"Balsmeyer",@"position":@"President",@"email":@"noahjb",@"password":@"noturnonred",@"phone":@"812-630-9568",@"major":@"Computer Engineering",@"housing":@"Live-In"},@{@"Index":@"71",@"rank":@"4",@"first":@"Michael",@"last":@"Baumhart",@"position":@"",@"email":@"baumhart",@"password":@"noturnonred",@"phone":@"847-373-7442",@"major":@"Materials Science and Engineering",@"housing":@""},@{@"Index":@"114",@"rank":@"4",@"first":@"Adam",@"last":@"Berkovec",@"position":@"",@"email":@"ajberk",@"password":@"noturnonred",@"phone":@"240-602-6693",@"major":@"Nuclear Engineering and Radiological Sciences",@"housing":@""},@{@"Index":@"115",@"rank":@"4",@"first":@"Brent",@"last":@"Better",@"position":@"",@"email":@"bbetter",@"password":@"noturnonred",@"phone":@"650-483-4394",@"major":@"Biomedical Engineering",@"housing":@""},@{@"Index":@"144",@"rank":@"2",@"first":@"Noah",@"last":@"Bond",@"position":@"Executive Vice President",@"email":@"nrbond",@"password":@"noturnonred",@"phone":@"586-337-3568",@"major":@"Computer Engineering",@"housing":@"Live-Out"},@{@"Index":@"158",@"rank":@"3",@"first":@"Taylor",@"last":@"Bradford",@"position":@"Historian, Collections",@"email":@"tbrad",@"password":@"noturnonred",@"phone":@"734-417-6681",@"major":@"Computer Science & Engineering",@"housing":@""},@{@"Index":@"116",@"rank":@"4",@"first":@"Andrew",@"last":@"Campbell",@"position":@"",@"email":@"campband",@"password":@"noturnonred",@"phone":@"517-927-7721",@"major":@"Chemical Engineering",@"housing":@""},@{@"Index":@"90",@"rank":@"3",@"first":@"Ritish",@"last":@"Chhabra",@"position":@"Judicial Board (Senior Member)",@"email":@"ritish",@"password":@"noturnonred",@"phone":@"810-742-7802",@"major":@"General Biology",@"housing":@"Live-Out"},@{@"Index":@"117",@"rank":@"2",@"first":@"Abhishek",@"last":@"Chitlangia",@"position":@"Vice President of Member Development",@"email":@"abhichit",@"password":@"noturnonred",@"phone":@"734-604-3422",@"major":@"Industrial and Operations Engineering",@"housing":@""},@{@"Index":@"149",@"rank":@"4",@"first":@"Aaron",@"last":@"Cohen",@"position":@"Brotherhood",@"email":@"aaronbc",@"password":@"noturnonred",@"phone":@"240-599-6096",@"major":@"Industrial and Operations Engineering",@"housing":@"Live-Out"},@{@"Index":@"95",@"rank":@"3",@"first":@"Jeffrey",@"last":@"DeSimone",@"position":@"House Improvements, Accounts Payable",@"email":@"jmdesim",@"password":@"noturnonred",@"phone":@"810-516-1538",@"major":@"Mechanical Engineering",@"housing":@"Live-Out"},@{@"Index":@"169",@"rank":@"3",@"first":@"Jacob",@"last":@"Dollman",@"position":@"Service",@"email":@"dollman",@"password":@"noturnonred",@"phone":@"419-575-7170",@"major":@"",@"housing":@""},@{@"Index":@"180",@"rank":@"4",@"first":@"Frederick",@"last":@"Duemling",@"position":@"",@"email":@"fduemlin",@"password":@"noturnonred",@"phone":@"810-305-1150",@"major":@"Undecided Engineering",@"housing":@""},@{@"Index":@"163",@"rank":@"3",@"first":@"Austin",@"last":@"Feight",@"position":@"Webmaster, Technical Consultant",@"email":@"afeight",@"password":@"noturnonred",@"phone":@"248-766-8844",@"major":@"Computer Science & Engineering",@"housing":@""},@{@"Index":@"107",@"rank":@"4",@"first":@"Andy",@"last":@"Gong",@"position":@"",@"email":@"zgong",@"password":@"noturnonred",@"phone":@"440-382-6462",@"major":@"Undeclared",@"housing":@"Live-Out"},@{@"Index":@"165",@"rank":@"3",@"first":@"Paul",@"last":@"Good",@"position":@"Greek Events",@"email":@"pcgood",@"password":@"noturnonred",@"phone":@"734-478-3031",@"major":@"Industrial Operations Engineering",@"housing":@""},@{@"Index":@"105",@"rank":@"4",@"first":@"Tyler",@"last":@"Groll",@"position":@"",@"email":@"tgroll",@"password":@"noturnonred",@"phone":@"774-272-2982",@"major":@"Naval Architecture and Marine Engineering",@"housing":@"Live-Out"},@{@"Index":@"108",@"rank":@"4",@"first":@"Ryan",@"last":@"Heise",@"position":@"",@"email":@"heiserya",@"password":@"noturnonred",@"phone":@"734-476-4675",@"major":@"Computer Engineering",@"housing":@"Live-Out"},@{@"Index":@"96",@"rank":@"4",@"first":@"Dillon",@"last":@"Helfers",@"position":@"Historian",@"email":@"dillonph",@"password":@"noturnonred",@"phone":@"314-402-7266",@"major":@"Naval Architecture and Marine Engineering",@"housing":@"Live-Out"},@{@"Index":@"168",@"rank":@"4",@"first":@"Kevinski",@"last":@"Himawan",@"position":@"Alumni Relations",@"email":@"kevinski",@"password":@"noturnonred",@"phone":@"734-709-6537",@"major":@"Undecided Engineering",@"housing":@""},@{@"Index":@"118",@"rank":@"3",@"first":@"Derek",@"last":@"Hofsess",@"position":@"Ritual Master",@"email":@"dhofsess",@"password":@"noturnonred",@"phone":@"517-648-8565",@"major":@"Biomedical Engineering",@"housing":@""},@{@"Index":@"75",@"rank":@"4",@"first":@"Eric",@"last":@"Hutchinson",@"position":@"",@"email":@"enhutch",@"password":@"noturnonred",@"phone":@"801-231-0536",@"major":@"Chemical Engineering",@"housing":@""},@{@"Index":@"120",@"rank":@"4",@"first":@"Robert",@"last":@"Isenberg",@"position":@"Academics",@"email":@"robji",@"password":@"noturnonred",@"phone":@"484-574-5085",@"major":@"Mechanical Engineering",@"housing":@""},@{@"Index":@"161",@"rank":@"4",@"first":@"Ali",@"last":@"Jawad",@"position":@"",@"email":@"ahjawad",@"password":@"noturnonred",@"phone":@"313-919-1874",@"major":@"Chemical Engineering",@"housing":@""},@{@"Index":@"146",@"rank":@"2",@"first":@"Ian",@"last":@"Kosasa",@"position":@"Vice President of External Relations",@"email":@"kballah",@"password":@"noturnonred",@"phone":@"808-384-2101",@"major":@"Biomedical Engineering",@"housing":@"Live-Out"},@{@"Index":@"177",@"rank":@"3",@"first":@"Christopher",@"last":@"Krebs",@"position":@"Alumni Relations, University\/Corporate Relations",@"email":@"cjkrebs",@"password":@"noturnonred",@"phone":@"734-536-5559",@"major":@"Naval Architecture and Marine Engineering",@"housing":@""},@{@"Index":@"181",@"rank":@"3",@"first":@"Matthew",@"last":@"Lapeer",@"position":@"Social",@"email":@"lapeerm",@"password":@"noturnonred",@"phone":@"810-391-7957",@"major":@"Undecided",@"housing":@""},@{@"Index":@"122",@"rank":@"4",@"first":@"Patrick",@"last":@"Lawless",@"position":@"",@"email":@"lawlpat",@"password":@"noturnonred",@"phone":@"616-481-1834",@"major":@"Mechanical Engineering",@"housing":@""},@{@"Index":@"182",@"rank":@"4",@"first":@"Matthew",@"last":@"Leibold",@"position":@"",@"email":@"leiboldm",@"password":@"noturnonred",@"phone":@"720-648-3346",@"major":@"Computer Engineering",@"housing":@""},@{@"Index":@"123",@"rank":@"3",@"first":@"Benjamin",@"last":@"Magee",@"position":@"Risk Management, House Management",@"email":@"benrm",@"password":@"noturnonred",@"phone":@"614-507-7375",@"major":@"Computer Science & Engineering",@"housing":@""},@{@"Index":@"124",@"rank":@"3",@"first":@"Mark",@"last":@"McCarthy",@"position":@"Pledge Education",@"email":@"mdmccart",@"password":@"noturnonred",@"phone":@"952-484-0053",@"major":@"Undecided",@"housing":@""},@{@"Index":@"172",@"rank":@"2",@"first":@"Abhishek",@"last":@"Nagpal",@"position":@"Vice President of Brotherhood",@"email":@"nagpala",@"password":@"noturnonred",@"phone":@"734-757-0870",@"major":@"",@"housing":@""},@{@"Index":@"174",@"rank":@"3",@"first":@"Arvind",@"last":@"Narayan",@"position":@"Professional Development",@"email":@"arvindna",@"password":@"noturnonred",@"phone":@"531-315-6710",@"major":@"",@"housing":@""},@{@"Index":@"125",@"rank":@"4",@"first":@"Michael",@"last":@"Nowak",@"position":@"",@"email":@"nowakmr",@"password":@"noturnonred",@"phone":@"313-310-1423",@"major":@"Computer Engineering",@"housing":@"Live-Out"},@{@"Index":@"140",@"rank":@"2",@"first":@"Joseph",@"last":@"Oliver",@"position":@"Vice President of Internal Operations",@"email":@"jdoliver",@"password":@"noturnonred",@"phone":@"313-969-3872",@"major":@"Mechanical Engineering",@"housing":@"Live-Out"},@{@"Index":@"112",@"rank":@"3",@"first":@"Jonathan",@"last":@"Padalis",@"position":@"General Counsel",@"email":@"jpadalis",@"password":@"noturnonred",@"phone":@"248-345-3411",@"major":@"Mechanical Engineering",@"housing":@"Live-Out"},@{@"Index":@"126",@"rank":@"4",@"first":@"Nishant",@"last":@"Patel",@"position":@"",@"email":@"nishantp",@"password":@"noturnonred",@"phone":@"203-675-2550",@"major":@"Nuclear Engineering, Financial Mathematics",@"housing":@""},@{@"Index":@"80",@"rank":@"4",@"first":@"Keith",@"last":@"Porter",@"position":@"",@"email":@"kbporter",@"password":@"noturnonred",@"phone":@"313-410-9044",@"major":@"Computer Engineering",@"housing":@""},@{@"Index":@"148",@"rank":@"4",@"first":@"Evan",@"last":@"Potter",@"position":@"Marketing",@"email":@"evpotter",@"password":@"noturnonred",@"phone":@"517-740-9904",@"major":@"Computer Science & Engineering",@"housing":@"Live-Out"},@{@"Index":@"127",@"rank":@"4",@"first":@"Jeffrey",@"last":@"Rizik",@"position":@"Brotherhood",@"email":@"jeffriz",@"password":@"noturnonred",@"phone":@"248-860-0228",@"major":@"Neuroscience",@"housing":@""},@{@"Index":@"74",@"rank":@"4",@"first":@"Christopher",@"last":@"Rocys",@"position":@"",@"email":@"crrocys",@"password":@"noturnonred",@"phone":@"248-420-5003",@"major":@"Industrial and Operations Engineering",@"housing":@""},@{@"Index":@"157",@"rank":@"3",@"first":@"Dylan",@"last":@"Sena",@"position":@"Efficiencies",@"email":@"dcsena",@"password":@"noturnonred",@"phone":@"551-427-3069",@"major":@"Mathematics and Physics",@"housing":@""},@{@"Index":@"139",@"rank":@"4",@"first":@"Henry",@"last":@"Shih",@"position":@"",@"email":@"hunshih",@"password":@"noturnonred",@"phone":@"734-272-8532",@"major":@"Electrical Engineering",@"housing":@"Live-Out"},@{@"Index":@"166",@"rank":@"3",@"first":@"Steven",@"last":@"Springer",@"position":@"Recruitment",@"email":@"umspring",@"password":@"noturnonred",@"phone":@"616-915-4219",@"major":@"Biology",@"housing":@""},@{@"Index":@"173",@"rank":@"3",@"first":@"Jacob",@"last":@"Stapleton-Reinhold",@"position":@"Marketing",@"email":@"jstap",@"password":@"noturnonred",@"phone":@"269-598-0935",@"major":@"Aerospace Engineering",@"housing":@""},@{@"Index":@"92",@"rank":@"2",@"first":@"Michael",@"last":@"Stengel",@"position":@"Vice President of Public Relations",@"email":@"mstengel",@"password":@"noturnonred",@"phone":@"610-295-8932",@"major":@"Aerospace Engineering",@"housing":@"Live-Out"},@{@"Index":@"179",@"rank":@"3",@"first":@"Lucas",@"last":@"Stevens",@"position":@"Academic",@"email":@"lusteven",@"password":@"noturnonred",@"phone":@"734-972-9842",@"major":@"Chemical Engineering",@"housing":@""},@{@"Index":@"101",@"rank":@"3",@"first":@"Ansgar",@"last":@"Strother",@"position":@"Judicial Board (Senior Member)",@"email":@"astrothe",@"password":@"noturnonred",@"phone":@"734-972-8617",@"major":@"Computer Engineering",@"housing":@"Live-Out"},@{@"Index":@"131",@"rank":@"4",@"first":@"Vinayak",@"last":@"Thapliyal",@"position":@"Technical Consultant",@"email":@"vint",@"password":@"noturnonred",@"phone":@"617-817-3172",@"major":@"Computer Engineering",@"housing":@""},@{@"Index":@"94",@"rank":@"4",@"first":@"Robert",@"last":@"Thomas",@"position":@"",@"email":@"trobert",@"password":@"noturnonred",@"phone":@"810-513-8407",@"major":@"Materials Science and Engineering",@"housing":@"Live-Out"},@{@"Index":@"138",@"rank":@"3",@"first":@"Ronnie",@"last":@"Trower",@"position":@"Judicial Board (Junior Member)",@"email":@"rtrower",@"password":@"noturnonred",@"phone":@"989-701-9992",@"major":@"Mechanical Engineering",@"housing":@"Live-Out"},@{@"Index":@"162",@"rank":@"4",@"first":@"Jun",@"last":@"Ueki",@"position":@"",@"email":@"uekij",@"password":@"noturnonred",@"phone":@"914-960-6262",@"major":@"Mechanical Engineering",@"housing":@""},@{@"Index":@"81",@"rank":@"4",@"first":@"Kevin",@"last":@"Welch",@"position":@"",@"email":@"kevinew",@"password":@"noturnonred",@"phone":@"269-313-2625",@"major":@"Physics",@"housing":@"Live-In"},@{@"Index":@"142",@"rank":@"3",@"first":@"Guy",@"last":@"Wilson",@"position":@"Leadership Development, Judicial Board (Junior Member)",@"email":@"guyw",@"password":@"noturnonred",@"phone":@"734-747-2761",@"major":@"Nuclear Engineering and Radiological Science",@"housing":@"Live-Out"},@{@"Index":@"154",@"rank":@"4",@"first":@"Lucas",@"last":@"Witt",@"position":@"Ritual Master",@"email":@"lcwitt",@"password":@"noturnonred",@"phone":@"517-215-0658",@"major":@"Chemical Engineering",@"housing":@""},@{@"Index":@"145",@"rank":@"4",@"first":@"David",@"last":@"Wolgin",@"position":@"Vice President of Brotherhood",@"email":@"dwolgin",@"password":@"noturnonred",@"phone":@"201-403-5697",@"major":@"Chemical Engineering",@"housing":@"Live-Out"},@{@"Index":@"178",@"rank":@"4",@"first":@"Jerrit",@"last":@"Yang",@"position":@"",@"email":@"yjerrit",@"password":@"noturnonred",@"phone":@"248-497-7554",@"major":@"Undecided Engineering",@"housing":@""},@{@"Index":@"159",@"rank":@"3",@"first":@"Jiawei",@"last":@"Zhou",@"position":@"Signature Events",@"email":@"ariezjz",@"password":@"noturnonred",@"phone":@"412-352-1057",@"major":@"Mechanical Engineering",@"housing":@""}];
	contacts = JSON;
	[self refreshControl];
	*/
	
	NSURL *url = [NSURL URLWithString:@"http://www.triangleumich.com/mobile_directory.php"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
	
		contacts = JSON;
		NSLog(@"JSON received: %@", [JSON description]);
		[self refreshControl];
	
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
	
		NSLog(@"Error grabbing contacts: %@", error);
		NSString *message = @"Failed to grab directory contact information.";
		[self raiseError:message];
	
	}];
	[op start];

}

- (void)raiseError:(NSString*)message {
	NSString *title = @"Whoops!";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"Retry", nil];
	[alert show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1)
		[self getTableInfo];
}

@end
