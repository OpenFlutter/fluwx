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
  s.public_header_files = 'Classes/**/*.h','"${PODS_ROOT}/Headers/Public/OpenWeChatSDK"'
  s.static_framework = true
  s.dependency 'Flutter'
  s.dependency 'OpenWeChatSDK','~> 1.8.3+9'
  
  s.ios.deployment_target = '9.0'
end

