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
#import "XFContext.h"
#import "GuidePanelViewController.h"

#define MenueViewWith [ScreenSizeHelper getMenuViewWidth]
#define DisViewWith [ScreenSizeHelper getDisplayViewWidth]

@interface ViewController ()
@property (strong,nonatomic) DisplayViewController *displayController;
@property (strong,nonatomic) MenuViewController *menuController;
@property (strong,nonatomic) GuidePanelViewController *guideController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _displayController = [[DisplayViewController alloc]init];
    [XFContext context].display = _displayController;
    
    _displayController.view.frame = CGRectMake(0, 0, DisViewWith, SCREEN_HEIGHT);
    [self addChildViewController:_displayController];
    [self.view addSubview:_displayController.view];
    [_displayController didMoveToParentViewController:self];
    
    
    _menuController = [[MenuViewController alloc]init];
    [XFContext context].menu = _menuController;
    
    _menuController.view.frame = CGRectMake(DisViewWith, 0, MenueViewWith, SCREEN_HEIGHT);
    [self addChildViewController:_menuController];
    [self.view addSubview:_menuController.view];
    [_menuController didMoveToParentViewController:self];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [XFContext context].main = self;
    
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showGuide:(NSString*)solution{
    _guideController = [[GuidePanelViewController alloc]init];
    _guideController.view.frame = CGRectMake(DisViewWith, 0, MenueViewWith, SCREEN_HEIGHT);
    [self addChildViewController:_guideController];
    [self.view addSubview:_guideController.view];
    [_guideController didMoveToParentViewController:self];
    
    _guideController.solution = solution;
}

@end
