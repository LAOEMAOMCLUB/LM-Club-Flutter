// planStatus this page show a poup that your plan hasbeen expired please renivew plan

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/home/home.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/home/bloc/home_bloc.dart';
import 'package:lm_club/app/home/bloc/home_state.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:lm_club/utils/globals.dart' as globals;

class PlanStatus extends StatelessWidget {
  const PlanStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = getIt.get<HomeBloc>();
    return BlocProvider(
      create: (context) => homeBloc..getUserDetails(globals.userId),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              body: !state.isLoading
                  ? AlertDialog(
                      title: const Text('Plan Status'),
                      content: Text(
                        state.userDetails!.planMessage!,
                        style: const TextStyle(
                          fontSize: 13.0,
                          fontFamily: 'NeueHaasGroteskTextPro',
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(35, 44, 58, 1),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            QR.back();
                            QR.to(Routes.SIGN_IN);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    )
                  : const Home());
        },
      ),
    );
  }
}
