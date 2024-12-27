// beehiveService this page is used to make baseUrl call by defining a method to make API service call.

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';
import 'package:http/http.dart' as http;
import 'package:lm_club/constants/endpoints.dart';
part 'beehive_service.g.dart';

@RestApi()
abstract class BeehiveService {
  factory BeehiveService(Dio dio) = _BeehiveService;

  @GET(LMCEndpoints.getBeehivePosts)
  Future<HttpResponse> getBeehivePosts(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);

  @GET(LMCEndpoints.myPostsBeehive)
  Future<HttpResponse> myPostsBeehive(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);

  @GET(LMCEndpoints.mySavedPosts)
  Future<HttpResponse> mySavedPosts(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);

  @GET(LMCEndpoints.getbeehiveCategories)
  Future<HttpResponse> getBeehiveCategories();

  @POST(LMCEndpoints.uploadBeehive)
  Future<Map<String, dynamic>> uploadBeehive(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);

  @POST(LMCEndpoints.saveOrLikePost)
  Future<HttpResponse<dynamic>> saveOrLikePost(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);
}
