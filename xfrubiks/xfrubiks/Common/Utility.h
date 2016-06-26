//
//  Utility.h
//  xfrubiks
//
//  Created by everettjf on 16/6/26.
//  Copyright © 2016年 xfteam. All rights reserved.
//


@interface Utility : NSObject

+ (void)barInfo:(NSString*)str;
+ (void)barError:(NSString*)str;
+ (void)barSuccess:(NSString *)str;

#ifdef __cplusplus
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
+(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
#endif
@end
