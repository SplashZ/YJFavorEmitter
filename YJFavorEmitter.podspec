Pod::Spec.new do |s|
  s.platform     = :ios, '6.0'
  s.name         = 'YJFavorEmitter'
  s.version      = '1.0.0'
  s.summary      = 'A nice favar emitter'
  s.homepage     = 'https://github.com/SplashZ/YJFavorEmitter'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author            = { "splashz" => "splashz@163.com" }
  s.ios.deployment_target = '6.0'
  s.source       = { :git => 'https://github.com/SplashZ/YJFavorEmitter.git', :tag => s.version.to_s }
  s.requires_arc = true
  s.source_files = "YJFavorEmitterDemo/YJFavorEmitterDemo/YJFavorEmitter/*.{h,m}"
  s.public_header_files = 'YJFavorEmitterDemo/YJFavorEmitterDemo/YJFavorEmitter/*.{h}'
end