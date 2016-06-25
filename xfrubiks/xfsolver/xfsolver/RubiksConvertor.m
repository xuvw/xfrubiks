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
 白、黑 D
 */
+ (NSString*)convertColorToPostion:(NSString*)colors{
    
    NSArray *array = @[@"红", @"蓝", @"黄", @"橙", @"绿", @"白", @"黑"];

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
                }else if ([subStr isEqualToString:@"白"] || [subStr isEqualToString:@"黑"]){
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

+ (NSString *)convertColorToHanZi:(NSString*)colors{
    NSArray *array = @[@"红", @"蓝", @"黄", @"橙", @"绿", @"白", @"黑"];
    
    NSMutableString *mutStr = [NSMutableString string];
    NSLog(@"%@", colors);
    for (int i = 0; i < colors.length; i++) {
        NSString *subStr = [colors substringWithRange:NSMakeRange(i, 1)];
        for (NSString *str in array) {
            if ([subStr rangeOfString:str].location != NSNotFound) {
                [mutStr appendString:subStr];
            }
        }
    }
    NSLog(@"%@", mutStr);
    return mutStr;
}



+ (UIColor *)colorFromZhcnString:(NSString *)zhcnString{
    if(zhcnString.length == 0)return [UIColor grayColor];
    NSDictionary<NSString*,UIColor*> *dict =
  @{
    @"红":[UIColor redColor],
    @"橙":[UIColor orangeColor],
    @"蓝":[UIColor blueColor],
    @"绿":[UIColor greenColor],
    @"黄":[UIColor yellowColor],
    @"白":[UIColor whiteColor],
    };
    UIColor *ret = [dict objectForKey:[zhcnString substringWithRange:NSMakeRange(0, 1)]];
    if(!ret)return [UIColor grayColor];
    return ret;
}

+ (NSString *)translateResultToZhcnString:(NSString *)result{
    NSArray<NSString*> *steps = [result componentsSeparatedByString:@" "];
    NSLog(@"steps = %@",steps);
    
    NSDictionary<NSString*,NSString*> *directMap =
  @{
    @"U":@"顶层",
    @"R":@"右侧",
    @"F":@"前面",
    @"D":@"底层",
    @"L":@"左侧",
    @"B":@"后面",
    };
    
    for (NSString *step in directMap) {
        
    }
    
    return @"";
}

+ (NSString *)translateFaceIndexToZhcnString:(NSUInteger)index{
    // UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB
    switch (index) {
        case 0: return @"顶";
        case 1: return @"右";
        case 2: return @"前";
        case 3: return @"底";
        case 4: return @"左";
        case 5: return @"后";
        default:break;
    }
    return @"";
}

@end
