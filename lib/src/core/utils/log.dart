import 'dart:io';

void logR(String tag, String message) {
  final time = DateTime.now().toIso8601String();
  final pid = pidSafe;
  stdout.writeln('[$time][$pid][$tag] $message');
}

String get pidSafe {
  try {
    return pid.toString();
  } catch (_) {
    return 'no-pid';
  }
}
