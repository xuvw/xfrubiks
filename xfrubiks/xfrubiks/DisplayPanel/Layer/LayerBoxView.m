//
//  LayerBoxView.m
//  xfrubiks
//
//  Created by everettjf on 16/6/26.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "LayerBoxView.h"
#import <YYImage.h>

@implementation LayerBoxView{
    UIImageView *_waiting;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setWaitingInput:(BOOL)waitingInput{
    _waitingInput = waitingInput;
    
    if(_waitingInput){
        if(_waiting)return;
        
        YYImage *image = [YYImage imageNamed:@"wall-e"];
        _waiting = [[YYAnimatedImageView alloc] initWithImage:image];
        [self addSubview:_waiting];
        _waiting.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _waiting.bounds = CGRectMake(0, 0, self.frame.size.width*2/3, self.frame.size.height*2/3);
    }else{
        [_waiting removeFromSuperview];
    }
}


@end
