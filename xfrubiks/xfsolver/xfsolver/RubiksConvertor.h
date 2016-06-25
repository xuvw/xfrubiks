//
//  RubiksConvertor.h
//  xfsolver
//
//  Created by L on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RubiksConvertor : NSObject

+ (NSString *)convertColorToPostion:(NSString*)colors;

+ (NSString *)convertColorToHanZi:(NSString*)colors;

@end
