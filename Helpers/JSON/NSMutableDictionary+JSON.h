//
//  NSMutableDictionary+JSON.h
//  ValueNation
//
//  Created by Niyog Ray on 26/06/13.
//  Copyright (c) 2013 mac2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (JSON)

+ (NSMutableDictionary *)dictionaryWithContentsOfJSONURLString: (NSString* )urlAddress;
- (BOOL)isConvertibleToJSON;
- (NSData *)toJSON;

@end
