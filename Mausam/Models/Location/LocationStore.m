//
//  LocationStore.m
//  Mausam
//
//  Created by Niyog Ray on 15/06/14.
//  Copyright (c) 2014 Niyog Ray. All rights reserved.
//

#import "LocationStore.h"

@implementation LocationStore
{
    NSMutableDictionary *data;
    NSMutableArray *locations;
}

- (void)loadData
{
    data = [[PlistHelper new] getMutableDictionaryForPlist:@"Locations"];
    locations = [data objectForKey:@"locations"];
    if (!locations)
    {
        locations = [NSMutableArray new];
    }
}

- (NSMutableArray *)locations
{
    [self loadData];
    return locations;
}

- (NSMutableDictionary *)locationAtIndex:(NSUInteger)index
{
    [self loadData];
    
    if (index < locations.count)
    {
        NSMutableDictionary *location = [locations objectAtIndex:index];
        return location;
    }
    else
        return nil;
}

- (void)addNewLocationFromSearchResult:(NSMutableDictionary *)searchResult
{
    [self loadData];
    
    NSString *locationID                        = [searchResult objectForKey:@"id"];
    NSString *locationName                      = [searchResult objectForKey:@"name"];
    NSMutableDictionary *locationCoordinates    = [searchResult objectForKey:@"coord"];
    NSString *locationSys                       = [searchResult objectForKey:@"sys"];
    
    // Get timezone
    CLLocationDegrees latitude  = [[locationCoordinates objectForKey:@"lat"] doubleValue];
    CLLocationDegrees longitude = [[locationCoordinates objectForKey:@"lon"] doubleValue];
    CLLocation *location2       = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    NSTimeZone *timezone        = [[APTimeZones sharedInstance] timeZoneWithLocation:location2];
    NSString *locationTimezone  = timezone.name;
    
    NSMutableDictionary *location = [@{@"name"   : locationName,
                                       @"id"     : locationID,
                                       @"sys"    : locationSys,
                                       @"coord"  : locationCoordinates,
                                       @"timezone":locationTimezone} mutableCopy];
    
    [self insertLocation:location AtIndex:0];
}

- (void)insertLocation:(NSMutableDictionary *)location AtIndex:(NSUInteger)index
{
    [self loadData];
    [locations insertObject:location atIndex:index];
    
    [self saveData];
}

- (void)removeLocationAtIndex:(NSUInteger)index
{
    [self loadData];
    [locations removeObjectAtIndex:index];
    
    [self saveData];
}

- (void)saveLocations:(NSMutableArray *)locations2
{
    [self loadData];
    locations = locations2;
    
    [self saveData];
}

- (void)saveData
{
    [data setObject:locations forKey:@"locations"];
    [[PlistHelper new] saveData:data toPlist:@"Locations"];
}

@end
