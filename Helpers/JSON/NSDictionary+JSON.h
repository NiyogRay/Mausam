//
//  NSDictionary+JSON.h
//  JSON
//
//  Created by Niyog Ray on 03/06/13.
//  Copyright (c) 2013 mac2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

+ (NSDictionary* )dictionaryWithContentsOfJSONURLString: (NSString* )urlAddress;
- (BOOL)isConvertibleToJSON;
- (NSData* )toJSON;

@end
