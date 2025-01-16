// loginServicePage this page is used to make baseUrl call by defining a method to make API service call.

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:lm_club/constants/endpoints.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';

import 'package:http/http.dart' as http;
part 'login_service.g.dart';

@RestApi()
abstract class LoginService {
  factory LoginService(Dio dio) = _LoginService;

  @POST(LMCEndpoints.login)
  Future<HttpResponse> login(@Body() Map<String, dynamic> data);

  @GET(LMCEndpoints.getUserDetails)
  Future<HttpResponse> getUserDetails(
      @Header("x-access-code") String token, String id);

  @PUT(LMCEndpoints.uploadProfileImage)
  Future<Map<String, dynamic>> uploadProfileImage(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);

  @PUT(LMCEndpoints.updateUserDetails)
  Future<HttpResponse> updateUserDetails(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);
}
