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

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel *counterLabel;
@property (weak, nonatomic) IBOutlet UIButton *autoBtn;
@property (weak, nonatomic) IBOutlet UIButton *moveBtn;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) YJFavorEmitter *emitter;

@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign) NSInteger varCount;

@property (nonatomic, strong) POPBasicAnimation  *countAnimation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _counter = -1;
    
    _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 64)];
    _container.center = self.view.center;
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    _panGesture.enabled = NO;
    [_container addGestureRecognizer:_panGesture];
    [self.view addSubview:_container];
    
    _counterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 44, 20)];
    _counterLabel.textAlignment = NSTextAlignmentCenter;
    [_container addSubview:_counterLabel];
    self.counter = 0;
    
    _emitter = [YJFavorEmitter emitterWithFrame:CGRectMake(0, 0, 44, 44)
                               favorDisplayView:self.view
                                          image:[UIImage imageNamed:@"heart.png"]
                                 highlightImage:nil];
    _emitter.extraShift = 10;
    _emitter.risingY = 100;
    _emitter.cellImages = @[[UIImage imageNamed:@"heart"], [UIImage imageNamed:@"face"]];
    __weak typeof(self) weakSelf = self;
    _emitter.tapHandler = ^ BOOL {
        weakSelf.counter += 1;
        return NO;
    };
    [_container addSubview:_emitter];
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

- (IBAction)autoBtnClicked:(UIButton *)btn {
    if (!btn.isSelected) {
        [self startAnimation];
    } else {
        [self stopAnimation];
    }
    btn.selected = !btn.isSelected;
}

- (IBAction)moveBtnClicked:(UIButton *)btn {
    if (!btn.isSelected) {
        _emitter.movable = YES;
        _panGesture.enabled = YES;
    } else {
        _emitter.movable = NO;
        _panGesture.enabled = NO;
    }
    btn.selected = !btn.isSelected;
}

- (POPBasicAnimation *)countAnimation
{
    if (!_countAnimation) {
        _countAnimation = [POPBasicAnimation animation];
        _countAnimation.fromValue = @(0);
        _countAnimation.toValue   = @(100);
        _countAnimation.duration  = 10;
        _countAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        __weak typeof(self) weakSelf = self;
        _countAnimation.property = [POPMutableAnimatableProperty propertyWithName:@"varCount" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.writeBlock = ^(id obj, const CGFloat values[]) {
                weakSelf.counter = (int)values[0];
            };
        }];
        
        _countAnimation.animationDidReachToValueBlock = ^ (POPAnimation *anim) {
            weakSelf.autoBtn.selected = NO;
        };
    }
    return _countAnimation;
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    CGPoint translate = [gesture translationInView:self.view];
    UIGestureRecognizerState state = gesture.state;
    switch (state) {
        case UIGestureRecognizerStateChanged:
            _container.transform = CGAffineTransformTranslate(_container.transform, translate.x, translate.y);
            break;
        default:
            break;
    }
    [gesture setTranslation:CGPointZero inView:self.view];
}

@end
