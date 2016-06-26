//
//  DisplayViewController.m
//  xfrubiks
//
//  Created by everettjf on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "DisplayViewController.h"
#import "LayerDisplayView.h"
#import "ScreenSizeHelper.h"
#import "XFContext.h"
#import "ARPanelViewController.h"


@interface DisplayViewController ()
@property (strong, nonatomic) LayerDisplayView *cube;

@property (strong, nonatomic) UIButton *revertPosition;
@property (strong, nonatomic) UIButton *fillTestData;
@property (strong, nonatomic) UIButton *opencvLab;
@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    NSLog(@"display size = %@", [NSValue valueWithCGSize:self.view.bounds.size]);
    NSLog(@"screen size = %@", [NSValue valueWithCGSize:[UIScreen mainScreen].bounds.size]);
    
    CGFloat width = 250;
    _cube = [[LayerDisplayView alloc]initWithFrame:CGRectMake(([ScreenSizeHelper getDisplayViewWidth]-width)/2,
                                                              (SCREEN_HEIGHT-width)/2,
                                                              width,
                                                              width)];
    [self.view addSubview:_cube];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onSyncColor:) name:@"XFSyncColor" object:nil];
    
    _revertPosition = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    _revertPosition.backgroundColor = [UIColor yellowColor];
    [_revertPosition setTitle:@"恢复位置" forState:UIControlStateNormal];
    _revertPosition.titleLabel.font = [UIFont systemFontOfSize:10];
    [_revertPosition setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_revertPosition addTarget:self action:@selector(_revertPosition:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_revertPosition];
    
    _fillTestData = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30 - 3 - 30, 50, 30)];
    _fillTestData.backgroundColor = [UIColor orangeColor];
    _fillTestData.titleLabel.font = [UIFont systemFontOfSize:10];
    [_fillTestData setTitle:@"测试数据" forState:UIControlStateNormal];
    [_fillTestData setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_fillTestData addTarget:self action:@selector(_fillTestData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fillTestData];
    
    _opencvLab = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30, 50, 30)];
    _opencvLab.backgroundColor = [UIColor purpleColor];
    _opencvLab.titleLabel.font = [UIFont systemFontOfSize:10];
    [_opencvLab setTitle:@"42" forState:UIControlStateNormal];
    [_opencvLab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_opencvLab addTarget:self action:@selector(_opencvLab:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_opencvLab];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSyncColor:(NSNotification *)notification{
    NSString *colorString = notification.object;
    [_cube setColorByString:colorString];
}

- (void)_fillTestData:(id)sender{
    [[XFContext context].menu fillTestData];
}

- (void)_revertPosition:(id)sender{
    [_cube restorePosition];
}

- (void)_opencvLab:(id)sender{
    ARPanelViewController *vc = [[ARPanelViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
