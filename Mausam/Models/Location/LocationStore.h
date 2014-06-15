//
//  LocationStore.h
//  Mausam
//
//  Created by Niyog Ray on 15/06/14.
//  Copyright (c) 2014 Niyog Ray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationStore : NSObject

/// Array of locations
- (NSMutableArray *)locations;

/// Location at index
- (NSMutableDictionary *)locationAtIndex:(NSUInteger)index;

/// Add search result as a location
- (void)addNewLocationFromSearchResult:(NSMutableDictionary *)searchResult;

/// Insert location at index
//- (void)insertLocation:(NSMutableDictionary *)location AtIndex:(NSUInteger)index;

/// Remove location at index
- (void)removeLocationAtIndex:(NSUInteger)index;

/// Save array of locations
- (void)saveLocations:(NSMutableArray *)locations;

@end
