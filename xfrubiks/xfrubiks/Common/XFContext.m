//
//  XFContext.m
//  xfrubiks
//
//  Created by everettjf on 16/6/26.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "XFContext.h"

@implementation XFContext

+ (XFContext *)context{
    static XFContext *o;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        o = [[XFContext alloc]init];
    });
    return o;
}

@end
