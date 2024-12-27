// mainPage this is the main page for application (rootPage).

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lm_club/app/data/api_services/broadcast_service.dart';
import 'package:lm_club/app/data/api_services/shared/choose_plan_service.dart';
import 'package:lm_club/app/data/dio/dio_factory.dart';
import 'package:lm_club/app/models/auth/response_model/choose_plan_response.dart';
import 'package:lm_club/app/models/auth/response_model/custom_settings.dart';
import 'package:lm_club/constants/endpoints.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/core/di/locator.dart' as di;
import 'package:lm_club/utils/globals.dart' as globals;
import 'routes/app_routes.dart';
import 'routes/routers/initial_router.dart';

bool isLogin = false;
bool isFirstSeen = true;
Future<void> main() async {
  await di.init();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getString('token')?.isNotEmpty ?? false;
    isFirstSeen = prefs.getBool('first_seen') ?? true;
    await prefs.setBool('first_seen', false);

    if (prefs.containsKey('userName')) {
      globals.userName = prefs.getString('userName')!;
    }
    if (prefs.containsKey('userId')) {
      globals.userId = prefs.getString('userId')!;
    }
    final response =
        await BroadcastService(DioFactory(LMCEndpoints.baseUrl).create())
            .customSettings();
    CustomSettings subscriptionSettings =
        response.firstWhere((set) => set.flag == 'Subscription Flag');
    if (subscriptionSettings.key != null &&
        subscriptionSettings.key!.isNotEmpty) {
      globals.subscription = subscriptionSettings.key == 'true';
      if (subscriptionSettings.key == 'false') {
        final response =
            await ChoosePlanService(DioFactory(LMCEndpoints.baseUrl).create())
                .getAllPlans();
        List<ChoosePlanModal> plans =
            ChoosePlanResponse.fromMap(response.data).data;
        ChoosePlanModal freePlan =
            plans.firstWhere((plan) => plan.plan == 'FREE');
        if (freePlan.id >= 0) {
          globals.planId = freePlan.id.toString();
        }
      }
    }
    CustomSettings broadcastSettings =
        response.firstWhere((set) => set.flag == 'Broadcast Flag');
    if (broadcastSettings.key != null && broadcastSettings.key!.isNotEmpty) {
      globals.broadcast = broadcastSettings.key == 'true';
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'LM Club',
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(routes,
          initPath: isLogin
              ? Routes.DASHBOARD
              : isFirstSeen
                  ? Routes.SPLASH
                  : Routes.SIGN_IN,
          navKey: rootNavigatorKey),
    );
  }
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
