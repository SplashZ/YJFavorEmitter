//
//  YJFavorEmitterCell.m
//  YJFavorEmitter
//
//  Created by splashz on 15/11/2.
//  Copyright © 2015年 splashz. All rights reserved.
//

#import "YJFavorEmitterCell.h"

//Animation Name
#define kShiftingAnimation @"YJEmitterCellShftingAnimation"
#define kRisingAnimation @"YJEmitterCellRisingAnimation"
#define kInflatingAnimation @"YJEmitterCellInflatingAnimation"
#define kFadeOutAnimation @"YJEmitterCellFadeOutAnimation"

@interface YJFavorEmitterCell() <CAAnimationDelegate>

@property (nonatomic, assign) CGRect floatArea;

@end

@implementation YJFavorEmitterCell

static const float inflatingDuration = 0.5;

+ (instancetype)emitterCellWithFrame:(CGRect)frame
                           floatArea:(CGRect)floatArea
                               image:(UIImage *)image
{
    YJFavorEmitterCell *emitterCell = [[YJFavorEmitterCell alloc] initWithFrame:frame];
    emitterCell.floatArea = floatArea;
    emitterCell.contents = (__bridge id)image.CGImage;
    return emitterCell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super init]) {
        self.frame = frame;
        self.transform = CATransform3DMakeScale(0.2, 0.2, 1.0);
    }
    return self;
}

- (void)startAnimation
{
    [self groupAnimationForInflatingAndShifting];
}

#pragma mark - Animations
- (void)groupAnimationForInflatingAndShifting
{
    double beginTime = CACurrentMediaTime();
    [self inflatingWithBeginTime:beginTime duration:inflatingDuration];
    
    CGFloat risingDuration;
    CGFloat fadeOutDuration;
    [self adaptDurationWithRisingDuration:&risingDuration
                          fadeOutDuration:&fadeOutDuration];
    
    [self animationForRisingWithDuration:risingDuration];
    
    [self fadeoutWithBeginTime:beginTime + inflatingDuration
                      duration:fadeOutDuration];
    
    [self animationForShiftingWithBeginTime:beginTime + inflatingDuration duration:_shiftCycle
                                    offset:[self randomOfShift:CGRectGetWidth(_floatArea) * 0.5]];
}

- (void)inflatingWithBeginTime:(NSTimeInterval)beginTime duration:(NSTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.beginTime = beginTime;
    animation.duration = duration;
    animation.fromValue = @0.2;
    animation.toValue = @1;
    animation.fillMode = kCAFillModeBoth;
    self.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
    
    [self addAnimation:animation forKey:kInflatingAnimation];
}

- (void)animationForShiftingWithBeginTime:(NSTimeInterval)beginTime
                                 duration:(NSTimeInterval)duration
                                   offset:(float)offset
{
    float centerX = self.position.x;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    animation.duration = duration;
    animation.beginTime = beginTime;
    if (arc4random_uniform(3) > 1) {
        animation.values = @[@(centerX), @(centerX-offset), @(centerX), @(centerX+offset), @(centerX)];
    } else {
        animation.values = @[@(centerX), @(centerX+offset), @(centerX), @(centerX-offset), @(centerX)];
    }
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    
    [self addAnimation:animation forKey:kShiftingAnimation];
}

- (void)animationForRisingWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.toValue = [NSNumber numberWithFloat:CGRectGetMinY(_floatArea) + CGRectGetHeight(self.frame) * 0.5];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self addAnimation:animation forKey:kRisingAnimation];
}

- (void)fadeoutWithBeginTime:(NSTimeInterval)beginTime duration:(NSTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.beginTime = beginTime;
    animation.duration = duration;
    animation.fromValue = @(self.opacity);
    animation.toValue = @0;
    animation.fillMode = kCAFillModeBackwards;
    animation.delegate = self;
    
    [self addAnimation:animation forKey:kFadeOutAnimation];
    self.opacity = 0;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([self animationForKey:kFadeOutAnimation] == anim) {
        [self removeFromSuperlayer];
    }
}

#pragma mark - data hepler
//result = center +/- gap
- (float)randomOfCenterNumber:(float)center forShift:(float)shift
{
    return center - shift + arc4random_uniform(shift * 2 + 1);
}

- (float)randomOfShift:(float)shift
{
    return (float)arc4random_uniform(shift + 1);
}

- (void)adaptDurationWithRisingDuration:(CGFloat *)risingDuration
                        fadeOutDuration:(CGFloat *)fadeOutDuration
{
    CGFloat risingDistance = self.position.y - CGRectGetMinY(_floatArea);
    
    CGFloat randRisingDuration = [self randomOfCenterNumber:_risingDuration
                                               forShift:_risingShiftDuration];
    
    if (risingDistance / randRisingDuration < _minRisingVelocity) {
        *risingDuration = risingDistance / _minRisingVelocity;
        //确保元素到达顶端时完全消失
        CGFloat fadeDuration = _fadeOutDuration > *risingDuration - _fadeOutShiftDuration - inflatingDuration ? *risingDuration - _fadeOutShiftDuration - inflatingDuration: _fadeOutDuration;
        *fadeOutDuration = [self randomOfCenterNumber:fadeDuration forShift:_fadeOutShiftDuration];
    } else {
        *risingDuration = randRisingDuration;
        CGFloat fadeDuration = _fadeOutDuration > *risingDuration - _fadeOutShiftDuration - inflatingDuration ? *risingDuration - _fadeOutShiftDuration - inflatingDuration: _fadeOutDuration;
        *fadeOutDuration = [self randomOfCenterNumber:fadeDuration forShift:_fadeOutShiftDuration];
    }
}

@end
