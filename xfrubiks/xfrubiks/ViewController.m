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
#import "ScreenSizeHelper.h"

#define MenueViewWith [ScreenSizeHelper getMenuViewWidth]
#define DisViewWith [ScreenSizeHelper getDisplayViewWidth]

@interface ViewController ()
@property (strong,nonatomic) DisplayViewController *displayController;
@property (strong,nonatomic) MenuViewController *menuController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _displayController = [[DisplayViewController alloc]init];
    _displayController.view.frame = CGRectMake(0, 0, DisViewWith, SCREEN_HEIGHT);
    [self addChildViewController:_displayController];
    [self.view addSubview:_displayController.view];
    [_displayController didMoveToParentViewController:self];
    
    
    _menuController = [[MenuViewController alloc]init];
    _menuController.view.frame = CGRectMake(DisViewWith, 0, MenueViewWith, SCREEN_HEIGHT);
    [self addChildViewController:_menuController];
    [self.view addSubview:_menuController.view];
    [_menuController didMoveToParentViewController:self];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
