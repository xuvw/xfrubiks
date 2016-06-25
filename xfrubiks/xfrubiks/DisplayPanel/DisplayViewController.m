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
//    self.view.backgroundColor = [UIColor greenColor];
    
    NSLog(@"display size = %@", [NSValue valueWithCGSize:self.view.bounds.size]);
    NSLog(@"screen size = %@", [NSValue valueWithCGSize:[UIScreen mainScreen].bounds.size]);
    
    CGFloat width = SCREEN_WIDTH/2-10;
    _cube = [[LayerDisplayView alloc]init];
    _cube.bounds = CGRectMake(0, 0, width, width);
    _cube.center = CGPointMake(SCREEN_WIDTH/2/2, SCREEN_HEIGHT/2);
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
