//
//  APIHelper.m
//  ValueNation
//
//  Created by Niyog Ray on 06/07/13.
//  Copyright (c) 2013 mac2. All rights reserved.
//

#import "APIHelper.h"

#import "NSMutableDictionary+JSON.h"

#import "PlistHelper.h"

@interface APIHelper ()
{
    NSString *apiName;
    NSInteger tag;
    
    NSDictionary *plist;
    NSDictionary *api;
    
    NSString    *apiDomain;
    NSString    *apiString;
    NSURL       *apiURL;
    NSString    *apiMethod;
    BOOL        hasParameter;
    NSString    *apiParam;
    NSMutableDictionary *apiPostParam;
    
    NSString    *apiKey;
    
    NSURLConnection *apiConnection;
    
    NSMutableData           *responseData;
    NSMutableDictionary     *response;
    NSString                *message;
}
@end

@implementation APIHelper
@synthesize apiDelegate;

- (id)initWithDelegate:(id<APIDelegate>)delegateObject
{
    if (self = [super init])
    {
        self.apiDelegate = delegateObject;
        [self initData];
    }
    return self;
}

- (void)initData
{
    response = [NSMutableDictionary new];
}

- (void)callAPI:(NSString *)apiName2 Param:(id)apiParam2 Tag:(NSInteger)tag2
{
    apiName = apiName2;
    tag = tag2;
    
    api = [[PlistHelper new] getAPI:apiName];

    apiDomain = [[[PlistHelper new] getDictionaryForPlist:@"APIs"] objectForKey:@"apiDomain"];
    
    apiString   = [apiDomain stringByAppendingString:[api objectForKey:@"apiURL"]];
    apiMethod   = [api objectForKey:@"apiMethod"];
    hasParameter= [[api objectForKey:@"hasParameter"] boolValue];
    
    // METHOD
        // POST
    if ([apiMethod isEqualToString:@"POST"])
    {
        apiParam = nil;
        apiPostParam = apiParam2;
    }
        // GET or DELETE
    else
    {
        if (hasParameter)
            apiParam = apiParam2;
    }
    
    // URL
        // GET or DELETE
    if (([apiMethod isEqualToString:@"GET"] || [apiMethod isEqualToString:@"DELETE"]) && apiParam != nil)
        apiString = [NSString stringWithFormat:@"%@?%@", apiString, apiParam];
    
    apiString = [apiString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    apiURL = [NSURL URLWithString:apiString];
    
    [self callAPI];
}

// Called when Whoami Successful
- (void)callAPI
{
    // REQUEST
        // Create Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiURL];
    
        // Method
    [request setHTTPMethod:apiMethod];
    
        // Body
    if ([apiMethod isEqualToString:@"POST"])
    {
        if ([apiPostParam isConvertibleToJSON])
        {
            NSData *postData = [apiPostParam toJSON];
            [request setHTTPBody:postData];
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
    }
    
        // Clear response
    responseData = nil;
    
        // Send Request
    apiConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (IS_DEBUG)
    {
        if(apiConnection)
            NSLog(@"Connection Success - %@", apiName);
        else
            NSLog(@"Connection FAIL - %@", apiName);
    }
}

- (void)cancel
{
    if (apiConnection)
        [apiConnection cancel];
}

#pragma mark - Connection Delegate Fx
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (responseData == nil)
        responseData = [[NSMutableData alloc] initWithData:data];
    else
        [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection cancel];
    [self gotResponse];
}


#pragma mark - Fx
- (void)gotResponse
{
    // Check result
    NSError* error  = nil;
    response = [NSJSONSerialization JSONObjectWithData:responseData
                                               options:(NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves)
                                                 error:&error];
    
    if (IS_DEBUG_RESPONSE)
    {
        NSLog(@"%@ \nAPI Response", response);
    }
    
    // API Error Responses
//    if (IS_DEBUG)
//    {
//        NSUInteger responseError = [[response objectForKey:@"error"] integerValue];
//        switch (responseError) {
//            case 1:
//                NSLog(@"ResponseError: Incorrect args sent to API");
//                break;
//            case 40966:
//                NSLog(@"ResponseError: PHP Exception");
//                break;
//            default:
//                break;
//        }
//    }
    
//    BOOL isResultTrue = [[response objectForKey:@"result"] boolValue];
//    
//    {
        if (apiDelegate != nil && [apiDelegate respondsToSelector:@selector(response:forAPI:withTag:)])
        {
            [self cleanDictionary:response];
            
            [[self apiDelegate] response:response forAPI:apiName withTag:tag];
        }
        
//        if (IS_DEBUG && !isResultTrue)
//            NSLog(@"Response FALSE");
//    }
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

- (void)cleanString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&euro;" withString:@"€"];
}

@end
