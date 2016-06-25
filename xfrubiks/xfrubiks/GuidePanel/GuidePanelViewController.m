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
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation GuidePanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _closeButton = [UIButton new];
    [self.view addSubview:_closeButton];
    
    _inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, MenueViewWith, SCREEN_HEIGHT/2)];
    _inputTextView.editable = NO;
    [self.view addSubview:_inputTextView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
