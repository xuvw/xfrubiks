//
//  Utility.m
//  xfrubiks
//
//  Created by everettjf on 16/6/26.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "Utility.h"
#import <TWMessageBarManager.h>

@implementation Utility

+ (void)barInfo:(NSString *)str{
    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"提示" description:str type:TWMessageBarMessageTypeInfo];
}

+ (void)barError:(NSString *)str{
    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"提示" description:str type:TWMessageBarMessageTypeError];
}

+ (void)barSuccess:(NSString *)str{
    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"提示" description:str type:TWMessageBarMessageTypeSuccess];
}


@end
