// GENERATED CODE - DO NOT MODIFY BY HAND

// _loginServicePage here we can write our API call service.
part of 'login_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _LoginService implements LoginService {
  _LoginService(this._dio);

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<dynamic>> login(data) async {
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
              '/api/user/login',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getUserDetails(token, id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      // 'x-access-code': token,
      'Authorization': 'Bearer $token',
    };
    final _data = <String, dynamic>{};
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '${LMCEndpoints.getUserDetails}$id',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> updateUserDetails(token, data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      // 'x-access-code': token,
      'Authorization': 'Bearer $token',
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
              '/api/user/updateProfile',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<Map<String, dynamic>> uploadProfileImage(token, data) async {
    var uri = Uri.parse('${LMCEndpoints.baseUrl}api/user/updateProfilePicture');
    var request = http.MultipartRequest('PUT', uri);

    final _headers = <String, String>{
      // 'x-access-code': token,
      'Authorization': 'Bearer $token',
    };
    request.headers.addAll(_headers);
    Map<String, dynamic> inputParams = data;
    // inputParams.removeWhere((k, v) => k == 'image_path');
    File image = data['file'];
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
      print('postProperty-- respStr$respStr');
    }
    Map<String, dynamic> respJson = json.decode(respStr);
    return respJson;
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
