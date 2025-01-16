import 'package:dio/dio.dart';
import 'package:lm_club/app/data/dio/logging_intercepter.dart';


class DioFactory {
  final String _baseUrl;

  DioFactory(this._baseUrl);

  BaseOptions _createBaseOptions() => BaseOptions(
        baseUrl: _baseUrl,
      );

  Dio create() => Dio(_createBaseOptions())
    ..interceptors.addAll([
      LoggerInterceptor(),
    ]);
}
