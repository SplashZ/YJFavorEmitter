YJFavorEmitter
==================
[![CocoaPods](http://img.shields.io/cocoapods/v/YJFavorEmitter.svg?style=flat)](http://cocoapods.org/?q= YJFavorEmitter)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/YJFavorEmitter.svg?style=flat)](http://cocoapods.org/?q= YJFavorEmitter)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)&nbsp;
![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)

YJFavorEmitter 是一个非常好用的点赞粒子发射器。

安装
==================

1. 在 Podfile 中添加  `pod 'YJFavorEmitter'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 \<YJFavorEmitter/YJFavorEmitter.h>\>。

使用
==================

一个类方法即可轻松完成初始化

```objc


/**
 初始化粒子发射器

 @param frame           粒子发射器在parentView中的frame
 @param parentView      父容器
 @param image           粒子发射器的图片
 @param hightlightImage 粒子发射器的高亮图片

 @return 粒子发射器
 */
+ (instancetype)emitterWithFrame:(CGRect)frame
                      parentView:(UIView *)parentView
                           image:(UIImage *)image
                  highlightImage:(UIImage *)hightlightImage;
```

```objc

/**
 释放元素

 @param count 元素数量
 */
- (void)generateEmitterCellsForCellsCount:(int)count;
```

```objc

_emitter.cellImages = @[[UIImage imageNamed:@"heart"], [UIImage imageNamed:@"face"]];
```

完整例子请参照 demo

![image](https://github.com/SplashZ/YJFavorEmitter/blob/master/demo.gif)

配置
==================

- ARC
- 该项目最低支持 `iOS 6.0`。
- 同时支持 iPhone 和 iPad

许可证
==================

YJFavorEmitter 使用 MIT 许可证，详情见 LICENSE 文件。

