//
//  Rhombus.m
//  ARRubiksCube
//
//  Created by everettjf on 16/6/24.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "Rhombus.h"


void Rhombus::removedOutlierRhombi(std::vector<Rhombus> &rhombusList) {
    
    double angleOutlierTolerance = 3;//todo : MenuAndParams.angleOutlierThresholdPaaram.value;
    
    if(rhombusList.size() < 3)
        return;
    
    unsigned long midIndex = rhombusList.size() / 2;
    
    std::sort(rhombusList.begin(), rhombusList.end(), []( const Rhombus & lhs, const Rhombus & rhs){
        return lhs.alphaAngle > rhs.alphaAngle;
    });
    double medianAlphaAngle = rhombusList.at(midIndex).alphaAngle;
    
    
    std::sort(rhombusList.begin(), rhombusList.end(), []( const Rhombus & lhs, const Rhombus & rhs){
        return lhs.alphaAngle > rhs.alphaAngle;
    });
    
    double medianBetaAngle = rhombusList.at(midIndex).betaAngle;
    
    for(auto iter = rhombusList.begin(); iter != rhombusList.end(); ){
        if(fabs(iter->alphaAngle - medianAlphaAngle) > angleOutlierTolerance
           || fabs(iter->betaAngle - medianBetaAngle) > angleOutlierTolerance
            ){
            iter->status = OUTLIER;
            iter = rhombusList.erase(iter);
        }else{
            ++iter;
        }
    }
    
}