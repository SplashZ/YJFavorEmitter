//
//  YJFavorEmitter.h
//  ParticleEmitterTest
//
//  Created by splashz on 15/11/2.
//  Copyright © 2015年 splashz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJFavorEmitterCell;

typedef BOOL (^EmitterTapHandler) (void);

@interface YJFavorEmitter : UIView

///粒子发射器点击时的默认操作
@property (copy, nonatomic) EmitterTapHandler tapHandler;

///是否响应点击事件，默认为YES
@property (nonatomic, assign) BOOL interactEnabled;

#pragma mark - cell property

///元素图片
@property (nonatomic, strong) NSArray<UIImage *> *cellImages;

///出生点位，在粒子发射器中点和顶点之间为0~1的小数，1为顶点，0为中点
@property (nonatomic, assign) CGFloat originRange;

///元素大小为0.2~1.5之间的数，默认为1
@property (nonatomic, assign) CGFloat scale;

///元素左右移动的追加范围为10~20之间的数，默认为10
@property (nonatomic, assign) CGFloat extraShift;

///元素上升的最小速度为5~15之间的数，默认为5
@property (nonatomic, assign) CGFloat risingVelocity;

///左右飘动的周期
@property (nonatomic, assign) CGFloat shiftCycle;

///到达顶部的时间
@property (nonatomic, assign) CGFloat risingDuration;

///到达顶部的时间差量
@property (nonatomic, assign) CGFloat risingShiftDuration;

///完全消失的时间
@property (nonatomic, assign) CGFloat fadeOutDuration;

///完全消失的时间差量
@property (nonatomic, assign) CGFloat fadeOutShiftDuration;

/**
 初始化粒子发射器

 @param frame           粒子发射器在parentView中的frame
 @param parentView      父容器
 @param image           粒子发射器的图片
 @param hightlightImage 粒子发射器的高亮图片

 @return 粒子发射器
 */
+ (instancetype)emitterWithFrame:(CGRect)frame
                      parentView:(UIView *)parentView
                           image:(UIImage *)image
                  highlightImage:(UIImage *)hightlightImage;

/**
 释放元素

 @param count 元素数量
 */
- (void)generateEmitterCellsForCellsCount:(int)count;

@end
