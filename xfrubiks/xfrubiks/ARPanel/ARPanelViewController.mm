//
//  ARPanelViewController.m
//  xfrubiks
//
//  Created by everettjf on 16/6/26.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "ARPanelViewController.h"
#import "RubikVideoCamera.h"
#import "Processor.h"

@interface ARPanelViewController ()<CvVideoCameraDelegate>
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) RubikVideoCamera* videoCamera;

@end

@implementation ARPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize imageSize;
    CGSize size = CGSizeMake(640, 480);
    float x = size.width / size.height;
    float y = self.view.bounds.size.width / self.view.bounds.size.height;
    if(x > y){
        imageSize = CGSizeMake(x * self.view.bounds.size.width, 1 * self.view.bounds.size.height);
    }else{
        imageSize = CGSizeMake(1 * self.view.bounds.size.width, y * self.view.bounds.size.height);
    }
    NSLog(@"image size = %@",[NSValue valueWithCGSize:imageSize]);
    
    _imageView = [[UIImageView alloc]init];
    _imageView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    _imageView.bounds = CGRectMake(0, 0, ceil(imageSize.width), ceil(imageSize.height));
    [self.view addSubview:_imageView];
    
    self.videoCamera = [[RubikVideoCamera alloc] initWithParentView:_imageView];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.rotateVideo = NO;
    
    self.videoCamera.delegate = self;
    
    [self.videoCamera start];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwipe:)];
    [self.view addGestureRecognizer:swipe];
}

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(cv::Mat&)image;
{
    Processor::processImage(image);
}
#endif

- (void)onSwipe:(UISwipeGestureRecognizer*)gesture{
    if(gesture.direction  == UISwipeGestureRecognizerDirectionRight){
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

@end
