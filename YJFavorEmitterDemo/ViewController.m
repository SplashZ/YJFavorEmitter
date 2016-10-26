//
//  ViewController.m
//  YJFavorEmitterDemo
//
//  Created by macintosh on 2016/10/24.
//  Copyright © 2016年 splashz. All rights reserved.
//

#import "ViewController.h"
#import "YJFavorEmitter.h"
#import "POP.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *counterLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) YJFavorEmitter *emitter;

@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign) NSInteger varCount;

@property (nonatomic, strong) POPBasicAnimation  *countAnimation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _counter = -1;
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 64)];
    
    _counterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 44, 20)];
    _counterLabel.textAlignment = NSTextAlignmentCenter;
    [container addSubview:_counterLabel];
    self.counter = 0;
    _emitter = [YJFavorEmitter emitterWithFrame:CGRectMake(0, 0, 44, 44)
                               favorDisplayView:self.view
                                          image:[UIImage imageNamed:@"heart.png"]
                                 highlightImage:nil];
    _emitter.extraShift = 10;
    _emitter.risingY = 100;
    _emitter.cellImages = @[[UIImage imageNamed:@"heart"], [UIImage imageNamed:@"face"]];
    [container addSubview:_emitter];
    __weak typeof(self) weakSelf = self;
    _emitter.tapHandler = ^ BOOL {
        weakSelf.counter += 1;
        return NO;
    };
    
    [self.view addSubview:container];
    container.center = self.view.center;

    _button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.5 - 22, self.view.frame.size.height - 64, 44, 44)];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_button setTitle:@"开始" forState:UIControlStateNormal];
    [_button setTitle:@"暂停" forState:UIControlStateSelected];
    [_button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

- (void)setCounter:(NSInteger)counter
{
    if (_counter == counter) {
        return;
    }
    
    _counter = counter;
    _counterLabel.text = @(_counter).stringValue;
    [_emitter generateEmitterCellsForCellsCount:1];
}

- (void)startAnimation
{
    [self pop_addAnimation:self.countAnimation forKey:nil];
}

- (void)stopAnimation
{
    [self pop_removeAllAnimations];
}

- (void)btnClick:(UIButton *)btn
{
    if (!btn.isSelected) {
        [self startAnimation];
    } else {
        [self stopAnimation];
    }
    btn.selected = !btn.isSelected;
}

- (POPBasicAnimation *)countAnimation
{
    if (!_countAnimation) {
        _countAnimation = [POPBasicAnimation animation];
        _countAnimation.fromValue = @(0);
        _countAnimation.toValue   = @(100);
        _countAnimation.duration  = 5;
        _countAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        __weak typeof(self) weakSelf = self;
        _countAnimation.property = [POPMutableAnimatableProperty propertyWithName:@"varCount" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.writeBlock = ^(id obj, const CGFloat values[]) {
                weakSelf.counter = (int)values[0];
            };
        }];
        
        _countAnimation.animationDidReachToValueBlock = ^ (POPAnimation *anim) {
            weakSelf.button.selected = NO;
        };
    }
    return _countAnimation;
}

@end
