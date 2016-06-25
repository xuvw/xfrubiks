//
//  RubiksSolver.m
//  xfsolver
//
//  Created by everettjf on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "RubiksSolver.h"
#include "search.h"

@implementation RubiksSolver


+(NSString *)solve:(NSString *)input{
    const char *facelets = input.UTF8String;
    if(!facelets) return nil;
    
    char *sol = solution(
        facelets,
        24,
        1000,
        0,
        "cache"
    );
    if (sol == NULL) {
        NSLog(@"Unsolvable cube!");
        return nil;
    }
    
    NSString *result = [NSString stringWithUTF8String:sol];
    free(sol);
    return result;
}

@end
