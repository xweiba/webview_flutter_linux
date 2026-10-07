import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final target in ['android', 'ios', 'macos', 'windows']) {
    test('native hook emits no WPE asset on $target', () async {
      final temp = Directory.systemTemp.createTempSync('wpe-hook-');
      addTearDown(() => temp.deleteSync(recursive: true));
      final output = File('${temp.path}/output.json');
      final input = File('${temp.path}/input.json');
      input.writeAsStringSync(
        jsonEncode({
          'assets': {},
          'config': {
            'build_asset_types': ['code_assets/code'],
            'extensions': {
              'code_assets': {
                'link_mode_preference': 'dynamic',
                'target_architecture': target == 'android' || target == 'ios'
                    ? 'arm64'
                    : 'x64',
                'target_os': target,
              },
            },
            'linking_enabled': true,
          },
          'out_dir_shared': '${temp.path}/shared/',
          'out_file': output.path,
          'package_name': 'webview_flutter_linux',
          'package_root': '${Directory.current.path}/',
          'user_defines': {},
        }),
      );
      final sdk = Platform.environment['FLUTTER_ROOT']!;
      final result = await Process.run('$sdk/bin/cache/dart-sdk/bin/dart', [
        '--packages=.dart_tool/package_config.json',
        'hook/build.dart',
        '--config=${input.path}',
      ]);
      expect(result.exitCode, 0, reason: '${result.stderr}');
      final data = jsonDecode(output.readAsStringSync()) as Map;
      expect(data['status'], 'success');
      expect(data['assets'], isNull);
      expect(data['assets_for_linking'], isEmpty);
    });
  }
}
