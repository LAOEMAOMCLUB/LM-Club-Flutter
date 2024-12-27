// enrollService this page is used to make baseUrl call by defining a method to make API service call.

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:lm_club/constants/endpoints.dart';
import 'package:retrofit/dio.dart';

import 'package:retrofit/http.dart';
import 'package:http/http.dart' as http;

part 'enroll_service.g.dart';

@RestApi()
abstract class EnrollService {
  factory EnrollService(Dio dio) = _EnrollService;

  @POST(LMCEndpoints.enroll)
  Future<HttpResponse> enroll(@Body() Map<String, dynamic> data);

  @POST(LMCEndpoints.checkOut)
  Future<HttpResponse> checkOut(@Body() Map<String, dynamic> data);

  @GET(LMCEndpoints.getCities)
  Future<HttpResponse> getCities(String id);

  @GET(LMCEndpoints.getStates)
  Future<HttpResponse> getStates();
  @POST(LMCEndpoints.validateReferalCode)
  Future<HttpResponse> validateReferalCode(@Body() Map<String, dynamic> data);

  @POST(LMCEndpoints.businessEnroll)
  Future<Map<String, dynamic>> businessEnroll(
      @Body() Map<String, dynamic> data);
}
