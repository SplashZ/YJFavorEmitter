//
//  ViewController.m
//  YJFavorEmitter
//
//  Created by splashz on 10/24/2016.
//  Copyright (c) 2016 splashz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJFavorEmitterCell : CALayer
@property (assign, nonatomic) float terminationY;

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString*)imageName terminationY:(float)terminationY;

- (void)startAnimation;

@end
