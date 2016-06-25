//
//  LayerDisplayView.m
//  xfrubiks
//
//  Created by everettjf on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "LayerDisplayView.h"
#import "LayerFaceView.h"
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
#import <xfsolver/xfsolver.h>
#import "ArrowsImage.h"

// UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB

//#define LIGHT_DIRECTION 0, 1, -0.5 
//#define AMBIENT_LIGHT 0.5

@interface LayerDisplayView(){
    CGFloat _baseradx;
    CGFloat _baserady;
    CGFloat _baseradz;
}
@property (strong,nonatomic) UIView *containerView;
@property (strong,nonatomic) NSArray<LayerFaceView*> *faces;
@property (assign,nonatomic) CGFloat sideLength;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIImageView *secondImgView;
@end

@implementation LayerDisplayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _sideLength = 160;
        
        _baseradx = -M_PI_4;
        _baserady = -M_PI_4/3*2;
        _baseradz = 0;
        
        _containerView = [[UIView alloc]init];
        _containerView.bounds = CGRectMake(0, 0, _sideLength, _sideLength);
        _containerView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [self addSubview:_containerView];
        
        _faces = @[
                   [[LayerFaceView alloc]initWithFrame:CGRectMake(0, 0, _sideLength, _sideLength)],
                   [[LayerFaceView alloc]initWithFrame:CGRectMake(0, 0, _sideLength, _sideLength)],
                   [[LayerFaceView alloc]initWithFrame:CGRectMake(0, 0, _sideLength, _sideLength)],
                   [[LayerFaceView alloc]initWithFrame:CGRectMake(0, 0, _sideLength, _sideLength)],
                   [[LayerFaceView alloc]initWithFrame:CGRectMake(0, 0, _sideLength, _sideLength)],
                   [[LayerFaceView alloc]initWithFrame:CGRectMake(0, 0, _sideLength, _sideLength)],
                   ];
        
        [self _setupFaces];
        
        [self _rotateCube:0 rady:0 radz:0];
        
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(_onPanGesture:)];
        [self addGestureRecognizer:gesture];
        
        [_faces[0] setWaitingIndex:0];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addArrow:) name:@"input_arrow" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeArrow) name:@"XFSyncColor" object:nil];


    return self;
}

- (void)addArrow:(NSNotification *)notification{
    NSString *direction = notification.object;
    if ([direction isEqualToString:@"left"]) {
        _arrowImgView = [ArrowsImage getLeftImage];
        _arrowImgView.frame = CGRectMake(30, 30, 100, 100);
        [_containerView addSubview:_arrowImgView];
        CATransform3D transform = CATransform3DMakeTranslation(0, 0, _sideLength/2);
        _arrowImgView.layer.transform = transform;
    }else if([direction isEqualToString:@"right"]){
        _arrowImgView = [ArrowsImage getRightImage];
        _arrowImgView.frame = CGRectMake(30, 30, 100, 100);
        [_containerView addSubview:_arrowImgView];
        CATransform3D transform = CATransform3DMakeTranslation(_sideLength/2, 0, 0);
        transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
        _arrowImgView.layer.transform = transform;
    }else if ([direction isEqualToString:@"upleft"]){
        _arrowImgView = [ArrowsImage getUpImage];
        _arrowImgView.frame = CGRectMake(30, 30, 100, 100);
        [_containerView addSubview:_arrowImgView];
        CATransform3D transform = CATransform3DMakeTranslation(0, _sideLength/2, 0);
        transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
        _arrowImgView.layer.transform = transform;
        
        _secondImgView = [ArrowsImage getLeftImage];
        _secondImgView.frame = CGRectMake(30, 30, 100, 100);
        [_containerView addSubview:_secondImgView];
        CATransform3D transform1 = CATransform3DMakeTranslation(0, 0, _sideLength/2);
        _secondImgView.layer.transform = transform1;
        
    }else if ([direction isEqualToString:@"down"]){
        _arrowImgView = [ArrowsImage getDownImage];
        _arrowImgView.frame = CGRectMake(30, 30, 100, 100);
        [_containerView addSubview:_arrowImgView];
        CATransform3D transform = CATransform3DMakeTranslation(0, 0, _sideLength/2);
        _arrowImgView.layer.transform = transform;
    }else if ([direction isEqualToString:@"up"]){
        _arrowImgView = [ArrowsImage getUpImage];
        _arrowImgView.frame = CGRectMake(30, 30, 100, 100);
        [_containerView addSubview:_arrowImgView];
        CATransform3D transform = CATransform3DMakeTranslation(0, 0, _sideLength/2);
        _arrowImgView.layer.transform = transform;
    }else if ([direction isEqualToString:@"leftright"]){
        _arrowImgView = [ArrowsImage getLeftImage];
        _arrowImgView.frame = CGRectMake(30, 30, 100, 100);
        [_containerView addSubview:_arrowImgView];
        CATransform3D transform = CATransform3DMakeTranslation(-_sideLength/2, 0, 0);
        transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
        _arrowImgView.layer.transform = transform;
    }

}
- (void)removeArrow{
    [_arrowImgView removeFromSuperview];
    [_secondImgView removeFromSuperview];
}
- (void)_onPanGesture:(UIPanGestureRecognizer*)gesture{
    static CGPoint start;
    if(gesture.state == UIGestureRecognizerStateBegan){
        start = [gesture locationInView:self];
    }else{
        CGPoint loc = [gesture locationInView:self];
        CGPoint diff = CGPointMake(start.x-loc.x, start.y-loc.y);
        
        CGFloat diffx = diff.x;
        CGFloat diffy = diff.y;
        CGFloat diffz = sqrt(diff.x*diff.x + diff.y*diff.y) * diffx/fabs(diffx);
        
        CGFloat radx = diffx/180.0;
        CGFloat rady = diffy/180.0;
        CGFloat radz = diffz/180.0;
        
        [self _rotateCube:radx rady:rady radz:radz];
        
        start = loc;
    }
}

