//
//  FTQuickEventViewController.m
//  Frapptastic
//
//  Created by Austin Feight on 6/16/13.
//  Copyright (c) 2013 Lost In Flight Studios. All rights reserved.
//

#import "FTQuickEventViewController.h"

#define kPickerTag 200

@interface FTQuickEventViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTypeLabel;

@end

@implementation FTQuickEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
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

#pragma mark - Date and Time -

- (IBAction)setDateAndTime:(id)sender {

	NSString *title = UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n";
	UIActionSheet *pickerSheet = [[UIActionSheet alloc] initWithTitle:title
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Set Date and Time", nil];
	UIDatePicker *datePicker = [[UIDatePicker alloc] init];
	[datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
	[datePicker setTag:kPickerTag];
	[pickerSheet addSubview:datePicker];
	
	[pickerSheet showInView:self.view];
}

- (IBAction)setEventType:(id)sender {
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 0) {
		UIDatePicker *picker = (UIDatePicker *)[actionSheet viewWithTag:kPickerTag];
		NSDate *date = [picker date];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EDT"]];
		[formatter setDateFormat:@"MM/dd/yyyy"];
		NSString *dateStr = [NSString stringWithString:[formatter stringFromDate:date]];
		
		[formatter setTimeStyle:NSDateFormatterLongStyle];
		NSString *timeStr = [NSString stringWithString:[formatter stringFromDate:date]];
		
		[self.dateLabel setText:dateStr];
		[self.timeLabel setText:timeStr];
	}
}

@end
