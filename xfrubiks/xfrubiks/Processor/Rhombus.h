#pragma once

/**
 * Augmented Reality Rubik Cube Wizard
 *
 * Author: Steven P. Punte (aka Android Steve : android.steve@cl-sw.com)
 * Date:   April 25th 2015
 *
 * Project Description:
 *   Android application developed on a commercial Smart Phone which, when run on a pair
 *   of Smart Glasses, guides a user through the process of solving a Rubik Cube.
 *
 * File Description:
 *
 *   Actually, can accommodate any polygon, but logic to filter out all non parallelograms
 *   is put here.  We use name "Rhombus" because it is succinct and unique.
 *
 *
 *   After processing, convex quadrilater vertices should be as show:
 *
 *   *    -----> X
 *   |
 *   |
 *  \ /
 *   Y                          * 0
 *                             / \
 *                       beta /   \ alpha
 *                           /     \
 *                        1 *       * 3
 *                           \     /
 *                            \   /
 *                             \ /
 *                              * 2
 *
 *  As show above alpha angle ~= +60 deg, beta angle ~= +120 deg
 *
 * License:
 *
 *  GPL
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include <vector>
#include <list>
#include <cmath>
#include "opencv2/imgproc.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/core.hpp"
#include "ProcessorParam.h"

class Rhombus {
public:
    
    // Possible states that this Rhombus can be identified.
    enum StatusEnum { NOT_PROCESSED, NOT_4_POINTS, NOT_CONVEX, AREA, CLOCKWISE, OUTLIER, VALID };
    
    // Current Status
    StatusEnum status = NOT_PROCESSED;
    
    // Various forms of storing the corner points.
    std::vector<cv::Point> polygonMatrix;
    std::list<cv::Point> polygonPointList;  // =+= possibly eliminate
    std::vector<cv::Point> polygonePointArray;    // =+= note order is adjusted
    
    // Center of Polygon
    cv::Point center;
    
    // Area of Quadrilateral.
    double area;
    
    // Smaller angle (in degrees: between 0 and 180) that two set parallelogram edges make to x-axis.
    double alphaAngle;
    
    // Larger angle (in degrees: between 0 and 180) that two set parallelogram edges make to x-axis.
    double betaAngle;
    
    // Best estimate (average) of parallelogram alpha side length.
    double alphaLength;
    
    // Best estimate (average) of parallelogram beta side length.
    double betaLength;
    
    // Ratio of beta to alpha length.
    double gammaRatio;
    
    
    
    /**
     * Rhombus Constructor
     *
     *
     * @param polygon
     */
    Rhombus(std::vector<cv::Point> polygon) {
        polygonMatrix = polygon;
        
        for(auto o : polygon){
            polygonPointList.push_back(o);
        }
        polygonePointArray = polygon;
    }
    
    
    
    
    /**
     * Determine is polygon is a value Rubik Face Parallelogram
     */
    void qualify() {
        
        // Calculate center
        double x=0; double y=0;
        for(cv::Point point : polygonPointList) {
            x += point.x;
            y += point.y;
        }
        center.x = x / polygonPointList.size();
        center.y = y / polygonPointList.size();
        
        // Check if has four sizes and endpoints.
        if(polygonPointList.size() != 4) {
            status = NOT_4_POINTS;
            return;
        }
        
        // Check if convex
        // =+= I don't believe this is working.  result should be either true or
        // =+= false indicating clockwise or counter-clockwise depending if image
        // =+= is a "hole" or a "blob".
        if(cv::isContourConvex(polygonMatrix) == false) {
            status = NOT_CONVEX;
            return;
        }
        
        // Compute area; check if it is reasonable.
        area = areaOfConvexQuadrilateral(polygonePointArray);
//        todo : if( (area < MenuAndParams.minimumRhombusAreaParam.value) || (area > MenuAndParams.maximumRhombusAreaParam.value) ) {
//        if( (area < 0) || (area > MenuAndParams.maximumRhombusAreaParam.value) ) {
//            status = AREA;
//            return;
//        }
        
        // Adjust vertices such that element 0 is at bottom and order is counter clockwise.
        // =+= return true here if points are counter-clockwise.
        // =+= sometimes both rotations are provided.
        if( adjustQuadrilaterVertices() == true) {
            status = CLOCKWISE;
            return;
        }
        
        
        // =+= beta calculation is failing when close to horizontal.
        // =+= Can vertices be chooses so that we do not encounter the roll over problem at +180?
        // =+= Or can math be performed differently?
        
        /*
         * Calculate angles to X axis of Parallelogram sides.  Take average of both sides.
         * =+= To Do:
         *   1) Move to radians.
         *   2) Move to +/- PIE representation.
         */
        
        alphaAngle = 180.0 / M_PI * atan2(
                                                  (polygonePointArray[1].y - polygonePointArray[0].y) + (polygonePointArray[2].y - polygonePointArray[3].y),
                                                  (polygonePointArray[1].x - polygonePointArray[0].x) + (polygonePointArray[2].x - polygonePointArray[3].x) );
        
        betaAngle = 180.0 / M_PI * atan2(
                                                 (polygonePointArray[2].y - polygonePointArray[1].y) + (polygonePointArray[3].y - polygonePointArray[0].y),
                                                 (polygonePointArray[2].x - polygonePointArray[1].x) + (polygonePointArray[3].x - polygonePointArray[0].x) );
        
        alphaLength = (lineLength(polygonePointArray[0], polygonePointArray[1]) + lineLength(polygonePointArray[3], polygonePointArray[2]) ) / 2;
        betaLength  = (lineLength(polygonePointArray[0], polygonePointArray[3]) + lineLength(polygonePointArray[1], polygonePointArray[2]) ) / 2;
        
        gammaRatio = betaLength / alphaLength;
        
        
        status = VALID;
        
//        Log.d(Constants.TAG, String.format( "Rhombus: %4.0f %4.0f %6.0f %4.0f %4.0f %3.0f %3.0f %5.2f {%4.0f,%4.0f} {%4.0f,%4.0f} {%4.0f,%4.0f} {%4.0f,%4.0f}",
//                                           center.x,
//                                           center.y,
//                                           area,
//                                           alphaAngle,
//                                           betaAngle,
//                                           alphaLength,
//                                           betaLength,
//                                           gammaRatio,
//                                           polygonePointArray[0].x,
//                                           polygonePointArray[0].y,
//                                           polygonePointArray[1].x,
//                                           polygonePointArray[1].y,
//                                           polygonePointArray[2].x,
//                                           polygonePointArray[2].y,
//                                           polygonePointArray[3].x,
//                                           polygonePointArray[3].y) + " " + status);
    }
    
    
    
    
    /**
     * Adjust Quadrilater Vertices such that:
     *   1) Element 0 has the minimum y coordinate.
     *   2) Order draws a counter clockwise quadrilater.
     */
    bool adjustQuadrilaterVertices() {
        
        // Find minimum.
        double y_min = MAXFLOAT;
        int index = 0;
        for(int i=0; i< polygonePointArray.size(); i++) {
            if(polygonePointArray[i].y < y_min) {
                y_min = polygonePointArray[i].y;
                index = i;
            }
        }
        
        // Rotate to get the minimum Y element ("index") as element 0.
        for(int i=0; i<index; i++) {
            cv::Point tmp = polygonePointArray[0];
            polygonePointArray[0] = polygonePointArray[1];
            polygonePointArray[1] = polygonePointArray[2];
            polygonePointArray[2] = polygonePointArray[3];
            polygonePointArray[3] = tmp;
        }
        
        // Return true if points are as depicted above and in a clockwise manner.
        if(polygonePointArray[1].x < polygonePointArray[3].x)
            return true;
        else
            return false;
    }
    
    
    
    /**
     * Area of Convex Quadrilateral
     *
     * @param quadrilateralPointArray
     * @return
     */
    static double areaOfConvexQuadrilateral(const std::vector<cv::Point> &quadrilateralPointArray) {
        
        //		Log.i(Constants.TAG, String.format( "Test: {%4.0f,%4.0f} {%4.0f,%4.0f} {%4.0f,%4.0f} {%4.0f,%4.0f}",
        //
        //				quadrilateralPointArray[0].x,
        //				quadrilateralPointArray[0].y,
        //				quadrilateralPointArray[1].x,
        //				quadrilateralPointArray[1].y,
        //				quadrilateralPointArray[2].x,
        //				quadrilateralPointArray[2].y,
        //				quadrilateralPointArray[3].x,
        //				quadrilateralPointArray[3].y));
        
        double area = Rhombus::areaOfaTriangle(
                                      lineLength(quadrilateralPointArray[0], quadrilateralPointArray[1]),
                                      lineLength(quadrilateralPointArray[1], quadrilateralPointArray[2]),
                                      lineLength(quadrilateralPointArray[2], quadrilateralPointArray[0]) )
        +
        Rhombus::areaOfaTriangle(
                        lineLength(quadrilateralPointArray[0], quadrilateralPointArray[3]),
                        lineLength(quadrilateralPointArray[3], quadrilateralPointArray[2]),
                        lineLength(quadrilateralPointArray[2], quadrilateralPointArray[0]) );
        
        //		Log.i(Constants.TAG, String.format( "Quadrilater Area: %6.0f", area));
        
        return area;
    }
    
    
    
    /**
     * Area of a triangle specified by the three side lengths.
     *
     * @param a
     * @param b
     * @param c
     * @return
     */
    static double areaOfaTriangle(double a, double b, double c) {
        
        double area = sqrt(
                                (a + b - c) *
                                (a - b + c) *
                                (-a + b + c) *
                                (a + b + c)
                                ) / 4.0;
        
        return area;
    }
    
    
    /**
     * Line length between two points.
     *
     * @param a
     * @param b
     * @return
     */
    static double lineLength(cv::Point a, cv::Point b) {
        double length = sqrt(
                                  (a.x - b.x) * (a.x - b.x) +
                                  (a.y - b.y) * (a.y - b.y) );
        
        return length;
    }
    
    
    
    /**
     * Draw
     * 
     * Render actual polygon.
     * 
     * @param rgba_gray_image
     * @param color
     */
    void draw(cv::Mat rgba_gray_image, cv::Scalar color) {
        
        std::vector<std::vector<cv::Point>> listOfPolygons;
        listOfPolygons.push_back(polygonMatrix);
        
        cv::polylines(rgba_gray_image,listOfPolygons,true,color,3);
    }
    
    
    
    
    /**
     * Remove Outlier Rhombi
     * 
     * For Alpha and Beta Angles:
     *   1) Find Median Value: i.e. value in which half are greater and half are less.
     *   2) Remove any that are > 10 degrees different
     * 
     */
    static void removedOutlierRhombi(std::vector<Rhombus> &rhombusList);
    
};

