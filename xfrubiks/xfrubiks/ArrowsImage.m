//
//  arrowsImage.m
//  xfrubiks
//
//  Created by L on 16/6/26.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "ArrowsImage.h"

@implementation ArrowsImage
+ (UIImageView *)getRightImage
{
    UIImage *image = [UIImage imageNamed:@"right"];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
    return imgView;
}

+ (UIImageView *)getLeftImage
{
    UIImage *image = [UIImage imageNamed:@"left"];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
    return imgView;
}

+ (UIImageView *)getUpImage
{
    UIImage *image = [UIImage imageNamed:@"up"];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
    imgView.transform = CGAffineTransformMakeRotation(M_PI/2);
    return imgView;
}

+ (UIImageView *)getDownImage{
    UIImage *image = [UIImage imageNamed:@"down"];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
    imgView.transform = CGAffineTransformMakeRotation(M_PI/2);
    return imgView;
}
@end
