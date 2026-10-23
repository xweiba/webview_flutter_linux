// Verify the real hook produces no Linux bridge assets for other platforms.
import 'package:code_assets/code_assets.dart';

import '../hook/build.dart' as hook;

Future<void> main() async {
  for (final target in [OS.android, OS.iOS, OS.macOS, OS.windows]) {
    await testCodeBuildHook(
      mainMethod: hook.main,
      targetOS: target,
      targetArchitecture: Architecture.arm64,
      check: (input, output) {
        if (output.assets.code.isNotEmpty || output.dependencies.isNotEmpty) {
          throw StateError('Linux bridge unexpectedly built for $target');
        }
      },
    );
  }
}
