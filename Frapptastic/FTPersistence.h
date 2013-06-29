//
//  FTPersistence.h
//  Frapptastic
//
//  Created by Austin Feight on 6/15/13.
//  Copyright (c) 2013 Lost In Flight Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTPersistence : NSUserDefaults

+ (NSString *)getUniqname;
+ (void)saveUniqname:(NSString *)uniqname;
+ (NSString *)getPassword;
+ (void)savePassword:(NSString *)password;

+ (NSString *)getName;
+ (void)saveName:(NSString *)firstName lastName:(NSString *)lastName;

+ (void)clearSavedData;

@end
