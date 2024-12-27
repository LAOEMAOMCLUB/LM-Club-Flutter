import 'package:logger/logger.dart';

class LoggingService {
  final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      // ignore: deprecated_member_use
      printTime: false,
    ),
  );

  void logError(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    logger.e(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void logDebug(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    logger.d(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void logInfo(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    logger.i(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
