//
//  YJFavorEmitterCell.m
//  YJFavorEmitter
//
//  Created by splashz on 10/24/2016.
//  Copyright (c) 2016 splashz. All rights reserved.
//

#import "YJFavorEmitterCell.h"

//Animation Name
#define kSwayAnimation @"YKLSEmitterCellSwayAnimation"
#define kMoveUpAnimation @"YKLSEmitterCellMoveUpAnimation"
#define kSwellUpAnimation @"YKLSEmitterCellSwellUpAnimation"
#define kFadeOutAnimation @"YKLSEmitterCellFadeOutAnimation"

//const parameter
#define kRiseOffset            10.f
#define kSwayOffset            30.f
#define kGroupDuration         0.4
#define kSwayDuration          5
#define kMoveUpDuration        10.0
#define kMoveUpDurationOffset  2
#define kFadeOutDuration       6.0
#define kFadeOutDurationOffset 2

@implementation YJFavorEmitterCell

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString*)imageName terminationY:(float)terminationY
{
    if (self = [super init]) {
        self.frame = frame;
        self.terminationY = terminationY;
        self.contents = (__bridge id)[UIImage imageNamed:imageName].CGImage;
        self.transform = CATransform3DMakeScale(0.2, 0.2, 1.0);
    }
    return self;
}

- (void)startAnimation
{
    [self groupAnimationForSwellUPAndTranslate];
}

#pragma mark -- Animations
- (void)groupAnimationForSwellUPAndTranslate
{
    [self animationForSwayWithDuration:kSwayDuration shift:[self randomForGap:kSwayOffset]];

    double beginTime = CACurrentMediaTime();
    [self swellupWithBeginTime:beginTime duration:0.5];
    [self fadeoutWithBeginTime:beginTime+0.5 duration:[self randomForCenterNumber:kFadeOutDuration onGap:kFadeOutDurationOffset]];
    
    [self animationForMoveUpWithDuration:[self randomForCenterNumber:kMoveUpDuration
                                                               onGap:kMoveUpDurationOffset]];
}

- (void)swellupWithBeginTime:(NSTimeInterval)beginTime duration:(NSTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.beginTime = beginTime;
    animation.duration = duration;
    animation.fromValue = @0.2;
    animation.toValue = @1;
    animation.fillMode = kCAFillModeBoth;
    self.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
    
    [self addAnimation:animation forKey:kSwellUpAnimation];
}

- (void)animationForSwayWithDuration:(NSTimeInterval)duration shift:(float)shift
{
    float centerX = self.position.x;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    animation.duration = duration;
    if (arc4random_uniform(3) > 1) {
        animation.values = @[@(centerX), @(centerX-shift+5), @(centerX), @(centerX+shift), @(centerX)];
    } else {
        animation.values = @[@(centerX), @(centerX+shift), @(centerX), @(centerX-shift+5), @(centerX)];
    }
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    
    [self addAnimation:animation forKey:kSwayAnimation];
}

- (void)animationForMoveUpWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.toValue = [NSNumber numberWithFloat:_terminationY];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self addAnimation:animation forKey:kMoveUpAnimation];
}

- (void)fadeoutWithBeginTime:(NSTimeInterval)beginTime duration:(NSTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.beginTime = beginTime;
    animation.duration = duration;
    animation.fromValue = @(self.opacity);
    animation.toValue = @0;
    animation.fillMode = kCAFillModeBackwards;
    
    [self addAnimation:animation forKey:kFadeOutAnimation];
    self.opacity = 0;
}


#pragma mark -- DataHelper
//result = center +/- gap
- (float)randomForCenterNumber:(float)center onGap:(float)gap
{
    return center - gap + (float)arc4random_uniform(gap * 10 * 2 + 1) / 10;
}

- (float)randomForGap:(float)gap
{
    return (float)arc4random_uniform(gap * 10 + 1) / 10;
}

@end
