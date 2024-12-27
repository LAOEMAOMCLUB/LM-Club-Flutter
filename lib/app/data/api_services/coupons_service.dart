// couponsServicePage this page is used to make baseUrl call by defining a method to make API service call.

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lm_club/constants/endpoints.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';
import 'package:http/http.dart' as http;
part 'coupons_service.g.dart';

@RestApi()
abstract class CouponsService {
  factory CouponsService(Dio dio) = _CouponsService;

  @GET(LMCEndpoints.getCategories)
  Future<HttpResponse> getCategories();

  @POST(LMCEndpoints.addCoupon)
  Future<Map<String, dynamic>> addCoupon(@Body() Map<String, dynamic> data);

  @GET(LMCEndpoints.getCoupons)
  Future<HttpResponse> getCoupons();
}
