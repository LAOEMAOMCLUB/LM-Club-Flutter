// baseErrorPage here we can define varible for error (type,error)

import 'server_error.dart';

class BaseError {
  final String? errorType;
  final ServerError? serverError;

  BaseError(this.errorType, {this.serverError});
}
