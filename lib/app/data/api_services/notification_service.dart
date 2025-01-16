// notificationServicePage this page is used to make baseUrl call by defining a method to make API service call.

import 'package:dio/dio.dart';
import 'package:lm_club/constants/endpoints.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';

part 'notification_service.g.dart';

@RestApi()
abstract class NotificationService {
  factory NotificationService(Dio dio) = _NotificationService;

  @GET(LMCEndpoints.getUserNotifications)
  Future<HttpResponse> getUserNotifications(
      @Header("x-access-code") String token);

  @GET(LMCEndpoints.viewNotification)
  Future<HttpResponse> viewNotification(
      @Header("x-access-code") String token, String id);
  @GET(LMCEndpoints.markAllAsRead)
  Future<HttpResponse> markAllAsRead(@Header("x-access-code") String token);
  @POST(LMCEndpoints.readOrDeleteNotifications)
  Future<HttpResponse<dynamic>> readOrDeleteNotifications(
      @Header("x-access-code") String token, @Body() Map<String, dynamic> data);
}
