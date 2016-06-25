//
//  GuidePanelViewController.m
//  xfrubiks
//
//  Created by everettjf on 16/6/26.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "GuidePanelViewController.h"
#import <xfsolver/xfsolver.h>
#import "ScreenSizeHelper.h"
#import "Utility.h"
#import <SVProgressHUD.h>
#import <SCLAlertView.h>

#define MenueViewWith [ScreenSizeHelper getMenuViewWidth]

@interface GuidePanelViewController ()
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) UIButton *nextStepButton;
@end

@implementation GuidePanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    _inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, MenueViewWith, SCREEN_HEIGHT/2 - 40)];
    _inputTextView.editable = NO;
    _inputTextView.selectable = NO;
    [self.view addSubview:_inputTextView];
    
    _nextStepButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, MenueViewWith, 40)];
    [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    _nextStepButton.layer.cornerRadius = 10;
    _nextStepButton.layer.masksToBounds = YES;
    [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextStepButton.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_nextStepButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSolution:(NSString *)solution{
    _solution = solution;
    
    _inputTextView.text = _solution;
}

@end
