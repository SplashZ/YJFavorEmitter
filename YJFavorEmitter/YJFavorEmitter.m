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
@property (nonatomic, weak) UIView *favorDisplayView;
@property (nonatomic, weak) UIButton *btn;
@property (nonatomic, assign) BOOL risingYUpdate;

@property (nonatomic, assign) CGRect cellFrames;
@property (nonatomic, assign) CGRect floatArea;

@end

@implementation YJFavorEmitter

#pragma mark - init

+ (instancetype)emitterWithFrame:(CGRect)frame
                favorDisplayView:(UIView *)favorDisplayView
                           image:(UIImage *)image
                  highlightImage:(UIImage *)hightlightImage
{
    CGRect validFrame = (CGRect){frame.origin, (CGSize){MIN(100, frame.size.width), MIN(100, frame.size.height)}};
    YJFavorEmitter *emitter = [[YJFavorEmitter alloc] initWithFrame:validFrame];
    emitter.favorDisplayView = favorDisplayView;
    [emitter assignDefaultValue];
    [emitter assignSubviews];
    [emitter setAppearanceWithImage:image highlightedImage:hightlightImage];
    return emitter;
}

- (void)assignDefaultValue
{
    _interactEnabled = YES;
    _movable = NO;
    
    _cellFrames = CGRectZero;
    _floatArea = CGRectZero;
    
    _originRange = 1;
    _scale = 1;
    _risingY = 0;
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
    if (_cellImages.count < 1 || !_favorDisplayView) {
        return;
    }
    int randomIndex = arc4random_uniform((int)_cellImages.count);
    
    if (_risingYUpdate) {
        CGRect frame = [self.superview convertRect:self.frame toView:_favorDisplayView];
        [self updateFloatAreaWithFrame:frame];
        _risingYUpdate = NO;
    }
    
    if (_movable) {
        _cellFrames = CGRectZero;
        _floatArea = CGRectZero;
    }
    
    if (CGRectEqualToRect(_cellFrames, CGRectZero)) {
        CGRect frame = [self.superview convertRect:self.frame toView:_favorDisplayView];
        [self updateCellFramesWithFrame:frame];
        [self updateFloatAreaWithFrame:frame];
    }
    
    YJFavorEmitterCell *cell = [YJFavorEmitterCell emitterCellWithFrame:_cellFrames
                                                              floatArea:_floatArea
                                                                   image:_cellImages[randomIndex]];
    
    [_favorDisplayView.layer addSublayer:cell];
    
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

#pragma mark - frame update

- (void)updateCellFramesWithFrame:(CGRect)frame
{
    _cellFrames = CGRectMake(frame.origin.x,
                             frame.origin.y - frame.size.height * _scale * 0.5 * _originRange,
                             frame.size.width * _scale,
                             frame.size.height * _scale);
}

- (void)updateFloatAreaWithFrame:(CGRect)frame
{
    _floatArea = CGRectMake(CGRectGetMidX(frame) - CGRectGetWidth(frame) * 0.5 - _extraShift,
                            _risingY,
                            frame.size.width + 2 * _extraShift,
                            _favorDisplayView.frame.size.height - frame.size.height);
}

#pragma mark - setter

- (void)setScale:(CGFloat)scale
{
    _scale = MAX(MIN(scale, 1.5), 0.2);
}

- (void)setInteractEnabled:(BOOL)interactEnabled
{
    if (_interactEnabled == interactEnabled) {
        return;
    }
    
    _interactEnabled = interactEnabled;
    _btn.enabled = _interactEnabled;
}

- (void)setMovable:(BOOL)movable
{
    _movable = movable;
}

- (void)setExtraShift:(CGFloat)extraShift
{
    _extraShift = MAX(MIN(extraShift, 20), 10);
}

- (void)setRisingY:(CGFloat)risingY
{
    if (_risingY != risingY) {
        _risingY = risingY;
        _risingYUpdate = YES;
    }
}

- (void)setRisingVelocity:(CGFloat)risingVelocity
{
    _risingVelocity = MAX(MIN(risingVelocity, 15), 5);
}

- (void)setShiftCycle:(CGFloat)shiftCycle
{
    _shiftCycle = MAX(MIN(shiftCycle, 8), 1);
}

- (void)setRisingDuration:(CGFloat)risingDuration
{
    _risingDuration = MAX(MIN(risingDuration, 12), 5);
}

- (void)setRisingShiftDuration:(CGFloat)risingShiftDuration
{
    _risingShiftDuration = MAX(MIN(risingShiftDuration, 4), 1);
}

- (void)setFadeOutDuration:(CGFloat)fadeOutDuration
{
    _fadeOutDuration = MAX(MIN(fadeOutDuration, 10), 3);
}

- (void)setFadeOutShiftDuration:(CGFloat)fadeOutShiftDuration
{
    _fadeOutShiftDuration = MAX(MIN(fadeOutShiftDuration, 3), 1);
}

- (void)setOriginRange:(CGFloat)originRange
{
    _originRange = MAX(MIN(originRange, 1), 0);
}

@end
