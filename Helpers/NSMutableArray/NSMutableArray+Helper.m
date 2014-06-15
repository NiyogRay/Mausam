//
//  NSMutableArray+Helper.m
//  Mausam
//
//  Created by Niyog Ray on 15/06/14.
//  Copyright (c) 2014 Niyog Ray. All rights reserved.
//

#import "NSMutableArray+Helper.h"

@implementation NSMutableArray (Helper)

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (to != from) {
        id obj = [self objectAtIndex:from];
//        [obj retain];
        [self removeObjectAtIndex:from];
        if (to >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:to];
        }
//        [obj release];
    }
}

@end
