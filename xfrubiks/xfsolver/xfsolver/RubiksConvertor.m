//
//  RubiksConvertor.m
//  xfsolver
//
//  Created by L on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "RubiksConvertor.h"

@implementation RubiksConvertor
/**
 黄 U
 红 R
 蓝 F
 橙 L
 绿 B
 白 D
 */
+ (NSString*)convertColorToPostion:(NSString*)colors{
    
    NSArray *array = @[@"红", @"蓝", @"黄", @"橙", @"绿", @"白"];

    NSMutableString *mutStr = [NSMutableString string];
    NSLog(@"%@", colors);
    for (int i = 0; i < colors.length; i++) {
        NSString *subStr = [colors substringWithRange:NSMakeRange(i, 1)];
        for (NSString *str in array) {
            if ([subStr rangeOfString:str].location != NSNotFound) {
                if ([subStr isEqualToString:@"黄"]) {
                    [mutStr appendString:@"U"];
                }else if ([subStr isEqualToString:@"红"]){
                    [mutStr appendString:@"R"];
                }else if ([subStr isEqualToString:@"蓝"]){
                    [mutStr appendString:@"F"];
                }else if ([subStr isEqualToString:@"橙"]){
                    [mutStr appendString:@"L"];
                }else if ([subStr isEqualToString:@"绿"]){
                    [mutStr appendString:@"B"];
                }else if ([subStr isEqualToString:@"白"]){
                    [mutStr appendString:@"D"];
                }
            }
        }
    }
    NSLog(@"%@", mutStr);
    if (mutStr.length != 54) {
        NSLog(@"error");
    }
    return mutStr;
}
@end
