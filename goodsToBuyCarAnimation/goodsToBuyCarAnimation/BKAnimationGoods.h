//
//  startAnimal.h
//  goodsToBuyCarAnimation
//
//  Created by 毛韶谦 on 16/7/21.
//  Copyright © 2016年 毛韶谦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BKAnimationGoods : NSObject

/**
 *  调用 产生动画
 *
 *  @param clickButton 点击Button
 *  @param fromPoint   开始的位置
 *  @param toPoint     结束的位置
 *  @param image       之行动画的图片
 */
- (void)startAnimalclickButton:(UIButton *)clickButton fromPoint:(CGPoint )fromPoint toPoint:(CGPoint )toPoint withImage:(UIImage *)image;

/**
 *  当物品放入购物车时装入动画，需先赋值；
 */
@property (nonatomic, strong) UIButton *buyCarButton;

@end
