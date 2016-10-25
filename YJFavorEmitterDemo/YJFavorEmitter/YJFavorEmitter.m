//
//  YJFavorEmitter.m
//  ParticleEmitterTest
//
//  Created by splashz on 15/11/2.
//  Copyright © 2015年 splashz. All rights reserved.
//

#import "YJFavorEmitter.h"
#import "YJFavorEmitterCell.h"


@interface YJFavorEmitter ()
@property (weak, nonatomic) UIView *parentView;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) UIButton *btn;
@property (assign, nonatomic) float terminationY;
@end

@implementation YJFavorEmitter

#pragma mark -- Initial Method

+ (instancetype)emitterWithFrame:(CGRect)frame
                      parentView:(UIView *)parentView
                           image:(UIImage *)image
                  highlightImage:(UIImage *)hightlightImage
{
    YJFavorEmitter *emitter = [[YJFavorEmitter alloc] initWithFrame:frame];
    emitter.parentView = parentView;
    [emitter setAppearanceWithImage:image highlightedImage:hightlightImage];
    return emitter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super init]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    UIButton *btn = [[UIButton new] initWithFrame:self.bounds];
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

- (void)setRiseTermination:(float)terminationY
{
    _terminationY = terminationY;
}

- (void)enabledClicked:(BOOL)isEnabled
{
    _btn.enabled = isEnabled;
}

#pragma mark -- Generate Method

- (void)generateEmitterCell
{
    int randomIndex = arc4random_uniform((int)_cellImages.count);
    NSLog(@"%d", randomIndex);
    YJFavorEmitterCell *cell = [[YJFavorEmitterCell alloc] initWithFrame:CGRectMake(0, self.frame.origin.y-self.frame.size.height*0.7, self.frame.size.width*1.4, self.frame.size.height*1.4) image:_cellImages[randomIndex] terminationY:_terminationY];
    cell.position = CGPointMake(self.center.x, cell.position.y);
    [self.parentView.layer addSublayer:cell];
    
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
    if (_tapHandler != nil) {
        _tapHandler();
    }
    [self generateEmitterCell];
}

@end
