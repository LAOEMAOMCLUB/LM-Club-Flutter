// GENERATED CODE - DO NOT MODIFY BY HAND

// _enrollServicePage here we can write our API call service.
part of 'enroll_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _EnrollService implements EnrollService {
  _EnrollService(
    this._dio, {
    // ignore: unused_element
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<dynamic>> enroll(data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    // Set your device type
    const String deviceType = 'mobile';
    // Update headers with deviceType
    final _headers = <String, dynamic>{
      'deviceType': deviceType,
    };
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/user/signup',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<Map<String, dynamic>> businessEnroll(data) async {
    // Set your device type
    // const String deviceType = 'mobile';
    // Update headers with deviceType
    final _headers = <String, String>{
      // 'deviceType': deviceType,
    };
    var uri = Uri.parse("${LMCEndpoints.baseUrl}api/user/signupBusinessUser");
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll(_headers);

    Map<String, dynamic> inputParams = data;
    File image = data['file'];
    inputParams.removeWhere((k, v) => k == 'file');
    Map<String, String> stringParameters =
        inputParams.map((key, value) => MapEntry(key, value.toString()));
    request.fields.addAll(stringParameters);

    if (image.path.isNotEmpty) {
      if (kDebugMode) {
        print('uploadBroadcast-- images available');
      }

      var fileBytes = await image.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: image.path.split('/').last,
        contentType: MediaType('image', image.path.split('.').last),
      ));
    }
    if (kDebugMode) {
      print('request files== ${request.files}');
    }
    var streamedResponse = await request.send();
    final respStr = await streamedResponse.stream.bytesToString();
    if (kDebugMode) {
      print('business user- respStr$respStr');
    }
    //  Map<String, dynamic> respJson = json.decode(respStr);
    return json.decode(respStr);
  }

  @override
  Future<HttpResponse<dynamic>> checkOut(data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/payments/planPayment',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getStates() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'x-access-code': ''};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/masters/allStates',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getCities(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '${LMCEndpoints.getCities}$id',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> validateReferalCode(data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              LMCEndpoints.validateReferalCode,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
