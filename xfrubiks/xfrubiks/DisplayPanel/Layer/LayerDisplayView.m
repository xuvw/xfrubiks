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

// UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB

//#define LIGHT_DIRECTION 0, 1, -0.5 
//#define AMBIENT_LIGHT 0.5

@interface LayerDisplayView()
@property (strong,nonatomic) UIView *containerView;
@property (strong,nonatomic) NSArray<LayerFaceView*> *faces;
@property (assign,nonatomic) CGFloat sideLength;
@end

@implementation LayerDisplayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _sideLength = 160;
        
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
        
        //set up the container sublayer transform
        CATransform3D perspective = CATransform3DIdentity;
        perspective.m34 = -1.0 / 500.0;
        perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
        perspective = CATransform3DRotate(perspective, -M_PI_4/3*2, 0, 1, 0);
        self.containerView.layer.sublayerTransform = perspective;
    }
    return self;
}

- (void)_setupFaces{
    //add cube face 1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, _sideLength/2);
    [self addFace:0 withTransform:transform];
    //add cube face 2
    transform = CATransform3DMakeTranslation(_sideLength/2, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    //add cube face 3
    transform = CATransform3DMakeTranslation(0, -_sideLength/2, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    //add cube face 4
    transform = CATransform3DMakeTranslation(0, _sideLength/2, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    
    //add cube face 5
    transform = CATransform3DMakeTranslation(-_sideLength/2, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    //add cube face 6
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
    
    [face setText:[NSString stringWithFormat:@"%@",@(idx)]];
}

- (void)setColorByString:(NSString *)zhcnString{
    NSString *normalString = [RubiksConvertor convertColorToHanZi:zhcnString];
    
    for(NSUInteger idx = 0; idx < normalString.length; ++idx){
        NSString *colorItem = [normalString substringWithRange:NSMakeRange(idx, 1)];
        NSLog(@"color item = %@",colorItem);
        
        NSUInteger faceIndex = idx/9;
        NSUInteger boxIndex = idx%9;
        
        UIColor *color = [RubiksConvertor colorFromZhcnString:colorItem];
        [_faces[faceIndex] setColor:color index:boxIndex];
    }
}


@end
