#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint fluwx.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'fluwx'
  s.version          = '0.0.1'
  s.summary          = 'The capability of implementing WeChat SDKs in Flutter. With Fluwx, developers can use WeChatSDK easily, such as sharing, payment, lanuch mini program and etc.'
  s.description      = <<-DESC
The capability of implementing WeChat SDKs in Flutter. With Fluwx, developers can use WeChatSDK easily, such as sharing, payment, lanuch mini program and etc.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.dependency 'WechatOpenSDK-XCFramework','~> 2.0.2'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
