//
//  ProcessorParam.h
//  ARRubiksCube
//
//  Created by everettjf on 16/6/24.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>


struct ProcessorParam{
    int blur_guassianKernel = 11;
    
    int canny_lowThreshold = 50; // 0 - 100
    int canny_ratio = 3;
    int canny_kernel_size = 3;
    
    int dilate_kernalSize = 10;
    
    double minimumContourAreaParam = 3.0;
    
    double polygonEpsilonParam = 3;
};

extern ProcessorParam sp;