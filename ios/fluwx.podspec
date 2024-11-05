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
symlinks_index = calling_dir.index('/ios/.symlinks')
if !symlinks_index
    symlinks_index = calling_dir.index('/.ios/.symlinks')
end

flutter_project_dir = calling_dir.slice(0..(symlinks_index))

Pod::UI.puts "[fluwx] #{Psych::VERSION}"
psych_version_gte_500 = Gem::Version.new(Psych::VERSION) >= Gem::Version.new('5.0.0')
if psych_version_gte_500 == true
    cfg = YAML.load_file(File.join(flutter_project_dir, 'pubspec.yaml'), aliases: true)
else
    cfg = YAML.load_file(File.join(flutter_project_dir, 'pubspec.yaml'))
end

logging_status = "WECHAT_LOGGING=0"

if cfg['fluwx'] && cfg['fluwx']['debug_logging'] == true
    logging_status = 'WECHAT_LOGGING=1'
else
    logging_status = 'WECHAT_LOGGING=0'
end

scene_delegate = ''
if cfg['fluwx'] && cfg['fluwx']['ios'] && cfg['fluwx']['ios']['scene_delegate'] == true
    scene_delegate = 'SCENE_DELEGATE=1'
else
    scene_delegate = ''
end


if cfg['fluwx'] && cfg['fluwx']['ios'] && cfg['fluwx']['ios']['no_pay'] == true
    fluwx_subspec = 'no_pay'
else
    fluwx_subspec = 'pay'
end
Pod::UI.puts "[fluwx] Using SDK with #{fluwx_subspec}"

app_id = ''
if cfg['fluwx'] && cfg['fluwx']['app_id']
    app_id = cfg['fluwx']['app_id']
end
if !app_id.nil? && !app_id.empty?
    Pod::UI.puts "[fluwx] app_id: #{app_id}"
end

ignore_security = ''
if cfg['fluwx'] && cfg['fluwx']['ios'] && cfg['fluwx']['ios']['ignore_security'] == true
    ignore_security = '-i'
end
if !ignore_security.nil? && !ignore_security.empty?
    Pod::UI.puts "[fluwx] ignore_security: #{ignore_security}"
end

universal_link = ''
if cfg['fluwx'] && (cfg['fluwx']['ios']  && cfg['fluwx']['ios']['universal_link'])
    universal_link = cfg['fluwx']['ios']['universal_link']
end
if !universal_link.nil? && !universal_link.empty?
    Pod::UI.puts "[fluwx] universal_link: #{universal_link}"
end

command = "ruby #{current_dir}/wechat_setup.rb #{ignore_security}"
command += " -p #{project_dir} -n Runner.xcodeproj"
command += " -a #{app_id}" unless app_id.nil? || app_id.empty?
command += " -u #{universal_link}" unless universal_link.nil? || universal_link.empty?
system(command)

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
  s.static_framework = true
  s.resource_bundles = {'fluwx_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
  s.default_subspec = fluwx_subspec

  pod_target_xcconfig = {
      'OTHER_LDFLAGS' => '$(inherited) -ObjC -all_load'
  }

  s.subspec 'pay' do |sp|
    sp.dependency 'WechatOpenSDK-XCFramework','~> 2.0.4'

    pod_target_xcconfig["GCC_PREPROCESSOR_DEFINITIONS"] = "$(inherited) #{logging_status} #{scene_delegate}"

    sp.pod_target_xcconfig = pod_target_xcconfig
  end

  s.subspec 'no_pay' do |sp|
    sp.dependency 'OpenWeChatSDKNoPay','~> 2.0.4'
    sp.frameworks = 'CoreGraphics', 'Security', 'WebKit'
    sp.libraries = 'c++', 'z', 'sqlite3.0'
    pod_target_xcconfig["GCC_PREPROCESSOR_DEFINITIONS"] = "$(inherited) NO_PAY=1 #{logging_status} #{scene_delegate}"
    sp.pod_target_xcconfig = pod_target_xcconfig
  end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
