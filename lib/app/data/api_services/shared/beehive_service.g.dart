// GENERATED CODE - DO NOT MODIFY BY HAND

// _beehiveServicePage here we can write our API call service.
part of 'beehive_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _BeehiveService implements BeehiveService {
  _BeehiveService(
    this._dio, {
    // ignore: unused_element
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<dynamic>> getBeehivePosts(String token, data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'search': data['search'] ?? '',
      'categoryId': data['categoryId'],
      'dates': data['dates'],
    };
    final _headers = <String, dynamic>{
      'Authorization': 'Bearer $token',
    };
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
              LMCEndpoints.getBeehivePosts,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> myPostsBeehive(String token, data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'categoryId': data['categoryId'],
      'dates': data['dates'],
    };
    final _headers = <String, dynamic>{
      // 'x-access-code': token,
      'Authorization': 'Bearer $token',
    };
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
              LMCEndpoints.myPostsBeehive,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getBeehiveCategories() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
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
              LMCEndpoints.getbeehiveCategories,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<Map<String, dynamic>> uploadBeehive(
    token,
    data,
  ) async {
    var uri =
        Uri.parse('${LMCEndpoints.baseUrl}api/beehivePost/uploadBeehivePost');
    var request = http.MultipartRequest('POST', uri);
    final _headers = <String, String>{
      // 'x-access-code': token,
      'Authorization': 'Bearer $token',
    };
    request.headers.addAll(_headers);
    // List<ImageModel> imgModels = [];
    // if (data['files'] is List<ImageModel>) {
    //   imgModels = data['files'] as List<ImageModel>;
    // }
    Map<String, dynamic> inputParams = data;
    List<File> files = data['files'];
    inputParams.removeWhere((k, v) => k == 'files');
    Map<String, String> stringParameters =
        inputParams.map((key, value) => MapEntry(key, value.toString()));
    request.fields.addAll(stringParameters);
    if (files.isNotEmpty) {
      if (kDebugMode) {
        print('uploadBroadcast-- images available');
      }
      for (var file in files) {
        var fileBytes = await file.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'files',
          fileBytes,
          filename: file.path.split('/').last,
          contentType: MediaType('image', file.path.split('.').last),
        ));
      }
    }

    if (kDebugMode) {
      print('request files== ${request.files}');
    }
    var streamedResponse = await request.send();
    final respStr = await streamedResponse.stream.bytesToString();
    if (kDebugMode) {
      print('postProperty-- respStr$respStr');
    }
    //  Map<String, dynamic> respJson = json.decode(respStr);
    return json.decode(respStr);
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

  @override
  Future<HttpResponse<dynamic>> saveOrLikePost(token, data) async {
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
              LMCEndpoints.saveOrLikePost,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> mySavedPosts(String token, data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'search': data['search'] ?? '',
      'categoryId': data['categoryId'],
      'dates': data['dates'],
    };
    final _headers = <String, dynamic>{
      'Authorization': 'Bearer $token',
    };
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
              LMCEndpoints.mySavedPosts,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }
}
