#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint fluwx.podspec` to validate before publishing.
#

#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint fluwx.podspec` to validate before publishing.
#

pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
library_version = pubspec['version'].gsub('+', '-')

current_dir = Dir.pwd
calling_dir = File.dirname(__FILE__)
project_dir = calling_dir.slice(0..(calling_dir.index('/.symlinks')))
flutter_project_dir = calling_dir.slice(0..(calling_dir.index('/ios/.symlinks')))
cfg = YAML.load_file(File.join(flutter_project_dir, 'pubspec.yaml'))
debug_logging = false
if cfg['fluwx'] && cfg['fluwx']['debug_logging'] == true
  debug_logging = true
end

if cfg['fluwx'] && cfg['fluwx']['ios'] && cfg['fluwx']['ios']['no_pay'] == true
    fluwx_subspec = 'no_pay'
else
    fluwx_subspec = 'pay'
end
Pod::UI.puts "using sdk with #{fluwx_subspec}"
if cfg['fluwx'] && (cfg['fluwx']['app_id'] && cfg['fluwx']['ios']  && cfg['fluwx']['ios']['universal_link'])
    app_id = cfg['fluwx']['app_id']
    universal_link = cfg['fluwx']['ios']['universal_link']
    system("ruby #{current_dir}/wechat_setup.rb -a #{app_id} -u #{universal_link} -p #{project_dir} -n Runner.xcodeproj")
else
    abort("required values:[app_id, universal_link] are missing. Please add them in pubspec.yaml:\nfluwx:\n  app_id: ${app id}\n  \nios:\nuniversal_link: https://${applinks domain}/universal_link/${example_app}/wechat/\n")
end

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
  s.platform = :ios, '11.0'
  s.static_framework = true
  s.default_subspec = fluwx_subspec

  pod_target_xcconfig = {
      'OTHER_LDFLAGS' => '$(inherited) -ObjC -all_load'
  }

  s.subspec 'pay' do |sp|
    sp.dependency 'WechatOpenSDK-XCFramework','~> 2.0.2'

    if debug_logging
        pod_target_xcconfig["GCC_PREPROCESSOR_DEFINITIONS"] = '$(inherited) WECHAT_LOGGING=1'
    else
        pod_target_xcconfig["GCC_PREPROCESSOR_DEFINITIONS"] = '$(inherited) WECHAT_LOGGING=0'
    end
    sp.pod_target_xcconfig = pod_target_xcconfig
  end

  s.subspec 'no_pay' do |sp|
    sp.dependency 'OpenWeChatSDKNoPay','~> 2.0.2+2'
    sp.frameworks = 'CoreGraphics', 'Security', 'WebKit'
    sp.libraries = 'c++', 'z', 'sqlite3.0'
    if debug_logging
      pod_target_xcconfig["GCC_PREPROCESSOR_DEFINITIONS"] = '$(inherited) NO_PAY=1 WECHAT_LOGGING=1'
    else
      pod_target_xcconfig["GCC_PREPROCESSOR_DEFINITIONS"] = '$(inherited) NO_PAY=1 WECHAT_LOGGING=0'
    end
      sp.pod_target_xcconfig = pod_target_xcconfig
  end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
