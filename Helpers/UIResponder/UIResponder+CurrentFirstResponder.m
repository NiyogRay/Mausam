//
//  UIResponder+CurrentFirstResponder.m
//  ValueNation
//
//  Created by mac2 on 09/10/13.
//  Copyright (c) 2013 mac2. All rights reserved.
//

#import "UIResponder+CurrentFirstResponder.h"

static __weak id currentFirstResponder;

@implementation UIResponder (CurrentFirstResponder)

+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end