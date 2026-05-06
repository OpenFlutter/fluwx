Pod::Spec.new do |s|
  s.name             = 'fluwx'
  s.module_name      = 'fluwx'
  s.version          = '2.0.5'
  s.summary          = 'WeChat SDK Flutter plugin without payment — passes App Store payment compliance review.'
  s.description      = <<-DESC
    fluwx provides the same API as fluwx but the iOS binary contains NO WechatOpenSDK symbols.
    Calling payment methods returns MissingPluginException at runtime.
    Use this package when your app must pass App Store payment compliance review.
  DESC
  s.homepage         = 'https://github.com/OpenFlutter/fluwx'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'OpenFlutter' => 'jarvan.mo@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'fluwx/CocoaPodsSources/fluwx/**/*'
  s.public_header_files = 'fluwx/CocoaPodsSources/fluwx/include/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'WechatOpenSDK-XCFramework','~> 2.0.5'
  s.platform         = :ios, '12.0'
  s.static_framework = true
  s.resource_bundles = {
    'fluwx_privacy' => ['fluwx/CocoaPodsSources/fluwx/Resources/PrivacyInfo.xcprivacy']
  }
  s.swift_version = '5.0'

  s.frameworks  = 'CoreGraphics', 'Security', 'WebKit'
  s.libraries   = 'c++', 'z', 'sqlite3.0'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE'                      => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'OTHER_LDFLAGS'                       => '$(inherited) -ObjC -all_load'
  }
end
