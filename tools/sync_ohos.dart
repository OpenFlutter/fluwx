// ignore_for_file: avoid_print
import 'dart:io';

/// Keep checked-in OHOS files local to each module for ArkTS OhmUrl resolution.
/// Edit packages/_shared/ohos, then run dart tools/sync_ohos.dart.
/// CI uses --check to reject symlinks and stale copies.
void main(List<String> args) {
  final check = args.contains('--check');
  const shared = 'packages/_shared/ohos';
  const entries = [
    'build-profile.json5',
    'hvigorfile.ts',
    'index.ets',
    'src/main/ets',
  ];
  for (final package in ['fluwx', 'fluwx_no_pay']) {
    final root = 'packages/$package/ohos';
    for (final entry in entries) {
      final source = '$shared/$entry';
      final target = '$root/$entry';
      final files = FileSystemEntity.isDirectorySync(source)
          ? Directory(
              source,
            ).listSync(recursive: true).whereType<File>().toList()
          : [File(source)];
      final expected = <String>{};
      for (final file in files) {
        final relative = file.path.substring(shared.length + 1);
        final destination = '$root/$relative';
        expected.add(destination);
        // Check every ancestor too: a regular file inside a linked directory
        // still resolves outside the module.
        var path = destination;
        var linked = false;
        while (path != 'packages') {
          linked |= FileSystemEntity.isLinkSync(path);
          path = File(path).parent.path;
        }
        if (check) {
          if (linked ||
              !File(destination).existsSync() ||
              !_equal(
                file.readAsBytesSync(),
                File(destination).readAsBytesSync(),
              )) {
            stderr.writeln(
              'OHOS copy is linked, missing, or stale: $destination',
            );
            exitCode = 1;
          }
        }
      }
      if (check) {
        if (FileSystemEntity.isDirectorySync(target) &&
            !FileSystemEntity.isLinkSync(target)) {
          for (final entity in Directory(
            target,
          ).listSync(recursive: true, followLinks: false)) {
            if (entity is Link ||
                (entity is File && !expected.contains(entity.path))) {
              stderr.writeln('Unexpected OHOS source: ${entity.path}');
              exitCode = 1;
            }
          }
        }
      } else {
        // Replace only the managed entries, never the package-specific metadata.
        if (FileSystemEntity.isLinkSync(target)) {
          Link(target).deleteSync();
        } else if (FileSystemEntity.isDirectorySync(target)) {
          Directory(target).deleteSync(recursive: true);
        }
        for (final file in files) {
          final destination = '$root/${file.path.substring(shared.length + 1)}';
          File(destination).parent.createSync(recursive: true);
          file.copySync(destination);
        }
      }
    }
  }
  if (exitCode == 0) {
    print(
      check
          ? 'OHOS copies are local and up to date.'
          : 'OHOS copies synchronized.',
    );
  }
}

bool _equal(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
