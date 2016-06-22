//
//  ViewController.m
//  goodsToBuyCarAnimation
//
//  Created by 毛韶谦 on 16/6/17.
//  Copyright © 2016年 毛韶谦. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()

@property (nonatomic,strong) UIBezierPath *path;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *Button;
@property (strong, nonatomic) UIDynamicAnimator *animator;

@end

@implementation ViewController
{
    CALayer     *_layer;
}
- (UIDynamicAnimator *)animator {
    
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    //添加按钮到BarButton
    _Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_Button setTitle:@"示例" forState:UIControlStateNormal];
    _Button.backgroundColor = [UIColor redColor];
    [_Button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_Button];
    [_Button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.width.equalTo(@84);
        make.height.equalTo(@44);
    }];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.jpeg"]];
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.view.mas_left).offset(30);
        make.top.mas_equalTo(self.view.mas_top).offset(66);
        make.width.equalTo(@77);
        make.height.equalTo(@77);
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)buttonAction:(UIButton *)sender {
    
    [self startAnimationWithRect:self.imageView.frame ImageView:self.imageView];
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
        [self.view.layer addSublayer:_layer];
        self.path = [UIBezierPath bezierPath];
        
         //开始动画的点；
        [_path moveToPoint:self.imageView.center];
        
        [_path addQuadCurveToPoint:_Button.center controlPoint:CGPointMake(SCREEN_WIDTH/2,rect.origin.y-80)];
    }
    [self groupAnimation];
}

-(void)groupAnimation
{
    //防止动作期间多次点击；
    _Button.userInteractionEnabled = NO;
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
       
        _Button.userInteractionEnabled = YES;
    }
}

//变换按钮的位置；
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    // 2 创建物理仿真行为(添加仿真元素)-->吸附行为
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.Button snapToPoint:point];
    
    // 常用属性
    // 防抖系数  0到1  抖动效果逐渐变弱；
    snap.damping = 0.1f;
    // 3 将仿真元素添加到仿真器中
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:snap];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
