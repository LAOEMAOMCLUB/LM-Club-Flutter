// forgotPasswordServicePage this page is used to make baseUrl call by defining a method to make API service call.

import 'package:dio/dio.dart';
import 'package:lm_club/constants/endpoints.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';

part 'forgot_password_service.g.dart';

@RestApi()
abstract class ForgotPasswordService {
  factory ForgotPasswordService(Dio dio) = _ForgotPasswordService;

  @POST(LMCEndpoints.forgotPassword)
  Future<HttpResponse> forgotPassword(@Body() Map<String, dynamic> data);

  @POST(LMCEndpoints.resetPassword)
  Future<HttpResponse> resetPassword(@Body() Map<String, dynamic> data);

  @POST(LMCEndpoints.verifyOtp)
  Future<HttpResponse> verifyOtp(@Body() Map<String, dynamic> data);

  @POST(LMCEndpoints.resendOtp)
  Future<HttpResponse> resendOtp(@Body() Map<String, dynamic> data);
}
