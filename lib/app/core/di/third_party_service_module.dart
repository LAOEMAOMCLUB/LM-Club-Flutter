import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lm_club/app/data/api_services/broadcast_service.dart';
import 'package:lm_club/app/data/api_services/coupons_service.dart';
import 'package:lm_club/app/data/api_services/notification_service.dart';
import 'package:lm_club/app/data/api_services/refer_earn_service.dart';
import 'package:lm_club/app/data/api_services/shared/choose_plan_service.dart';
import 'package:lm_club/app/data/api_services/shared/enroll_service.dart';
import 'package:lm_club/app/data/api_services/shared/forgot_password_service.dart';
import 'package:lm_club/app/data/api_services/shared/login_service.dart';
import 'package:lm_club/app/data/api_services/widget_service.dart';
import 'package:lm_club/app/data/dio/dio_factory.dart';
import 'package:lm_club/app/domain/auth/auth_repository_impl.dart';
import 'package:lm_club/app/domain/local_storage/shared_pref_repository.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:lm_club/app/repositories/local_storage/shared_pref_respository.dart';
import 'package:lm_club/constants/endpoints.dart';
import '../../data/api_services/shared/beehive_service.dart';
import 'logging_service.dart';

@module
abstract class ThirdPartyServicesModule {
  @lazySingleton
  Dio get dio => DioFactory(LMCEndpoints.baseUrl).create();

  @singleton
  EnrollService get enrollService => EnrollService(dio);

  @singleton
  BroadcastService get broadcastService => BroadcastService(dio);
  @singleton
  CouponsService get couponsService => CouponsService(dio);

  @singleton
  ChoosePlanService get choosePlanService => ChoosePlanService(dio);

  @singleton
  LoggingService get loggerService => LoggingService();
  @singleton
  LoginService get loginService => LoginService(dio);
  @singleton
  WidgetsService get widgetService => WidgetsService(dio);

  @singleton
  ReferEarnService get referEarnService => ReferEarnService(dio);

  @singleton
  BeehiveService get beehiveService => BeehiveService(dio);

  @singleton
  ForgotPasswordService get forgotPasswordService => ForgotPasswordService(dio);

  @singleton
  NotificationService get notificationService => NotificationService(dio);
  @singleton
  SharedPrefRepository get sharedPrefRepo => SharedPrefRepositoryImpl();

  @singleton
  AuthRepoImplementation get authRepo => AuthRepoImplementation(
      enrollService,
      broadcastService,
      couponsService,
      choosePlanService,
      loginService,
      widgetService,
      sharedPrefRepo,
      forgotPasswordService,
      beehiveService,
      referEarnService,
      notificationService);

  @singleton
  HomeUsecase get homeUseCase => HomeUsecase(authRepo);
}
