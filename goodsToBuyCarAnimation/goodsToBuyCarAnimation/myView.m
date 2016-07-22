//
//  myView.m
//  goodsToBuyCarAnimation
//
//  Created by 毛韶谦 on 16/7/21.
//  Copyright © 2016年 毛韶谦. All rights reserved.
//

#import "myView.h"

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface myView ()

@property (nonatomic,strong) UIBezierPath *path;
//@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *Button;
@property (nonatomic,strong) UIButton *clickButton;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIView *transView;

@end

@implementation myView

{
    CALayer     *_layer;
}

- (UIDynamicAnimator *)animator {
    
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.transView];
    }
    return _animator;
}

- (void)startAnimal:(UIView *)view clickButton:(UIButton *)clickButton toButton:(UIButton *)toButton withImageView:(UIImageView *)imageView{
    self.transView = view;
    self.Button = toButton;
    self.clickButton = clickButton;
    [self startAnimationWithRect:clickButton.frame ImageView:imageView];
}

-(void)startAnimationWithRect:(CGRect)rect ImageView:(UIImageView *)imageView
{
    if (!_layer) {
        _layer = [CALayer layer];
        _layer.contents = (id)imageView.layer.contents;
        _layer.contentsGravity = kCAGravityResizeAspectFill;
        _layer.bounds = rect;
        [_layer setCornerRadius:CGRectGetHeight([_layer bounds]) / 2];
        _layer.masksToBounds = YES;
        // 导航64
        _layer.position = CGPointMake(imageView.center.x, CGRectGetMidY(rect)+64);
        [self.transView.layer addSublayer:_layer];
        self.path = [UIBezierPath bezierPath];
        
        //开始动画的点；
        [_path moveToPoint:imageView.center];
        
        [_path addQuadCurveToPoint:_Button.center controlPoint:CGPointMake(SCREEN_WIDTH/2,rect.origin.y-80)];
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
    
    
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.3f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.3;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    narrowAnimation.duration = 1.0f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.3f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
