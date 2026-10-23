# Video consumer native-assets compatibility

Upstream: https://github.com/kingwill101/webview_flutter_linux

Fork baseline: xweiba/webview_flutter_linux at
881b8cd455e785491dd04c7716298899aa2f62f6 (0.1.0-dev.2).

The video consumer already uses the Irondash native-assets migration at
5ec27b9cdb15656e23f72a4dd779d09c619d0d37 to build with Gradle 9. The
baseline's hosted Irondash 0.5.5 declaration makes Pub reject that graph before
any native build. Restore the same fixed Git source in this fork; do not use a
consumer dependency override or edit the Pub cache. Runtime code and prebuilt
artifact selection remain those of the baseline.

Regression: `PUB_HOSTED_URL=https://pub.flutter-io.cn python3
tool/test_consumer_resolution.py` resolves a real temporary Flutter consumer
with both dependencies. It fails on the baseline and passes with this pin.
Native WPE acceptance remains separate from this dependency-resolution test.

The baseline hook also attempted to compile WPE for Android and Apple targets.
The hook now returns before inspecting Rust inputs for every non-Linux target.
`fvm dart tool/test_non_linux_hook.dart` exercises the real hook with Android,
iOS, macOS and Windows build configurations and requires no emitted assets or
source dependencies. The Android case fails before the platform guard.
Remove this guard patch when upstream includes the same target restriction.

No upstream issue/PR has been submitted for this consumer-specific source pin.
Remove the patch when the required native-assets migration is available from
the hosted package and both consumers resolve the same supported source.
