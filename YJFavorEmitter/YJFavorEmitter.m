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

@property (nonatomic, assign) BOOL updateCellFrames;
@property (nonatomic, assign) BOOL updateFloatArea;
@property (nonatomic, assign) CGRect cellFrames;
@property (nonatomic, assign) CGRect floatArea;
@property (nonatomic, assign) CGRect preFrame;

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
    
    _updateCellFrames = YES;
    _updateCellFrames = YES;
    _cellFrames = CGRectZero;
    _floatArea = CGRectZero;
    _preFrame = CGRectZero;
    
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
    
    CGRect frame = [self.superview convertRect:self.frame toView:_favorDisplayView];
    BOOL frameChanged = !CGRectEqualToRect(frame, _preFrame);
    _preFrame = frame;
    if (_updateCellFrames || frameChanged) {
        [self updateCellFramesWithFrame:frame];
        _updateCellFrames = NO;
    }
    
    if (_updateFloatArea || frameChanged) {
        [self updateFloatAreaWithFrame:frame];
        _updateFloatArea = NO;
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
        return;
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
    cell.minRisingVelocity = _minRisingVelocity;
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

- (void)setInteractEnabled:(BOOL)interactEnabled
{
    if (_interactEnabled == interactEnabled) {
        return;
    }
    
    _interactEnabled = interactEnabled;
    _btn.enabled = _interactEnabled;
}

- (void)setOriginRange:(CGFloat)originRange
{
    if (_originRange != originRange) {
        _originRange = MAX(MIN(originRange, 1), 0);
        _updateCellFrames = YES;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (_scale != scale) {
        _scale = MAX(MIN(scale, 1.5), 0.2);
        _updateCellFrames = YES;
    }
}

- (void)setExtraShift:(CGFloat)extraShift
{
    if (_extraShift != extraShift) {
        _extraShift = MAX(MIN(extraShift, 20), 10);
        _updateFloatArea = YES;
    }
}

- (void)setRisingY:(CGFloat)risingY
{
    if (_risingY != risingY) {
        _risingY = risingY;
        _updateFloatArea = YES;
    }
}

- (void)setShiftCycle:(CGFloat)shiftCycle
{
    _shiftCycle = MAX(MIN(shiftCycle, 8), 1);
}

- (void)setRisingDuration:(CGFloat)risingDuration
{
    _risingDuration = MAX(MIN(risingDuration, 12), 5);
}

- (void)setMinminRisingVelocity:(CGFloat)minRisingVelocity
{
    _minRisingVelocity = MAX(MIN(minRisingVelocity, 50), 20);
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

@end
