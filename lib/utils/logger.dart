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

  /// Initializes the logger singleton and opens the log file.
  /// 
  /// Must be called once before any logging operations. Subsequent calls
  /// are no-ops if already initialized.
  /// 
  /// Creates a new log file per day in append mode.
  static Future<void> initialize() async {
    if (_initialized) return;

    final DateTime now = DateTime.now();
    _instance._sink = File('${now.year}-${now.month}-${now.day}.log').openWrite(mode: FileMode.append);
    
    _initialized = true;
    await _instance._writeRaw("--- Application Session Started ---");
  }

  /// Logs a raw message into the file.
  Future<void> _writeRaw(String message) async {
    final timestamp = DateTime.now().toIso8601String();
    _instance._sink.writeln("[$timestamp] $message");
    await _instance._sink.flush();
  }

  /// Logs an info-level message with timestamp.
  Future<void> info(String message) async {
    await _instance._writeRaw("[INFO] $message");
  }

  /// Logs a warning-level message with timestamp.
  Future<void> warning(String message) async {
    await _instance._writeRaw("[WARNING] $message");
  }

  /// Logs an error-level message with timestamp.
  Future<void> error(String message) async {
    await _instance._writeRaw("[ERROR] $message");
  }

  /// Closes the logger and flushes remaining buffered data.
  /// 
  /// Should be called during application shutdown to ensure all
  /// messages are written and file handles are properly released.
  static Future<void> close() async {
    if (!_initialized) return;

    await _instance._writeRaw("--- Application Session Ended ---");
    await _instance._sink.flush();
    await _instance._sink.close();
  }
}
