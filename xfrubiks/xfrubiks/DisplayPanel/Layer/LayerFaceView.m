//
//  LayerFaceView.m
//  xfrubiks
//
//  Created by everettjf on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "LayerFaceView.h"

@interface LayerFaceView ()
@property (strong,nonatomic) UILabel *labelText;

@end

@implementation LayerFaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _labelText = [[UILabel alloc]init];
        [self addSubview:_labelText];
        [_labelText mas_makeConstraints:^(MASConstraintMaker *make){
            make.center.equalTo(self);
        }];

    }
    return self;
}

- (void)setTagText:(NSString *)tagText{
    _tagText = tagText;
    
    _labelText.text = tagText;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
