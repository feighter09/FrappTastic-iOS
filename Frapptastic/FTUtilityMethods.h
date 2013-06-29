//
//  FTUtilityMethods.h
//  Frapptastic
//
//  Created by Austin Feight on 6/10/13.
//  Copyright (c) 2013 Lost In Flight Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTUtilityMethods : NSObject

+ (void)showAlert:(NSString*)title withMessage:(NSString*)message andDelegate:(id)delegate;
+ (void)raiseError:(NSString*)message withDelegate:(id)delegate;

@end
