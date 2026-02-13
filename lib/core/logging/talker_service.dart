import 'package:flutter/foundation.dart';

class TalkerService {
  TalkerService();

  void log(String message) {
    if (kDebugMode) {
      debugPrint('[LOG] $message');
    }
  }

  void info(String message) {
    if (kDebugMode) {
      debugPrint('[INFO] $message');
    }
  }

  void error(dynamic error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[ERROR] $error');
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
  }

  void warning(String message) {
    if (kDebugMode) {
      debugPrint('[WARNING] $message');
    }
  }

  void debug(String message) {
    if (kDebugMode) {
      debugPrint('[DEBUG] $message');
    }
  }
}
