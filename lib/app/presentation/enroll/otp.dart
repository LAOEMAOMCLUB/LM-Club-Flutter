// OtpPage this page is used to enter recived otp after Enroll

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/models/auth/shipping_address.dart';
import 'package:lm_club/app/presentation/enroll/bloc/enroll_bloc.dart';
import 'package:lm_club/app/presentation/enroll/bloc/enroll_state.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lm_club/utils/globals.dart' as globals;
import 'package:qlevar_router/qlevar_router.dart';
import 'package:pinput/pinput.dart';
// import 'package:flutter_braintree/flutter_braintree.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key, required this.subscriptionFee}) : super(key: key);

  final String subscriptionFee;
  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final EnrollBloc _enrollBloc = getIt.get<EnrollBloc>();
  final String subscriptionFee =
      QR.params.asMap["subscriptionFee"]?.value as String;
  static const fillColor = Colors.transparent;
  static const borderColor = Color.fromRGBO(128, 128, 156, 1);

  final defaultPinTheme = const PinTheme(
    width: 50,
    height: 50,
    textStyle: TextStyle(
      fontSize: 22,
      color: Colors.black,
    ),
    decoration: BoxDecoration(
        border: Border(
      bottom: BorderSide(
        color: borderColor,
        width: 2.0, // Adjust the width as needed
      ),
    )),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _enrollBloc,
        child: BlocConsumer<EnrollBloc, EnrollState>(
            listener: (context, state) async {
          if (state.isSuccesful!) {
            if (subscriptionFee == '0') {
              QR.navigator.replaceAllWithName(
                Routes.DASHBOARD.name,
              );
            } else {
              QR.toName(Routes.PAYPAL.name, params: {
                'amount': subscriptionFee,
                'shipping_address': QR.params.asMap["shipping_address"]?.value
                    as ShippingAddress
              });
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color.fromRGBO(55, 74, 156, 1),
                content: Center(
                  child: Text(
                    state.otpMessage!,
                    style: const TextStyle(
                      color: Color.fromRGBO(235, 237, 245, 1),
                      fontSize: 16,
                    ),
                  ),
                ),
                duration: const Duration(seconds: 2),
              ),
            );

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => Paypal(amount: subscriptionFee)),
            // );
            _enrollBloc.disposeControllers();
          } else if (state.message!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor:
                    Colors.red, // Change background color of SnackBar
                content: Center(
                  child: Text(
                    state.message!,
                    style: const TextStyle(
                      color:
                          Colors.white, // Change text color of SnackBar content
                      fontSize: 16, // Change font size of SnackBar content
                      // Add other text styles as needed
                    ),
                  ),
                ),
                duration:
                    const Duration(seconds: 3), // Adjust duration as needed
              ),
            );
          } else if (state.error!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor:
                    Colors.red, // Change background color of SnackBar
                content: Center(
                  child: Text(
                    state.error!,
                    style: const TextStyle(
                      color:
                          Colors.white, // Change text color of SnackBar content
                      fontSize: 16, // Change font size of SnackBar content
                      // Add other text styles as needed
                    ),
                  ),
                ),
                duration:
                    const Duration(seconds: 3), // Adjust duration as needed
              ),
            );
          }
        }, builder: (context, state) {
          return Stack(children: [
            Scaffold(
              backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
              // appBar: AppBar(
              //   backgroundColor: Colors.transparent,
              //   elevation: 3,
              //   shadowColor: const Color.fromRGBO(0, 0, 0, 0.16),
              //   flexibleSpace: Container(
              //     decoration: const BoxDecoration(
              //       gradient: LinearGradient(
              //         colors: [
              //           Color.fromRGBO(12, 57, 131, 1),
              //           Color.fromRGBO(0, 176, 80, 1),
              //         ],
              //         begin: Alignment.centerLeft,
              //         end: Alignment.centerRight,
              //       ),
              //       borderRadius: BorderRadius.only(
              //         bottomLeft: Radius.circular(25),
              //         bottomRight: Radius.circular(25),
              //       ),
              //     ),
              //     child: const Padding(
              //       padding: EdgeInsets.only(top: 20.0),
              //       child: Center(
              //         child: Text(
              //           'Enter Verification Code',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 16,
              //             fontFamily: 'NeueHaasGroteskTextPro',
              //             fontWeight: FontWeight.w900,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              //   leading: IconButton(
              //     icon: const Icon(Icons.arrow_back, color: Colors.white),
              //     onPressed: () {
              //       Navigator.pop(context);
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => Enroll(id: globals.planId)),
              //       );
              //     },
              //   ),
              // ),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(76.0),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(12, 57, 131, 1),
                        Color.fromRGBO(0, 176, 80, 1),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        blurRadius: 15.0,
                        spreadRadius: 10.0,
                      ),
                    ],
                  ),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        QR.back();
                        // Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => Enroll(id: globals.planId)),
                        // );
                      },
                    ),
                    title: const Text(
                      'Enter Verification Code',
                      style: TextStyle(
                        color: Color.fromRGBO(238, 238, 238, 1),
                        fontSize: 16,
                        fontFamily: 'NeueHaasGroteskTextPro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    centerTitle: false,
                    elevation: 0,
                  ),
                ),
              ),
              body: Center(
                child: Form(
                    key: _enrollBloc.otpFormKey,
                    child: SizedBox(
                        width: 275,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "******",
                              style: TextStyle(
                                fontSize: 27,
                                fontFamily: 'NeueHaasGroteskTextPro',
                                fontWeight: FontWeight.w900,
                                color: Color.fromRGBO(12, 57, 131, 1),
                              ),
                            ),
                            const SizedBox(height: 11),
                            Text(
                              "We have sent you an SMS on ${globals.mobile} with 6-digit verification code.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'NeueHaasGroteskTextPro',
                                fontWeight: FontWeight.normal,
                                color: Color.fromRGBO(35, 44, 58, 1),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Directionality(
                              // Specify direction if desired
                              textDirection: TextDirection.ltr,
                              child: Pinput(
                                pinputAutovalidateMode:
                                    PinputAutovalidateMode.disabled,
                                length: 6,
                                controller: _enrollBloc.pinController,
                                focusNode: _enrollBloc.focusNode,
                                defaultPinTheme: defaultPinTheme,
                                separatorBuilder: (index) =>
                                    const SizedBox(width: 8),
                                validator: (value) {
                                  return null;
                                },
                                hapticFeedbackType:
                                    HapticFeedbackType.lightImpact,
                                onCompleted: (pin) {
                                  debugPrint('onCompleted: $pin');
                                },
                                onChanged: (value) {
                                  debugPrint('onChanged: $value');
                                },
                                focusedPinTheme: defaultPinTheme.copyWith(
                                  decoration:
                                      defaultPinTheme.decoration!.copyWith(),
                                ),
                                submittedPinTheme: defaultPinTheme.copyWith(
                                  decoration:
                                      defaultPinTheme.decoration!.copyWith(
                                    color: fillColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () {
                                _enrollBloc.verifyOtp(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(55, 74, 156, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                elevation: 4,
                              ),
                              child: const SizedBox(
                                width: 150,
                                height: 42,
                                child: Center(
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontFamily: "NeueHaasGroteskTextPro",
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Did not receive the code? ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _enrollBloc.resendOtp();
                                  },
                                  child: const Text(
                                    "Resend Code",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(55, 74, 156, 1),
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ))),
              ),
            ),
            if (state.isLoading)
              Container(
                color: Colors.transparent
                    .withOpacity(0.2), // Semi-transparent black overlay
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.hexagonDots(
                        size: 35,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 10), // Adjust spacing if needed
                      const Text(
                        'Loading, please wait ...',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'NeueHaasGroteskTextPro',
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
              ),
          ]);
        }));
  }
}
