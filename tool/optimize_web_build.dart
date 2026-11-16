// Post-build step for the web build: stops Flutter from downloading icon
// fonts the app never uses.
//
// Flutter web downloads every font listed in assets/FontManifest.json before
// it draws the first frame. Some icon packages declare several families the
// site does not use (lucide_icons_flutter ships six extra weight variants,
// font_awesome_flutter its Regular and Solid sets), which added about 1.3 MB
// to every first visit.
//
// A family is removed only if its name never appears in the compiled app
// (build/web/main.dart.js). Icons reference their font family by name, so a
// family the app uses is always kept.
//
// Usage, after `flutter build web`:
//   dart run tool/optimize_web_build.dart

import 'dart:convert';
import 'dart:io';

void main() {
  const buildDir = 'build/web';
  final manifestFile = File('$buildDir/assets/FontManifest.json');
  final appJs = File('$buildDir/main.dart.js');
  if (!manifestFile.existsSync() || !appJs.existsSync()) {
    stderr.writeln('No web build found. Run `flutter build web` first.');
    exit(1);
  }

  final js = appJs.readAsStringSync();
  final families = (jsonDecode(manifestFile.readAsStringSync()) as List).cast<Map<String, dynamic>>();

  final kept = <Map<String, dynamic>>[];
  var removedBytes = 0;
  for (final family in families) {
    final name = family['family'] as String;
    // Icons store the bare family name (e.g. 'Lucide100'), with the package
    // added at runtime, so look for the bare name.
    final shortName = name.split('/').last;
    if (js.contains("'$shortName'") || js.contains('"$shortName"')) {
      kept.add(family);
      continue;
    }
    for (final font in (family['fonts'] as List).cast<Map<String, dynamic>>()) {
      final file = File('$buildDir/assets/${font['asset']}');
      if (file.existsSync()) {
        removedBytes += file.lengthSync();
        file.deleteSync();
      }
    }
    stdout.writeln('Removed unused font family: $name');
  }

  manifestFile.writeAsStringSync(jsonEncode(kept));
  stdout.writeln(
    'Kept ${kept.length} of ${families.length} font families; '
    'removed ${(removedBytes / 1048576).toStringAsFixed(2)} MB of font files.',
  );
}
