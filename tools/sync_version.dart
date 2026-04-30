// ignore_for_file: avoid_print
import 'dart:io';

/// 将 fluwx_no_pay 的版本号同步为与 fluwx 一致。
///
/// 用法：
///   dart tools/sync_version.dart          # 同步写入
///   dart tools/sync_version.dart --check  # 仅校验（供 CI 使用）
void main(List<String> args) {
  final checkOnly = args.contains('--check');

  final fluwxPubspec = File('packages/fluwx/pubspec.yaml');
  final noPayPubspec = File('packages/fluwx_no_pay/pubspec.yaml');

  if (!fluwxPubspec.existsSync()) {
    print('❌ 找不到 packages/fluwx/pubspec.yaml');
    exit(1);
  }
  if (!noPayPubspec.existsSync()) {
    print('❌ 找不到 packages/fluwx_no_pay/pubspec.yaml');
    exit(1);
  }

  final fluwxContent = fluwxPubspec.readAsStringSync();
  final versionMatch =
      RegExp(r'^version:\s*(.+)$', multiLine: true).firstMatch(fluwxContent);
  if (versionMatch == null) {
    print('❌ 未在 fluwx/pubspec.yaml 中找到版本号');
    exit(1);
  }
  final version = versionMatch.group(1)!.trim();

  if (checkOnly) {
    final noPayContent = noPayPubspec.readAsStringSync();
    final noPayVersionMatch =
        RegExp(r'^version:\s*(.+)$', multiLine: true).firstMatch(noPayContent);
    final noPayVersion = noPayVersionMatch?.group(1)?.trim();
    if (noPayVersion != version) {
      print('❌ 版本不同步：fluwx=$version, fluwx_no_pay=$noPayVersion');
      exit(1);
    }
    print('✅ 版本一致：$version');
    return;
  }

  var noPayContent = noPayPubspec.readAsStringSync();
  noPayContent = noPayContent.replaceFirstMapped(
    RegExp(r'^version: .+$', multiLine: true),
    (_) => 'version: $version',
  );
  noPayPubspec.writeAsStringSync(noPayContent);
  print('✅ fluwx_no_pay 版本已同步至 $version');
}
