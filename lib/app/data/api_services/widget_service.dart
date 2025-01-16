// widgetServicePage this page is used to make baseUrl call by defining a method to make API service call.

import 'package:dio/dio.dart';
import 'package:lm_club/constants/endpoints.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';

part 'widget_service.g.dart';

@RestApi()
abstract class WidgetsService {
  factory WidgetsService(Dio dio) = _WidgetsService;

  @GET(LMCEndpoints.getWidgets)
  Future<HttpResponse> getWidgets(String id);
}
