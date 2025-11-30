class AppException implements Exception {
  final String _message;
  final String _prefix;

  AppException([this._message = "", this._prefix = ""]) : super();

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

class FetchDataException extends AppException {
  static const String _exceptionPrefix = "Error During Communication: ";

  FetchDataException([String? message])
      : super(message ?? "", _exceptionPrefix);
}

class BadRequestException extends AppException {
  static const String _exceptionPrefix = "Invalid Request: ";

  BadRequestException([String? message]) : super(message ?? "", _exceptionPrefix);
}

class UnauthorisedException extends AppException {
  static const String _exceptionPrefix = "Unauthorised: ";

  UnauthorisedException([String? message]) : super(message ?? "", _exceptionPrefix);
}

class UnprocessableEntityException extends AppException {
  static const String _exceptionPrefix = "Unprocessable Entity: ";

  UnprocessableEntityException([String? message])
      : super(message ?? "", _exceptionPrefix);
}

class InvalidInputException extends AppException {
  static const String _exceptionPrefix = "Invalid Input: ";

  InvalidInputException([String? message]) : super(message ?? "", _exceptionPrefix);
}