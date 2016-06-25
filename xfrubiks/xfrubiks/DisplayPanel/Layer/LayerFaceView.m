//
//  LayerFaceView.m
//  xfrubiks
//
//  Created by everettjf on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "LayerFaceView.h"

@interface LayerFaceView ()

@property (strong,nonatomic) NSArray<UIView*> *views;

@end

@implementation LayerFaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _views = @[
                   [UIView new],
                   [UIView new],
                   [UIView new],
                   [UIView new],
                   [UIView new],
                   [UIView new],
                   [UIView new],
                   [UIView new],
                   [UIView new],
                   ];
        
//        CGFloat width = 
        [_views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger row = idx/3;
            NSUInteger col = idx%3;
            
            obj.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0f];
            obj.frame = CGRectMake(col * frame.size.width/3, row * frame.size.height/3, frame.size.width/3, frame.size.height/3);
            [self addSubview:obj];
        }];
    }
    return self;
}

- (void)setTagText:(NSString *)tagText{
    _tagText = tagText;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
