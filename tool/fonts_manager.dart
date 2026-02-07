import 'dart:io';

import 'package:vidra/src/core/utils/log.dart';

void main(List<String> args) {
  final pubspecFile = File('pubspec.yaml');
  final fontsFile = File('pubspec_fonts.yaml');

  if (!pubspecFile.existsSync()) {
    logR("Error", 'pubspec.yaml not found.');
    exit(1);
  }
  if (!fontsFile.existsSync()) {
    logR("Error", 'pubspec_fonts.yaml not found.');
    exit(1);
  }

  String pubspecContent = pubspecFile.readAsStringSync();
  String fontsContent = fontsFile.readAsStringSync();

  // Markers to identify the injected fonts section
  final startMarker = '# WINDOWS_FONTS_START';
  final endMarker = '# WINDOWS_FONTS_END';

  bool isEnabled = pubspecContent.contains(startMarker);

  if (args.isEmpty) {
    logR("Usage", 'dart tool/fonts_manager.dart [enable|disable]');
    return;
  }

  final command = args[0];

  if (command == 'enable') {
    if (isEnabled) {
      logR("Fonts", 'Fonts are already enabled.');
      return;
    }

    // Ensure we append safely.
    // We assume pubspec.yaml ends with the flutter section or can accept indented 'fonts:' at the end.
    // We ensure there is a newline before appending.
    if (!pubspecContent.endsWith('\n')) {
      pubspecContent += '\n';
    }

    final newSection = '$startMarker\n$fontsContent\n$endMarker\n';
    pubspecFile.writeAsStringSync(pubspecContent + newSection);
    logR("Fonts", 'Fonts enabled for Windows. (appended to pubspec.yaml)');
  } else if (command == 'disable') {
    if (!isEnabled) {
      logR("Fonts", 'Fonts are already disabled.');
      return;
    }

    // Remove the section
    // We look for startMarker ... endMarker
    // using regex to handle potential newlines cautiously
    final pattern = RegExp(
      r'# WINDOWS_FONTS_START[\s\S]*?# WINDOWS_FONTS_END\n?',
    );

    // Check match first to be sure
    if (!pattern.hasMatch(pubspecContent)) {
      logR(
        "Error",
        'Markers found but content pattern did not match. Please check pubspec.yaml manually.',
      );
      exit(1);
    }

    final newContent = pubspecContent.replaceAll(pattern, '');
    pubspecFile.writeAsStringSync(newContent);
    logR("Fonts", 'Fonts disabled settings removed from pubspec.yaml');
  } else {
    logR("Usage", 'Unknown command: $command. Use [enable|disable]');
  }
}
