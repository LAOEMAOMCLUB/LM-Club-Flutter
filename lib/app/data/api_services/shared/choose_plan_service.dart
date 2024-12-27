// chooseplanService this page is used to make baseUrl call by defining a method to make API service call.

import 'package:dio/dio.dart';
import 'package:lm_club/constants/endpoints.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';

part 'choose_plan_service.g.dart';

@RestApi()
abstract class ChoosePlanService {
  factory ChoosePlanService(Dio dio) = _ChoosePlanService;

  @GET(LMCEndpoints.getAllPlans)
  Future<HttpResponse> getAllPlans();

  @GET(LMCEndpoints.getplan)
  Future<HttpResponse> getplan(String id);
}
