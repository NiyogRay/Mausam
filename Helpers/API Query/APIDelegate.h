//
//  APIDelegate.h
//  ValueNation
//
//  Created by Niyog Ray on 06/07/13.
//  Copyright (c) 2013 mac2. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APIDelegate <NSObject>

- (void)response:(NSMutableDictionary *)response forAPI:(NSString *)apiName withTag:(NSInteger)tag;

@end
