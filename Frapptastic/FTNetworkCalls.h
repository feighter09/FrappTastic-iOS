//
//  FTNetworkCalls.h
//  Frapptastic
//
//  Created by Austin Feight on 7/6/13.
//  Copyright (c) 2013 Lost In Flight Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTNetworkCalls : NSObject

+ (void)loadEventsWithSuccess:(void (^) (id JSON))success
					  failure:(void (^) (id JSON))failure;

@end
