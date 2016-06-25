//
//  DisplayViewController.m
//  xfrubiks
//
//  Created by everettjf on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "DisplayViewController.h"
#import "LayerDisplayView.h"

@interface DisplayViewController ()
@property (strong, nonatomic) LayerDisplayView *cube;

@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    NSLog(@"display size = %@", [NSValue valueWithCGSize:self.view.bounds.size]);
    NSLog(@"screen size = %@", [NSValue valueWithCGSize:[UIScreen mainScreen].bounds.size]);
    
    CGFloat width = 250;
    _cube = [[LayerDisplayView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2-width)/2,
                                                              (SCREEN_HEIGHT-width)/2,
                                                              width,
                                                              width)];
    [self.view addSubview:_cube];
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
