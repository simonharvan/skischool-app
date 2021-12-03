import 'package:logger/logger.dart';

class Log {
  static Logger logger;
  static init() {
    logger = Logger(
      printer: PrettyPrinter(),
    );
  }

  static d(String message) {
    logger.d(message);
  }

  static w(String message) {
    logger.w(message);
  }

  static e(String message) {
    logger.e(message);
  }
}