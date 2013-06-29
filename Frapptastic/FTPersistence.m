//
//  FTPersistence.m
//  Frapptastic
//
//  Created by Austin Feight on 6/15/13.
//  Copyright (c) 2013 Lost In Flight Studios. All rights reserved.
//

#import "FTPersistence.h"

@implementation FTPersistence

+ (NSString *)getUniqname {
	return (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"uniqname"];
}

+ (void)saveUniqname:(NSString *)uniqname {
	[[NSUserDefaults standardUserDefaults] setObject:uniqname forKey:@"uniqname"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getPassword {
	return (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}

+ (void)savePassword:(NSString *)password {
	[[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getName {
	return (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
}

+ (void)saveName:(NSString *)firstName lastName:(NSString *)lastName {
	NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
	[[NSUserDefaults standardUserDefaults] setObject:fullName forKey:@"name"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearSavedData {
	NSString *domain = [[NSBundle mainBundle] bundleIdentifier];
	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domain];
}

@end
