//
//  ScreenSizeHelper.m
//  xfrubiks
//
//  Created by L on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "ScreenSizeHelper.h"

@implementation ScreenSizeHelper
+ (CGFloat)getDisplayViewWidth{
    return SCREEN_WIDTH/2 + 80;
}
+ (CGFloat)getMenuViewWidth{
    return SCREEN_WIDTH/2 - 80;
}
@end
