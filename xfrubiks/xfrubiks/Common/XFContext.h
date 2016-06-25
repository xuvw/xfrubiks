//
//  XFContext.h
//  xfrubiks
//
//  Created by everettjf on 16/6/26.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuViewController.h"
#import "DisplayViewController.h"

@interface XFContext : NSObject

+ (XFContext*)context;

@property (weak,nonatomic) MenuViewController *menu;
@property (weak,nonatomic) DisplayViewController *display;

@end
