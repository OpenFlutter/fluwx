#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'fluwx'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin for Wechat SDK.'
  s.description      = <<-DESC
A new Flutter plugin for Wechat SDK.
                       DESC
  s.homepage         = 'https://github.com/OpenFlutter/fluwx'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'JarvanMo' => 'jarvan.mo@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true
  spec.pod_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
  s.dependency 'Flutter'
  s.dependency 'WechatOpenSDK','~> 1.8.2'
  
  s.ios.deployment_target = '9.0'
end

