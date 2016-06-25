//
//  ViewController.m
//  xfrubiks
//
//  Created by everettjf on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "ViewController.h"
#import "DisplayViewController.h"
#import "MenuViewController.h"

@interface ViewController ()
@property (strong,nonatomic) DisplayViewController *displayController;
@property (strong,nonatomic) MenuViewController *menuController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _displayController = [[DisplayViewController alloc]init];
    [self addChildViewController:_displayController];
    [self.view addSubview:_displayController.view];
    
    _menuController = [[MenuViewController alloc]init];
    [self addChildViewController:_menuController];
    [self.view addSubview:_menuController.view];
    
    _displayController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT);
    _menuController.view.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
