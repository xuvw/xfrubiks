//
//  ButtonMenuView.m
//  xfrubiks
//
//  Created by everettjf on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "ButtonMenuView.h"

@implementation ButtonMenuView{
    UIButton *_red;
    UIButton *_orange;
    
    UIButton *_blue;
    UIButton *_green;
    
    UIButton *_yellow;
    UIButton *_white;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _red = [self _createButton:[UIColor redColor] row:0 col:0 tag:@"red"];
        _orange = [self _createButton:[UIColor orangeColor] row:1 col:0 tag:@"orange"];
        
        _blue = [self _createButton:[UIColor blueColor] row:0 col:1 tag:@"blue"];
        _green = [self _createButton:[UIColor greenColor] row:1 col:1 tag:@"green"];
        
        _yellow = [self _createButton:[UIColor yellowColor] row:0 col:2 tag:@"yellow"];
        _white = [self _createButton:[UIColor whiteColor] row:1 col:2 tag:@"white"];
    }
    return self;
}

- (UIButton*)_createButton:(UIColor*)color row:(NSUInteger)row col:(NSUInteger)col tag:(NSString*)tag{
    CGFloat width = 60;
    CGFloat hStep = ceil(SCREEN_WIDTH/2/4);
    CGFloat vStep = ceil(width*3/3) + 10;
    
    UIButton *button = [UIButton new];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.borderWidth = 1.0;
    button.backgroundColor = color;
    button.bounds = CGRectMake(0, 0, width, width);
    button.center = CGPointMake((col+1) * hStep, (row+1) * vStep);
    [button addTarget:self action:@selector(_colorTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (void)_colorTapped:(id)sender{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
