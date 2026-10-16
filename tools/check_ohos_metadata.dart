// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// Run from the workspace root before publishing either package.
void main() {
  for (final package in ['fluwx', 'fluwx_no_pay']) {
    final root = 'packages/$package';
    final pubspec = File('$root/pubspec.yaml').readAsStringSync();
    final name = RegExp(
      r'^name:\s*(\S+)\s*$',
      multiLine: true,
    ).firstMatch(pubspec)?.group(1);
    // These metadata files intentionally use the JSON subset of JSON5.
    final ohPackage = jsonDecode(
      File('$root/ohos/oh-package.json5').readAsStringSync(),
    );
    final module = jsonDecode(
      File('$root/ohos/src/main/module.json5').readAsStringSync(),
    );
    if (name != package ||
        ohPackage['name'] != name ||
        module['module']['name'] != name) {
      stderr.writeln(
        '$package: inconsistent names: pubspec=$name, '
        'OHPM=${ohPackage['name']}, module=${module['module']['name']}',
      );
      exitCode = 1;
    }
  }
  if (exitCode == 0)
    print('OHOS package and module names match both pubspecs.');
}
