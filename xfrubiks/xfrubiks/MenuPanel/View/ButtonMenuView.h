//
//  ButtonMenuView.h
//  xfrubiks
//
//  Created by everettjf on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ButtonMenuView;
@protocol ButtonMenuViewDelegate <NSObject>
- (void)buttonMenuViewColorTapped:(NSString*)tagColor;
@end
@interface ButtonMenuView : UIView
@property (weak,nonatomic) id<ButtonMenuViewDelegate> delegate;
@end
