// referEarnServicePage this page is used to make baseUrl call by defining a method to make API service call.

import 'package:dio/dio.dart';
import 'package:lm_club/constants/endpoints.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';

part 'refer_earn_service.g.dart';

@RestApi()
abstract class ReferEarnService {
  factory ReferEarnService(Dio dio) = _ReferEarnService;

  @GET(LMCEndpoints.getUserPoints)
  Future<HttpResponse> getUserPoints(@Header("x-access-code") String token);

  @GET(LMCEndpoints.getReferalCode)
  Future<HttpResponse> getReferalCode(@Header("x-access-code") String token);
}
