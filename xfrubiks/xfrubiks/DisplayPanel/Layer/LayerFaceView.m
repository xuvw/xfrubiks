//
//  LayerFaceView.m
//  xfrubiks
//
//  Created by everettjf on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "LayerFaceView.h"
#import "LayerBoxView.h"

@interface LayerFaceView ()

@property (strong,nonatomic) NSArray<LayerBoxView*> *views;
@property (strong,nonatomic) UILabel *label;

@end

@implementation LayerFaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _views = @[
                   [LayerBoxView new],
                   [LayerBoxView new],
                   [LayerBoxView new],
                   [LayerBoxView new],
                   [LayerBoxView new],
                   [LayerBoxView new],
                   [LayerBoxView new],
                   [LayerBoxView new],
                   [LayerBoxView new],
                   ];
        
//        CGFloat width = 
        [_views enumerateObjectsUsingBlock:^(LayerBoxView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger row = idx/3;
            NSUInteger col = idx%3;
            
//            obj.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0f];
            obj.frame = CGRectMake(col * frame.size.width/3, row * frame.size.height/3, frame.size.width/3, frame.size.height/3);
            obj.layer.borderColor = [UIColor grayColor].CGColor;
            obj.layer.borderWidth = 1.0;
            
            [self addSubview:obj];
        }];
        
        _label = [[UILabel alloc]init];
        [self addSubview:_label];
        _label.font = [UIFont systemFontOfSize:20];
        _label.textColor = [UIColor blackColor];
        _label.center = CGPointMake(frame.size.width/2 - 10, frame.size.height/2 - 10);
        
    }
    return self;
}

- (void)setColor:(UIColor *)color index:(NSUInteger)index{
    if(index > 8)return;
    
    _views[index].backgroundColor = color;
}

- (void)setText:(NSString *)text{
    _text = text;
    _label.text = text;
    [_label sizeToFit];
}

- (void)setWaitingIndex:(NSUInteger)index{
    if(index > _views.count - 1)return;
    
    _views[index].waitingInput = YES;
}

- (void)removeWaiting{
    [_views enumerateObjectsUsingBlock:^(LayerBoxView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.waitingInput = NO;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
