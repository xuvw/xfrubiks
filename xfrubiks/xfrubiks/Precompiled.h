//
//  Precompiled.h
//  xfrubiks
//
//  Created by everettjf on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#ifndef Precompiled_h
#define Precompiled_h

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Masonry.h>

#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:a]

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#endif /* Precompiled_h */