- (void)_rotateCube:(CGFloat)radx rady:(CGFloat)rady radz:(CGFloat)radz{
    _baseradx += rady;
    _baserady -= radx;
    _baseradz -= radz;
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    perspective = CATransform3DRotate(perspective, _baseradx , 1, 0, 0);
    perspective = CATransform3DRotate(perspective, _baserady , 0, 1, 0);
    perspective = CATransform3DRotate(perspective, _baseradz , 0, 0, 1);
    self.containerView.layer.sublayerTransform = perspective;
}

- (void)_setupFaces{
    CATransform3D transform;
    //add cube face 0 - U - Upper
    transform = CATransform3DMakeTranslation(0, -_sideLength/2, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:0 withTransform:transform];
    //add cube face 1 - R - Right
    transform = CATransform3DMakeTranslation(_sideLength/2, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    //add cube face 2 - F - Front
    transform = CATransform3DMakeTranslation(0, 0, _sideLength/2);
    [self addFace:2 withTransform:transform];
    //add cube face 3 - D - Down
    transform = CATransform3DMakeTranslation(0, _sideLength/2, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    //add cube face 4 - L - Left
    transform = CATransform3DMakeTranslation(-_sideLength/2, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    //add cube face 5 - B - Back
    transform = CATransform3DMakeTranslation(0, 0, -_sideLength/2);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
    
    // Config
    [self _configFaces];
}


//- (void)applyLightingToFace:(CALayer *)face
//{
//    //add lighting layer
//    CALayer *layer = [CALayer layer];
//    layer.frame = face.bounds;
//    [face addSublayer:layer];
//    //convert the face transform to matrix
//    //(GLKMatrix4 has the same structure as CATransform3D)
//    CATransform3D transform = face.transform;
//    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
//    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
//    //get face normal
//    GLKVector3 normal = GLKVector3Make(0, 0, 1);
//    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
//    normal = GLKVector3Normalize(normal);
//    //get dot product with light direction
//    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
//    float dotProduct = GLKVector3DotProduct(light, normal);
//    //set lighting layer opacity
//    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
//    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
//    layer.backgroundColor = color.CGColor;
//}

- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform {
    UIView *face = _faces[index];
    face.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.0];
    [_containerView addSubview:face];
    face.layer.transform = transform;
    
//    [self applyLightingToFace:face.layer];
}

- (void)_configFaces{
    [_faces enumerateObjectsUsingBlock:^(LayerFaceView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self _configFace:obj idx:idx];
    }];
}

- (void)_configFace:(LayerFaceView*)face idx:(NSUInteger)idx{
    
    [face setText:[RubiksConvertor translateFaceIndexToZhcnString:idx]];
}

- (void)setColorByString:(NSString *)zhcnString{
    NSLog(@"zhcn String : %@", zhcnString);
    
    // clear
    for (LayerFaceView *face in _faces) {
        for(NSUInteger idx = 0; idx < 9; ++idx){
            [face setColor:nil index:idx];
        }
        [face removeWaiting];
    }
    
    if(zhcnString.length == 0){
        [_faces[0] setWaitingIndex:0];
        return;
    }
    
    NSString *normalString = [RubiksConvertor convertColorToHanZi:zhcnString];
    
    NSLog(@">>>>>>>>>>normal String : %@", normalString);
    
    NSUInteger idx;
    for(idx = 0; idx < normalString.length && idx < 54; ++idx){
        NSString *colorItem = [normalString substringWithRange:NSMakeRange(idx, 1)];
        NSLog(@"color item = %@",colorItem);
        
        NSUInteger faceIndex = idx/9;
        NSUInteger boxIndex = idx%9;
        
        UIColor *color = [RubiksConvertor colorFromZhcnString:colorItem];
        [_faces[faceIndex] setColor:color index:boxIndex];
        [_faces[faceIndex] removeWaiting];
    }
    
    // next
    NSUInteger faceIndex = idx/9;
    NSUInteger boxIndex = idx%9;
    if(faceIndex<=5 && boxIndex<=8){
        [_faces[faceIndex] setWaitingIndex:boxIndex];
    }
}

- (void)restorePosition{
    _baseradx = -M_PI_4;
    _baserady = -M_PI_4/3*2;
    _baseradz = 0;
    
    [self _rotateCube:0 rady:0 radz:0];
}

@end
