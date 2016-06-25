//
//  LayerFaceView.h
//  xfrubiks
//
//  Created by everettjf on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayerFaceView : UIView

- (void)setColor:(UIColor*)color index:(NSUInteger)index;
- (void)setWaitingIndex:(NSUInteger)index;
- (void)removeWaiting;

@property (strong,nonatomic) NSString *text;

@end
