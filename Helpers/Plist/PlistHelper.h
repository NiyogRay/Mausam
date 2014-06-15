//
//  PlistHelper.h
//  ValueNation
//
//  Created by Niyog Ray on 24/06/13.
//  Copyright (c) 2013 mac2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistHelper : NSObject

// These 2 methods look for plist in Documents directory,
// else in app bundle
// To use for plist templates included in app bundle

/// Get a plist as a mutable dictionary
- (NSMutableDictionary *)getMutableDictionaryForPlist:(NSString *)plistName;

/// Get a plist as a dictionary
- (NSDictionary *)getDictionaryForPlist:(NSString *)plistName;

/// Save a mutable dictionary as a plist
- (void)saveDictionary:(NSMutableDictionary *)plistDict toPlist:(NSString *)plistName;

/// Get API data
- (NSDictionary *)getAPI:(NSString *)apiName;

// These methods look for plist ONLY in Documents directory,
// else return nil
// To use for non-bundle data

- (NSMutableDictionary *)getData:(NSString *)plistName;
- (void)saveData:(NSMutableDictionary *)data toPlist:(NSString *)plistName;

- (void)deleteAllData;

@end
