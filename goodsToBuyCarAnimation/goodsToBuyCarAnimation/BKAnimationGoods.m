//
//  BKAnimationGoods.m
//  BESTKEEP
//
//  Created by 毛韶谦 on 16/7/21.
//  Copyright © 2016年 YISHANG. All rights reserved.
//

#import "BKAnimationGoods.h"

@interface BKAnimationGoods ()

@property (nonatomic,strong) UIBezierPath *path;
@property (nonatomic,strong) UIButton *clickButton;
@property (strong, nonatomic) UIView *transView;
@property (assign, nonatomic) CGPoint fromPoint;
@property (assign, nonatomic) CGPoint toPoint;

@end

@implementation BKAnimationGoods

{
    CALayer     *_layer;
}

- (void)startAnimalclickButton:(UIButton *)clickButton fromPoint:(CGPoint )fromPoint toPoint:(CGPoint )toPoint withImage:(UIImage *)image{
    self.transView = [self lastWindow];
    self.clickButton = clickButton;
    self.fromPoint = fromPoint;
    self.toPoint = toPoint;
    CGRect frame = clickButton.frame;
    frame.size.height = 50;
    frame.size.width = 50;
    [self startAnimationWithRect:frame ImageView:[[UIImageView alloc] initWithImage:image]];
}

-(void)startAnimationWithRect:(CGRect)rect ImageView:(UIImageView *)imageView
{
    if (!_layer) {
        _layer = [CALayer layer];
        _layer.contents = (id)imageView.layer.contents;
        _layer.contentsGravity = kCAGravityResizeAspectFill;
        _layer.bounds = rect;
        //        [_layer setCornerRadius:CGRectGetHeight([_layer bounds]) / 2];
        //        _layer.masksToBounds = YES;
        // 导航64
//        _layer.position = CGPointMake(100, CGRectGetMidY(rect)+64);
        [self.transView.layer addSublayer:_layer];
        self.path = [UIBezierPath bezierPath];
        
        //开始动画的点；
        [_path moveToPoint:self.fromPoint];
        [_path addQuadCurveToPoint:self.toPoint controlPoint:CGPointMake(self.fromPoint.x,self.toPoint.y)];
    }
    [self groupAnimation];
}

-(void)groupAnimation
{
    //防止动作期间多次点击；
    _clickButton.userInteractionEnabled = NO;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    //旋转动画
    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 10];
    rotationAnimation.duration = 1.3f;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.3f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.3;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    narrowAnimation.duration = 1.0f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.3f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation,rotationAnimation];
    groups.duration = 1.3f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [_layer addAnimation:groups forKey:@"group"];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [_layer animationForKey:@"group"]) {
        [_layer removeFromSuperlayer];
        _layer = nil;
        
        _clickButton.userInteractionEnabled = YES;
    }
}
#pragma mark-获取全屏最上层的Window
- (UIWindow *)lastWindow{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}


@end
