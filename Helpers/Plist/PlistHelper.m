//
//  PlistHelper.m
//  ValueNation
//
//  Created by Niyog Ray on 24/06/13.
//  Copyright (c) 2013 mac2. All rights reserved.
//

#import "PlistHelper.h"

@interface PlistHelper ()
{
    NSString *plistFile;
    NSArray  *paths;
    NSString *cachesPath;
    NSString *plistPath;
    
    NSMutableDictionary *plistData;
}

@end

@implementation PlistHelper

- (id)init
{
    if (self = [super init])
    {
        paths = NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES);
        cachesPath = [paths objectAtIndex:0];
    }
    return self;
}

#pragma mark - Mutable Plists

- (NSMutableDictionary *)getMutableDictionaryForPlist:(NSString *)plistName
{
    plistFile = [NSString stringWithFormat:@"%@.plist", plistName];
    plistPath = [cachesPath stringByAppendingPathComponent:plistFile];
    
    // check to see if plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSError *error;
    NSPropertyListFormat format;
    // convert static property list into dictionary object
    plistData = (NSMutableDictionary *)[NSPropertyListSerialization propertyListWithData:plistXML
                                                                                 options:NSPropertyListMutableContainersAndLeaves
                                                                                  format:&format
                                                                                   error:&error];
    return [NSMutableDictionary dictionaryWithDictionary:plistData];
}

// Get DATA
- (NSMutableDictionary *)getData:(NSString *)plistName
{
    plistFile = [NSString stringWithFormat:@"%@.plist", plistName];
    plistPath = [cachesPath stringByAppendingPathComponent:plistFile];
    
    // check to see if plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, return nil data
        return nil;
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSError *error;
    NSPropertyListFormat format;
    // convert static property list into dictionary object
    plistData = (NSMutableDictionary *)[NSPropertyListSerialization propertyListWithData:plistXML
                                                                                 options:NSPropertyListMutableContainersAndLeaves
                                                                                  format:&format
                                                                                   error:&error];
    return plistData;
}

// Generic Save
- (void)saveDictionary:(NSMutableDictionary *)plist
                      toPlist:(NSString *)plistName
{
    plistFile = [NSString stringWithFormat:@"%@.plist", plistName];
    plistPath = [cachesPath stringByAppendingPathComponent:plistFile];
    
    BOOL writeSuccess = [plist writeToFile:plistPath atomically:YES];
    if (IS_DEBUG)
        NSLog(@"%d", writeSuccess);
}

// Save DATA
- (void)saveData:(NSMutableDictionary *)data toPlist:(NSString *)plistName
{
    if (data)
    {
        plistFile = [NSString stringWithFormat:@"%@.plist", plistName];
        plistPath = [cachesPath stringByAppendingPathComponent:plistFile];
        
        [self cleanDictionary:data];
        
        // CODE - USE NSDATA
        NSError *error;
        NSData *nsdata = [NSPropertyListSerialization dataWithPropertyList:data
                                                                    format:NSPropertyListBinaryFormat_v1_0
                                                                   options:0
                                                                     error:&error];
        [nsdata writeToFile:plistPath options:0 error:&error];
        
//        BOOL writeSuccess = [data writeToFile:plistPath atomically:YES];
//        if (IS_DEBUG)
//            NSLog(@"%d", writeSuccess);
    }
}

#pragma mark - Immutable Plists

- (NSDictionary *)getDictionaryForPlist:(NSString *)plistName
{
    plistFile = [NSString stringWithFormat:@"%@.plist", plistName];
    plistPath = [cachesPath stringByAppendingPathComponent:plistFile];
    
    // check to see if plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSError *error;
    NSPropertyListFormat format;
    // convert static property list into dictionary object
    NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:plistXML
                                                                    options:NSPropertyListImmutable
                                                                     format:&format
                                                                      error:&error];
    return [NSDictionary dictionaryWithDictionary:plist];
}

// Get API
- (NSDictionary *)getAPI:(NSString *)apiName
{
    NSDictionary *plist = [self getDictionaryForPlist:@"APIs"];
    return [plist objectForKey:apiName];
}

#pragma mark - Delete contents of Documents directory

- (void)deleteAllData
{
    NSError *error;
    NSArray *allDataFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachesPath error:&error];
    
    for (NSString *dataFileName in allDataFiles)
    {
        // TEST2
        if (![dataFileName isEqualToString:@"Users.plist"])
            [self deleteFile:dataFileName];
    }
}

- (void)deleteFile:(NSString *)fileName
{
    NSString *path = [cachesPath stringByAppendingPathComponent:fileName];
    
    NSError *error;
    if(![[NSFileManager defaultManager] removeItemAtPath:path error:&error])
    {
        //TODO: Handle/Log error
    }
}

#pragma mark - Replace each Null value with EmptyString

- (void)cleanDictionary:(NSMutableDictionary *)dictionary
{
    // Get all keys
    NSArray *keys = [dictionary allKeys];
    // Check each object
    for (id key in keys)
    {
        id obj = [dictionary objectForKey:key];
        if (obj == [NSNull null])
        {
            [dictionary setObject:@"" forKey:key];
            if(IS_DEBUG)
                NSLog(@"Removed Null");
        }
        else if ([obj isKindOfClass:[NSMutableDictionary class]])
            [self cleanDictionary:obj];
        else if ([obj isKindOfClass:[NSMutableArray class]])
            [self cleanArray:obj];
        else if ([obj isKindOfClass:[NSString class]])
        {
            [self cleanString:obj];
            [dictionary setObject:obj forKey:key];
        }
    }
}

- (void)cleanArray:(NSMutableArray *)array
{
    for (id obj in array)
    {
        if ([obj isKindOfClass:[NSMutableDictionary class]])
            [self cleanDictionary:obj];
    }
}

// Replace HTML symbols with corresponding characters
- (void)cleanString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&euro;" withString:@"€"];
}

@end
