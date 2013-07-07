//
//  FTNetworkCalls.m
//  Frapptastic
//
//  Created by Austin Feight on 7/6/13.
//  Copyright (c) 2013 Lost In Flight Studios. All rights reserved.
//

#import "FTNetworkCalls.h"

#import "AFNetworking.h"

static NSString * const kTriangleAppBaseURLString = @"http://triangle-api.herokuapp.com";

@implementation FTNetworkCalls



+ (void)loadEventsWithSuccess:(void (^) (id JSON))success
					  failure:(void (^) (id JSON))failure {
	
	NSString *urlString = [NSString stringWithFormat:@"%@/%@", kTriangleAppBaseURLString, @"events"];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		
		success(JSON);
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		
		NSLog(@"Failed to fetch events list: %@", error);
		//if unauthorized, kick out
		failure(JSON);
		
	}];
	[operation start];
}

@end
