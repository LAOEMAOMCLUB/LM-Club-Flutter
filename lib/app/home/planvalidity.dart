// planValidityPage once plan validity expired we have to reniwal again if user enrolled with Free plan then he have to choose plans.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/home/home.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/home/bloc/home_bloc.dart';
import 'package:lm_club/app/home/bloc/home_state.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:lm_club/utils/globals.dart' as globals;

class PlanValidityPage extends StatelessWidget {
  const PlanValidityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = getIt.get<HomeBloc>();
    return BlocProvider(
      create: (context) => homeBloc..getUserDetails(globals.userId),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              backgroundColor: const Color.fromARGB(0, 197, 197, 197),
              body: !state.isLoading
                  ? Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 45),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 215, 243, 255),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/pop_bg.png',
                                  height: 100,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: state.userDetails!.subscription ==
                                              'FREE'
                                          ? RichText(
                                              text: const TextSpan(
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      78, 76, 117, 1),
                                                  fontSize: 14.0,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          'Your free trial has expired. To continue enjoying our features and redeem your reward points, please subscribe to one of our plans. Click '),
                                                  TextSpan(
                                                    text: 'Subscribe',
                                                    style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationColor:
                                                          Color.fromRGBO(
                                                              55, 74, 156, 1),
                                                      decorationThickness: 1.0,
                                                      color: Color.fromRGBO(
                                                          55,
                                                          74,
                                                          156,
                                                          1), // Optionally, you can change the color
                                                    ),
                                                    // recognizer: TapGestureRecognizer()..onTap = () {
                                                    //   // Handle the click event here
                                                    //   print('Subscribe tapped');
                                                    // },
                                                  ),
                                                  TextSpan(
                                                    text: ' to view options.',
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const Text(
                                              'Your Monthly subscription has expired. Renew today to keep enjoying all the benefits without interruption. Click "Renew" to continue with your plan.',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    78, 76, 117, 1),
                                                fontSize: 14.0,
                                                fontFamily:
                                                    'NeueHaasGroteskTextPro',
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Color.fromRGBO(
                                                    55, 74, 156, 1),
                                                decorationThickness: 1.0,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0, right: 18.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            QR.to(
                                              Routes.SIGN_IN,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3.0),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            elevation: 1,
                                          ),
                                          child: const SizedBox(
                                            height: 42,
                                            child: Center(
                                              child: Text(
                                                'CLOSE',
                                                style: TextStyle(
                                                  fontFamily:
                                                      "NeueHaasGroteskTextPro",
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            state.userDetails!.subscription ==
                                                    'FREE'
                                                ? QR.toName(
                                                    Routes.CHOOSE_PLAN.name,
                                                    params: {
                                                      'subscriptionPlan': state
                                                          .userDetails
                                                          ?.subscription
                                                    },
                                                  )
                                                : QR.toName(
                                                    Routes.RENIWALPLAN.name,
                                                    params: {
                                                      'id': state.userDetails
                                                          ?.subscriptionId!
                                                          .toString(),
                                                      'subscriptionPlan': ''
                                                    },
                                                  );
                                            // }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    55, 74, 156, 1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3.0),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            elevation: 1,
                                          ),
                                          child: SizedBox(
                                            height: 42,
                                            child: Center(
                                              child: Text(
                                                state.userDetails
                                                            ?.subscription ==
                                                        'FREE'
                                                    ? 'SUBSCRIBE'
                                                    : 'RENEW',
                                                style: const TextStyle(
                                                  fontFamily:
                                                      "NeueHaasGroteskTextPro",
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ]),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Home());
        },
      ),
    );
  }
}
