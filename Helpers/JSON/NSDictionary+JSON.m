//
//  NSDictionary+JSON.m
//  JSON
//
//  Created by Niyog Ray on 03/06/13.
//  Copyright (c) 2013 mac2. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

+ (NSDictionary* )dictionaryWithContentsOfJSONURLString:(NSString *)urlAddress
{
    NSData *data    = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlAddress]];
    __autoreleasing NSError* error  = nil;
    id result       = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error != nil) return nil;
    
    return result;
}

- (BOOL)isConvertibleToJSON
{
    return [NSJSONSerialization isValidJSONObject:self];
}

- (NSData *)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    
    if (error != nil) return nil;
    
    return result;
}

@end
