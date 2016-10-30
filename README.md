YJFavorEmitter
==================
[![CocoaPods](http://img.shields.io/cocoapods/v/YJFavorEmitter.svg?style=flat)](http://cocoapods.org/?q= YJFavorEmitter)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/YJFavorEmitter.svg?style=flat)](http://cocoapods.org/?q= YJFavorEmitter)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)&nbsp;
[![Travis-CI](https://travis-ci.org/SplashZ/YJFavorEmitter.svg?branch=master)](https://travis-ci.org/SplashZ/YJFavorEmitter)&nbsp;
![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)

![demogif](https://github.com/SplashZ/YJFavorEmitter/blob/master/demo0.gif)
![demogif](https://github.com/SplashZ/YJFavorEmitter/blob/master/demo1.gif)
![demogif](https://github.com/SplashZ/YJFavorEmitter/blob/master/demo2.gif)
<br>

English
==================

YJFavorEmitter is a favor cells emitter which is very nice and easy to use.

Installation
==================

1. Add pod 'YJFavorEmitter' to your Podfile.
2. Run pod install or pod update.
3. import <YJFavorEmitter/YJFavorEmitter.h>.

Usage
==================


```objc

init emitter
/**
 _emitter = [YJFavorEmitter emitterWithFrame:CGRectMake(0, 0, 44, 44)
                               favorDisplayView:self.view
                                          image:[UIImage imageNamed:@"heart.png"]
                                 highlightImage:nil];
```
generate cells
```objc

/**
 generate a number of cells

 @param count cell's count
 */
- (void)generateEmitterCellsForCellsCount:(int)count;
```

set appearances of cells
```objc
//
_emitter.cellImages = @[[UIImage imageNamed:@"heart"], [UIImage imageNamed:@"face"]];
```

See demo for details.

Requirements
==================

- ARC.
- Requires iOS 6.0+.
- Adapt to both iPhone & iPad.

License
==================

YJFavorEmitter is provided under the MIT license.See LICENSE file for details.



Chiness
==================
YJFavorEmitter 是一个非常好用的点赞粒子发射器。

安装
==================

1. 在 Podfile 中添加  `pod 'YJFavorEmitter'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 <YJFavorEmitter/YJFavorEmitter.h>。

使用
==================

初始化发射器
```objc

_emitter = [YJFavorEmitter emitterWithFrame:CGRectMake(0, 0, 44, 44)
                               favorDisplayView:self.view
                                          image:[UIImage imageNamed:@"heart.png"]
                                 highlightImage:nil];
```
产生元素
```objc

/**
 释放元素

 @param count 元素数量
 */
- (void)generateEmitterCellsForCellsCount:(int)count;
```
设置元素外观
```objc

_emitter.cellImages = @[[UIImage imageNamed:@"heart"], [UIImage imageNamed:@"face"]];
```

更多精彩请看 demo

配置
==================

- ARC
- 该项目最低支持 `iOS 6.0`。
- 同时支持 iPhone 和 iPad

许可证
==================

YJFavorEmitter 使用 MIT 许可证，详情见 LICENSE 文件。

