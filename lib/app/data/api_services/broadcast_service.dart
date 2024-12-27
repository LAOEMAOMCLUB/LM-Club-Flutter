// broadCastServicePage this page is used to make baseUrl call by defining a method to make API service call.

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lm_club/app/models/auth/response_model/custom_settings.dart';
import 'package:lm_club/constants/endpoints.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

part 'broadcast_service.g.dart';

@RestApi()
abstract class BroadcastService {
  factory BroadcastService(Dio dio) = _BroadcastService;

  // @POST(LMCEndpoints.uploadBroadcast)
  // Future<<Map<String, dynamic>> uploadBroadcast(@Body() Map<String, dynamic> data);

  @POST(LMCEndpoints.uploadBroadcast)
  Future<Map<String, dynamic>> uploadBroadcast(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);

  @POST(LMCEndpoints.sharePost)
  Future<HttpResponse<dynamic>> sharePost(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);

  @POST(LMCEndpoints.uploadBusinessBroadcast)
  Future<Map<String, dynamic>> uploadBusinessBroadcast(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);

  @POST(LMCEndpoints.generateAcceratedUrl)
  Future<HttpResponse> generateAcceratedUrl(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);

  @POST(LMCEndpoints.updateDraftBusinessBroadcast)
  Future<HttpResponse> updateDraftBusinessBroadcast(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);

  @GET(LMCEndpoints.getBroadcasts)
  Future<HttpResponse> getBroadcasts(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);
  @GET(LMCEndpoints.getMyBroadcasts)
  Future<HttpResponse> getMyBroadcasts(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);

  @GET(LMCEndpoints.getBroadcastPlans)
  Future<HttpResponse> getBroadcastPlans(@Header("x-access-code") String token);

  @GET(LMCEndpoints.myShares)
  Future<HttpResponse> myShares(@Header("x-access-code") String token);

  @GET(LMCEndpoints.viewBroadcastPost)
  Future<HttpResponse> viewBroadcastPost(
      @Header("x-access-code") String token, String id);
  @GET(LMCEndpoints.shareTypes)
  Future<HttpResponse> shareTypes(@Header("x-access-code") String token);

  @POST(LMCEndpoints.deleteFile)
  Future<HttpResponse> deleteFile(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);
  @DELETE(LMCEndpoints.deleteAccount)
  Future<HttpResponse> deleteAccount(@Header("x-access-code") String token);
  @GET(LMCEndpoints.customSettings)
  Future<List<CustomSettings>> customSettings();
}
