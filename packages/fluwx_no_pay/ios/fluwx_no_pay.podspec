
Pod::Spec.new do |s|
  s.name             = 'fluwx_no_pay'
  s.module_name      = 'fluwx_no_pay'
  s.version          = '2.0.5'
  s.summary          = 'WeChat SDK Flutter plugin without payment — passes App Store payment compliance review.'
  s.description      = <<-DESC
    fluwx_no_pay provides the same API as fluwx but the iOS binary contains NO WechatOpenSDK symbols.
    Calling payment methods returns MissingPluginException at runtime.
    Use this package when your app must pass App Store payment compliance review.
  DESC
  s.homepage         = 'https://github.com/OpenFlutter/fluwx'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'OpenFlutter' => 'jarvan.mo@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'fluwx_no_pay/CocoaPodsSources/fluwx_no_pay/**/*'
  s.public_header_files = 'fluwx_no_pay/CocoaPodsSources/fluwx_no_pay/include/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'OpenWeChatSDKNoPay', '~> 2.0.5'
  s.platform         = :ios, '13.0'
  s.static_framework = true
  s.resource_bundles = {
    'fluwx_no_pay_privacy' => ['fluwx_no_pay/CocoaPodsSources/fluwx_no_pay/Resources/PrivacyInfo.xcprivacy']
  }
  s.swift_version = '5.0'

  # ✅ 依赖 OpenWeChatSDKNoPay（无支付符号版），通过 FLUWX_NO_PAY 宏屏蔽支付代码
  s.frameworks  = 'CoreGraphics', 'Security', 'WebKit'
  s.libraries   = 'c++', 'z', 'sqlite3.0'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE'                      => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'GCC_PREPROCESSOR_DEFINITIONS'        => '$(inherited) FLUWX_NO_PAY=1',
    'OTHER_LDFLAGS'                       => '$(inherited) -ObjC -all_load'
  }
end
