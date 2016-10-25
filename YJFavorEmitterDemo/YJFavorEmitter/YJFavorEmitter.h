//
//  YJFavorEmitter.h
//  ParticleEmitterTest
//
//  Created by splashz on 15/11/2.
//  Copyright © 2015年 splashz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJFavorEmitterCell;

typedef void (^EmitterTapHandler) (void);

@interface YJFavorEmitter : UIView

///元素图片
@property (strong, nonatomic) NSArray *cellImages;

///粒子发射器点击时的默认操作
@property (copy, nonatomic) EmitterTapHandler tapHandler;

+ (instancetype)emitterWithFrame:(CGRect)frame
                      parentView:(UIView *)parentView
                           image:(UIImage *)image
                  highlightImage:(UIImage *)hightlightImage;

- (void)setRiseTermination:(float)terminationY;
- (void)enabledClicked:(BOOL)isEnabled;

- (void)generateEmitterCellsForCellsCount:(int)count;

@end
