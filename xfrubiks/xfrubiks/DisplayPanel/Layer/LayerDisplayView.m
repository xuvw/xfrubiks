//
//  LayerDisplayView.m
//  xfrubiks
//
//  Created by everettjf on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "LayerDisplayView.h"
#import "LayerFaceView.h"

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
                   [LayerFaceView new],
                   [LayerFaceView new],
                   [LayerFaceView new],
                   [LayerFaceView new],
                   [LayerFaceView new],
                   [LayerFaceView new],
                   ];
        
        [self _setupFaces];
        
        //set up the container sublayer transform
        CATransform3D perspective = CATransform3DIdentity;
        perspective.m34 = -1.0 / 500.0;
        perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
        perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
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

- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform {
    UIView *face = _faces[index];
    [_containerView addSubview:face];
    
    CGSize containerSize = _containerView.bounds.size;
    face.center = CGPointMake(containerSize.width / 2.0,
                              containerSize.height / 2.0);
    face.bounds = CGRectMake(0, 0, _sideLength, _sideLength);

    face.layer.transform = transform;
}

- (void)_configFaces{
    
    [_faces enumerateObjectsUsingBlock:^(LayerFaceView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self _configFace:obj idx:idx];
    }];
}

- (void)_configFace:(LayerFaceView*)face idx:(NSUInteger)idx{
    
    face.backgroundColor = [UIColor whiteColor];
//    face.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0f];
    face.tagText = [NSString stringWithFormat:@"%@",@(idx)];
}



@end
