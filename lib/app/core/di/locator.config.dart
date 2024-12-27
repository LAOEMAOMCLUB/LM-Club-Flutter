// locatorConfigPage this page like depenency injection we can call our bloc page as dynamic in whole application.

import 'package:dio/dio.dart' as i7;
import 'package:get_it/get_it.dart' as i1;
import 'package:injectable/injectable.dart' as i2;
import 'package:lm_club/app/data/api_services/broadcast_service.dart' as i11;
import 'package:lm_club/app/data/api_services/coupons_service.dart' as i13;
import 'package:lm_club/app/data/api_services/notification_service.dart' as i36;
import 'package:lm_club/app/data/api_services/refer_earn_service.dart' as i29;
import 'package:lm_club/app/data/api_services/shared/enroll_service.dart' as i9;
import 'package:lm_club/app/core/di/logging_service.dart' as i10;
import 'package:lm_club/app/core/di/third_party_service_module.dart' as i5;
import 'package:lm_club/app/data/api_services/shared/forgot_password_service.dart'
    as i24;
import 'package:lm_club/app/data/api_services/shared/login_service.dart' as i17;
import 'package:lm_club/app/data/api_services/widget_service.dart' as i19;
import 'package:lm_club/app/domain/auth/auth_repository_impl.dart' as i8;

import 'package:lm_club/app/domain/usecase/home/home_usecase.dart' as i4;
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart' as i6;
import 'package:lm_club/app/home/bloc/home_bloc.dart' as i20;
import 'package:lm_club/app/presentation/brodcast/bloc/broadcast_bloc.dart'
    as i12;
import 'package:lm_club/app/presentation/business_module/business-broadcast/bloc/businessbroadcast_bloc.dart'
    as i27;
import 'package:lm_club/app/presentation/business_module/business/bloc/business_enroll_bloc.dart'
    as i34;
import 'package:lm_club/app/presentation/business_module/business_profile/bloc/business_profile.bloc.dart'
    as i28;

import 'package:lm_club/app/presentation/choose_plan/bloc/choose_plan_bloc.dart'
    as i15;
import 'package:lm_club/app/presentation/choose_plan/bloc/plan_details_bloc.dart'
    as i16;
import 'package:lm_club/app/presentation/coupons/bloc/coupon_bloc.dart' as i14;
import 'package:lm_club/app/presentation/enroll/bloc/enroll_bloc.dart' as i3;
import 'package:lm_club/app/presentation/forgot-password/bloc/forgot_password_bloc.dart'
    as i23;
import 'package:lm_club/app/presentation/notification/bloc/notification_bloc.dart'
    as i35;
import 'package:lm_club/app/presentation/otp/bloc/otp_bloc.dart' as i25;
import 'package:lm_club/app/presentation/refer/bloc/refer_bloc.dart' as i30;
import 'package:lm_club/app/presentation/rewards/bloc/rewards_bloc.dart' as i31;
import 'package:lm_club/app/presentation/signin/bloc/sign_in_bloc.dart' as i18;

import '../../data/api_services/shared/beehive_service.dart' as i32;
import '../../domain/local_storage/shared_pref_repository.dart' as i22;
import '../../presentation/beehive/bloc/beehive_bloc.dart' as i33;
import '../../presentation/paypal/bloc/paypal_bloc.dart' as i26;
import '../../presentation/profile/profile_bloc.dart' as i21;

/// initializes the registration of provided dependencies inside of [GetIt]
///
i1.GetIt $initGetIt(
  i1.GetIt get, {
  String? environment,
  i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.singleton<i22.SharedPrefRepository>(
      () => thirdPartyServicesModule.sharedPrefRepo);
  gh.singleton<i8.AuthRepoImplementation>(
      () => thirdPartyServicesModule.authRepo);
  gh.lazySingleton<i7.Dio>(() => thirdPartyServicesModule.dio);
  gh.singleton<i6.HomeUsecase>(() => thirdPartyServicesModule.homeUseCase);
  gh.singleton<i10.LoggingService>(
      () => thirdPartyServicesModule.loggerService);
  gh.singleton<i9.EnrollService>(() => thirdPartyServicesModule.enrollService);
  gh.singleton<i11.BroadcastService>(
      () => thirdPartyServicesModule.broadcastService);
  gh.factory<i3.EnrollBloc>(() => i3.EnrollBloc(get<i4.HomeUsecase>()));
  gh.factory<i12.BroadcastBloc>(() => i12.BroadcastBloc(get<i4.HomeUsecase>()));

  gh.singleton<i13.CouponsService>(
      () => thirdPartyServicesModule.couponsService);

  gh.factory<i14.CouponsBloc>(() => i14.CouponsBloc(get<i4.HomeUsecase>()));

  gh.factory<i15.ChoosePlanBloc>(
      () => i15.ChoosePlanBloc(get<i4.HomeUsecase>()));
  gh.singleton<i17.LoginService>(() => thirdPartyServicesModule.loginService);
  gh.factory<i18.SignInBloc>(() => i18.SignInBloc(get<i4.HomeUsecase>()));
  gh.factory<i16.PlanDetailsBloc>(
      () => i16.PlanDetailsBloc(get<i4.HomeUsecase>()));

  gh.singleton<i19.WidgetsService>(
      () => thirdPartyServicesModule.widgetService);
  gh.factory<i20.HomeBloc>(() => i20.HomeBloc(get<i4.HomeUsecase>()));

  gh.factory<i21.ProfileBloc>(() => i21.ProfileBloc(get<i4.HomeUsecase>()));
  gh.factory<i23.ForgotPasswordBloc>(
      () => i23.ForgotPasswordBloc(get<i4.HomeUsecase>()));
  gh.singleton<i24.ForgotPasswordService>(
      () => thirdPartyServicesModule.forgotPasswordService);

  gh.factory<i25.OtpBloc>(() => i25.OtpBloc(get<i4.HomeUsecase>()));

  gh.factory<i26.PaypalBloc>(() => i26.PaypalBloc(get<i4.HomeUsecase>()));

  gh.factory<i27.BusinessBroadcastBloc>(
      () => i27.BusinessBroadcastBloc(get<i4.HomeUsecase>()));
  gh.factory<i28.BusinessProfileBloc>(
      () => i28.BusinessProfileBloc(get<i4.HomeUsecase>()));

  gh.singleton<i29.ReferEarnService>(
      () => thirdPartyServicesModule.referEarnService);
  gh.singleton<i32.BeehiveService>(
      () => thirdPartyServicesModule.beehiveService);

  gh.factory<i30.ReferEarnBloc>(() => i30.ReferEarnBloc(get<i4.HomeUsecase>()));
  gh.factory<i31.RewardsBloc>(() => i31.RewardsBloc(get<i4.HomeUsecase>()));
  gh.factory<i33.BeehiveBloc>(() => i33.BeehiveBloc(get<i4.HomeUsecase>()));
  gh.factory<i34.BusinessEnrollBloc>(
      () => i34.BusinessEnrollBloc(get<i4.HomeUsecase>()));
  gh.factory<i35.NotificationBloc>(
      () => i35.NotificationBloc(get<i4.HomeUsecase>()));

  gh.singleton<i36.NotificationService>(
      () => thirdPartyServicesModule.notificationService);
  return get;
}

class _$ThirdPartyServicesModule extends i5.ThirdPartyServicesModule {}
