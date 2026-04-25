import 'package:logger/logger.dart';

/// Centralized logging utility for the application.
///
/// Provides structured logging with different levels (debug, info, warning, error).
/// Replaces print() statements to follow Flutter Playbook standards.
/// Logs are formatted with timestamps and can be filtered by level.
///
/// Usage:
/// ```dart
/// AppLogger.debug('User tapped login button');
/// AppLogger.info('Login successful for user: $userId');
/// AppLogger.warning('Token expiring soon');
/// AppLogger.error('Login failed', error: e, stackTrace: stackTrace);
/// ```
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      // Timestamp helps track when events occurred for debugging
      printTime: true,
    ),
  );

  /// Logs debug information for development.
  ///
  /// Use for detailed information useful during development and debugging.
  /// These logs should not contain sensitive user data.
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Logs informational messages.
  ///
  /// Use for general application flow information (user actions, state changes).
  /// Helps track normal application behavior.
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Logs warning messages.
  ///
  /// Use for potentially harmful situations that don't prevent app functionality.
  /// Examples: deprecated API usage, fallback to default values.
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Logs error messages.
  ///
  /// Use for error events that might still allow the app to continue running.
  /// Always include error object and stack trace for debugging.
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Logs fatal errors that require immediate attention.
  ///
  /// Use for critical errors that prevent core functionality.
  /// These should be monitored and fixed with high priority.
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
