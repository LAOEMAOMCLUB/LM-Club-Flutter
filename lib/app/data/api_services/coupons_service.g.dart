// GENERATED CODE - DO NOT MODIFY BY HAND

// _couponsServicePage here we can write our API call service.
part of 'coupons_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _CouponsService implements CouponsService {
  _CouponsService(
    this._dio, {
    // ignore: unused_element
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<dynamic>> getCategories() async {
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
              LMCEndpoints.getCategories,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<Map<String, dynamic>> addCoupon(
    data,
  ) async {
    var uri =
        Uri.parse('https://devfan.flippingamericanetwork.com/api/lm/addCoupon');
    var request = http.MultipartRequest('POST', uri);

    // List<ImageModel> imgModels = data['images'] as List<ImageModel>;
    Map<String, dynamic> inputParams = data;
    inputParams.removeWhere((k, v) => k == 'images');
    Map<String, String> stringParameters =
        inputParams.map((key, value) => MapEntry(key, value.toString()));
    request.fields.addAll(stringParameters);
    if (data['image'].isNotEmpty) {
      if (kDebugMode) {
        print('postProperty-- images available');
      }

      if (kDebugMode) {
        print('postProperty-- bytes exists');
      }
      request.files
          .add(await http.MultipartFile.fromPath('image', data['image']));
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

  @override
  Future<HttpResponse<dynamic>> getCoupons() async {
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
              LMCEndpoints.getCoupons,
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }
}
