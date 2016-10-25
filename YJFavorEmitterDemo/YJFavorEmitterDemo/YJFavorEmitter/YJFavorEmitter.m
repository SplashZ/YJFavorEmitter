//
//  YJFavorEmitter.m
//  ParticleEmitterTest
//
//  Created by splashz on 15/11/2.
//  Copyright © 2015年 splashz. All rights reserved.
//

#import "YJFavorEmitter.h"
#import "YJFavorEmitterCell.h"

#define kSwayExtraOffset 10.f

@interface YJFavorEmitter ()
@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, weak) UIButton *btn;
@end

@implementation YJFavorEmitter

#pragma mark - init

+ (instancetype)emitterWithFrame:(CGRect)frame
                      parentView:(UIView *)parentView
                           image:(UIImage *)image
                  highlightImage:(UIImage *)hightlightImage
{
    CGRect validFrame = (CGRect){frame.origin, (CGSize){MIN(100, frame.size.width), MIN(100, frame.size.height)}};
    YJFavorEmitter *emitter = [[YJFavorEmitter alloc] initWithFrame:validFrame];
    emitter.parentView = parentView;
    [emitter assignDefaultValue];
    [emitter assignSubviews];
    [emitter setAppearanceWithImage:image highlightedImage:hightlightImage];
    return emitter;
}

- (void)assignDefaultValue
{
    _interactEnabled = YES;
    
    _originRange = 1;
    _scale = 1;
    _extraShift = 10;
    _shiftCycle = 5;
    _risingDuration = 10;
    _risingShiftDuration = 2;
    _fadeOutDuration = 6;
    _fadeOutShiftDuration = 2;
}

- (void)assignSubviews
{
    UIButton *btn = [[UIButton alloc] initWithFrame:self.bounds];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    _btn = btn;
}

- (void)setAppearanceWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    [_btn setImage:image forState:UIControlStateNormal];
    [_btn setImage:highlightedImage forState:UIControlStateHighlighted];
}

#pragma mark - cell generate

- (void)generateEmitterCell
{
    if (_cellImages.count < 1 || !_parentView) {
        return;
    }
    int randomIndex = arc4random_uniform((int)_cellImages.count);
    
    CGRect frame = [self.superview convertRect:self.frame toView:_parentView];
    YJFavorEmitterCell *cell = [YJFavorEmitterCell emitterCellWithFrame:CGRectMake(0,
                                                                                   frame.origin.y - frame.size.height * _scale * 0.5 * _originRange,
                                                                                   frame.size.width * _scale,
                                                                                   frame.size.height * _scale)
                                                              floatArea:CGRectMake(CGRectGetMidX(frame) - CGRectGetWidth(frame) * 0.5 - _extraShift,
                                                                                   _parentView.frame.origin.y,
                                                                                   frame.size.width + 2 * _extraShift,
                                                                                   _parentView.frame.size.height - frame.size.height)
                                                                   image:_cellImages[randomIndex]];
                                
    cell.position = CGPointMake(CGRectGetMidX(frame), cell.position.y);
    [_parentView.layer addSublayer:cell];
    
    [self assignForEmitterCell:cell];
    
    [cell startAnimation];
}

- (void)generateEmitterCellsForCellsCount:(int)count
{
    for (int i = 0; i < count; i++) {
        [self generateEmitterCell];
    }
}

- (void)btnClicked:(UIButton*)btn
{
    if (!_tapHandler) {
        [self generateEmitterCell];
    }
    
    BOOL generation = _tapHandler();
    if (generation) {
        [self generateEmitterCell];
    }
}

- (void)assignForEmitterCell:(YJFavorEmitterCell *)cell
{
    cell.shiftCycle = _shiftCycle;
    cell.risingDuration = _risingDuration;
    cell.risingShiftDuration = _risingShiftDuration;
    cell.fadeOutDuration = _fadeOutDuration;
    cell.fadeOutShiftDuration = _fadeOutShiftDuration;
}

#pragma mark - setter

- (void)setScale:(CGFloat)scale
{
    _scale = MIN(MAX(scale, 1.5), 0.2);
}

- (void)setInteractEnabled:(BOOL)interactEnabled
{
    if (_interactEnabled == interactEnabled) {
        return;
    }
    
    _interactEnabled = interactEnabled;
    _btn.enabled = _interactEnabled;
}

- (void)setExtraShift:(CGFloat)extraShift
{
    _extraShift = MIN(MAX(extraShift, 20), 10);
}

- (void)setRisingVelocity:(CGFloat)risingVelocity
{
    _risingVelocity = MIN(MAX(risingVelocity, 15), 5);
}

- (void)setShiftCycle:(CGFloat)shiftCycle
{
    _shiftCycle = MIN(MAX(shiftCycle, 8), 1);
}

- (void)setRisingDuration:(CGFloat)risingDuration
{
    _risingDuration = MIN(MAX(risingDuration, 12), 5);
}

- (void)setRisingShiftDuration:(CGFloat)risingShiftDuration
{
    _risingShiftDuration = MIN(MAX(risingShiftDuration, 4), 1);
}

- (void)setFadeOutDuration:(CGFloat)fadeOutDuration
{
    _fadeOutDuration = MIN(MAX(fadeOutDuration, 10), 3);
}

- (void)setFadeOutShiftDuration:(CGFloat)fadeOutShiftDuration
{
    _fadeOutShiftDuration = MIN(MAX(fadeOutShiftDuration, 3), 1);
}

- (void)setOriginRange:(CGFloat)originRange
{
    _originRange = MIN(MAX(originRange, 1), 0);
}

@end
