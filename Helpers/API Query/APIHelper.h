//
//  APIHelper.h
//  ValueNation
//
//  Created by Niyog Ray on 06/07/13.
//  Copyright (c) 2013 mac2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIDelegate.h"

@interface APIHelper : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<APIDelegate> apiDelegate;

- (id)initWithDelegate:(id<APIDelegate>)delegateObject;

/// Call the API with apiName in APIs plist.
/// Param: Send a dictionary for POST, or a string for GET/DELETE APIs.
/// Tag helps identify among multiple API calls by the same delegate.
- (void)callAPI:(NSString *)apiName Param:(id)apiParam Tag:(NSInteger)tag;

- (void)cancel;

@end
