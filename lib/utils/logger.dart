import 'dart:io';

/// `Logger` writes messages to a single log file during the application's
/// lifetime. It supports three log levels:
///
/// - `INFO`    → General informational messages
/// - `WARNING` → Non-critical issues or unusual states
/// - `ERROR`   → Errors or failures that need attention
class Logger {
  static final Logger _instance = Logger._internal();

  factory Logger() => _instance;

  Logger._internal();

  static bool _initialized = false;
  late final IOSink _sink;

  static Future<void> initialize() async {
    if (_initialized) return;

    final DateTime now = DateTime.now();
    _instance._sink = File('${now.year}-${now.month}-${now.day}.log').openWrite(mode: FileMode.append);
    
    _initialized = true;
    await _instance._writeRaw("--- Application Session Started ---");
  }

  Future<void> _writeRaw(String message) async {
    final timestamp = DateTime.now().toIso8601String();
    _instance._sink.writeln("[$timestamp] $message");
    await _instance._sink.flush();
  }

  Future<void> info(String message) async {
    await _instance._writeRaw("[INFO] $message");
  }

  Future<void> warning(String message) async {
    await _instance._writeRaw("[WARNING] $message");
  }

  Future<void> error(String message) async {
    await _instance._writeRaw("[ERROR] $message");
  }

  static Future<void> close() async {
    if (!_initialized) return;

    await _instance._writeRaw("--- Application Session Ended ---");
    await _instance._sink.flush();
    await _instance._sink.close();
  }
}
