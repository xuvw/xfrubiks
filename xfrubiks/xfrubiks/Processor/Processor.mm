//
//  Processor.m
//  ARRubiksCube
//
//  Created by everettjf on 16/6/22.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "Processor.h"
#include "opencv2/imgproc.hpp"
#include "opencv2/highgui.hpp"
#include "ProcessorParam.h"



void Processor::processImage(cv::Mat & src){
    
    // Gray Scale
    cv::Mat grayscale_img;
    {
        cvtColor(src, grayscale_img, cv::COLOR_BGR2GRAY);
    }
    
    // Guassian Blur
    cv::Mat blur_img;
    {
        GaussianBlur( grayscale_img, blur_img, cv::Size( sp.blur_guassianKernel, sp.blur_guassianKernel ), -1, -1 );
        grayscale_img.release();
    }
    
    // Canny Edge Detector
    cv::Mat canny_img;
    {
        int upperThreshold = sp.canny_lowThreshold * sp.canny_ratio; // 0 - 100
        Canny( blur_img, canny_img, sp.canny_lowThreshold, upperThreshold, sp.canny_kernel_size , false);
        blur_img.release();
    }
    
    // dilate
    cv::Mat dilate_img;
    {
        cv::dilate(canny_img, dilate_img, cv::getStructuringElement(CV_SHAPE_RECT, cv::Size(sp.dilate_kernalSize,sp.dilate_kernalSize)));
        canny_img.release();
    }
    
    
//    // Contour
//    std::vector<std::vector<Point>> contours;
//    cv::Mat hierarchy;
//    {
//        cv::findContours(dilate_img, contours, hierarchy, CV_RETR_LIST, CV_CHAIN_APPROX_SIMPLE);
//        dilate_img.release();
//    }
    
//    // Polygon
//    {
//        for(std::vector<Point> contour : contours){
//            double contourArea = cv::contourArea(contour,true);
//            if(contourArea < 0.0)
//                continue;
//            
//            if(contourArea < sp.minimumContourAreaParam)
//                continue;
//            
//            
//            std::vector<Point> polygon;
//            cv::approxPolyDP(contour, polygon, sp.polygonEpsilonParam, true);
//            
//        }
//    }
    
    dilate_img.copyTo(src);
}
