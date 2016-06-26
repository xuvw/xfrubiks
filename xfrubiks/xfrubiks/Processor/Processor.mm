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
#include <string>
#include <sstream>



void Processor::processImage(cv::Mat & src){
    cv::Mat image;
    src.copyTo(image);

    cv::Size imageSize = src.size();
    
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
    
    
    // Contour
    std::vector<std::vector<cv::Point>> contours;
    std::vector<cv::Vec4i> hierarchy;
    {
        cv::findContours(dilate_img, contours, hierarchy,  cv::RETR_LIST, cv::CHAIN_APPROX_SIMPLE);
        dilate_img.release();
        
        cv::Mat gray_image(imageSize, CV_8UC4);
        cv::Mat rgba_gray_image(imageSize, CV_8UC4);
        cv::cvtColor( image, gray_image, cv::COLOR_RGB2GRAY);
        cv::cvtColor(gray_image, rgba_gray_image, cv::COLOR_GRAY2BGRA, 3);
        
        cv::Scalar color( 255, 0, 0 );
        cv::drawContours(rgba_gray_image, contours, -1, color,3);
        
        std::stringstream ss;
        ss << "Coutours count :" << contours.size();
        cv::String text("Contours Count:");
        cv::Scalar textColor(255,0,0);
        cv::putText(rgba_gray_image, cv::String(ss.str().c_str()), cv::Point(10,10), cv::FONT_HERSHEY_PLAIN, 4, textColor);
        
        rgba_gray_image.copyTo(src);
    }
    
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
    
    image.release();
}
