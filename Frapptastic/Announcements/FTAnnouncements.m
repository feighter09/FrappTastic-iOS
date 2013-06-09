//
//  FTAnnouncements.m
//  Frapptastic
//
//  Created by Austin Feight on 5/27/13.
//  Copyright (c) 2013 Lost In Flight Studios. All rights reserved.
//

#import "FTAnnouncements.h"

static NSString *kFrapptasticBaseUrl = @"http://www.triangleumich.com/";

@implementation FTAnnouncements

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
	NSURL *url = [NSURL URLWithString:kFrapptasticBaseUrl];
		[self loadHTMLString:@"announcements.php" baseURL:url];
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
