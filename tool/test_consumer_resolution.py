"""Verify the real video consumer dependency graph without building WPE."""
import json
from pathlib import Path
import subprocess
import tempfile
import unittest


class ConsumerResolution(unittest.TestCase):
    def test_shared_native_assets_irondash(self):
        plugin = Path(__file__).resolve().parents[1]
        with tempfile.TemporaryDirectory(prefix="webview-consumer-") as directory:
            fixture = Path(directory)
            (fixture / ".fvmrc").write_text(json.dumps({"flutter": "3.47.2"}))
            (fixture / "pubspec.yaml").write_text(f"""
name: webview_consumer_resolution
environment:
  sdk: ^3.12.2
dependencies:
  flutter:
    sdk: flutter
  webview_flutter_linux:
    path: {plugin}
  irondash_engine_context:
    git:
      url: https://github.com/xweiba/irondash.git
      ref: 5ec27b9cdb15656e23f72a4dd779d09c619d0d37
      path: engine_context/dart
""")
            result = subprocess.run(
                ["fvm", "flutter", "pub", "get", "--no-example"],
                cwd=fixture, capture_output=True, text=True, timeout=180,
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)


if __name__ == "__main__":
    unittest.main()
