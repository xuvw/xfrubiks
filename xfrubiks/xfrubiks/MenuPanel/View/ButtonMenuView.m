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
    CGFloat width = self.bounds.size.width/3;
    CGFloat height = 45;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(col * width, height * row, width, height)];
    button.backgroundColor = color;
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
