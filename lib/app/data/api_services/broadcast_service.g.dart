// GENERATED CODE - DO NOT MODIFY BY HAND

// _broadCastServicePage here we can write our API call service.
part of 'broadcast_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _BroadcastService implements BroadcastService {
  _BroadcastService(
    this._dio, {
    // ignore: unused_element
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<Map<String, dynamic>> uploadBroadcast(
    token,
    data,
  ) async {
    var uri = Uri.parse('${LMCEndpoints.baseUrl}api/post/uploadPost');
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

  @override
  Future<Map<String, dynamic>> uploadBusinessBroadcast(
    token,
    data,
  ) async {
    var uri = Uri.parse('${LMCEndpoints.baseUrl}api/uploadBroadcastPost');
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
  Future<HttpResponse<dynamic>> getBroadcasts(token, data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'search': data['search'] ?? '',
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
              LMCEndpoints.getBroadcasts,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getMyBroadcasts(token, data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'dates': data['dates'],
    };
    final _headers = <String, dynamic>{
      'x-access-code': token,
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
              LMCEndpoints.getMyBroadcasts,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> myShares(token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      'x-access-code': token,
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
              LMCEndpoints.myShares,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> shareTypes(token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      'x-access-code': token,
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
              LMCEndpoints.shareTypes,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> sharePost(token, data) async {
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
              LMCEndpoints.sharePost,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> generateAcceratedUrl(token, data) async {
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
              '/api/user/generateAcceleratedUrl',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getBroadcastPlans(token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
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
              LMCEndpoints.getBroadcastPlans,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> viewBroadcastPost(token, id) async {
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
              '${LMCEndpoints.viewBroadcastPost}$id',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> updateDraftBusinessBroadcast(
      token, data) async {
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
              '/api/uploadBroadcastPost',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> deleteFile(token, data) async {
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
              LMCEndpoints.deleteFile,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse> deleteAccount(String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      // 'x-access-code': token,
      'Authorization': 'Bearer $token',
    };
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              LMCEndpoints.deleteAccount,
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<List<CustomSettings>> customSettings() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'GET',
      extra: _extra,
    )
            .compose(
              _dio.options,
              LMCEndpoints.customSettings,
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return List<CustomSettings>.from(
        httpResponse.data?.map((x) => CustomSettings.fromJson(x)));
  }
}
