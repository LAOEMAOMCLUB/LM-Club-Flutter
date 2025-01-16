// forgotPasswordPage when user or businessUser forgots password (here we set new password by entering enrolled mobileNumber).

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/presentation/forgot-password/bloc/forgot_password_bloc.dart';
import 'package:lm_club/app/presentation/forgot-password/bloc/forgot_password_state.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final ForgotPasswordBloc _forgotPasswordBloc =
      getIt.get<ForgotPasswordBloc>();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
        create: (context) => _forgotPasswordBloc,
        child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
          if (state.isSuccesful!) {
            _forgotPasswordBloc.disposeControllers();
            QR.to(Routes.PASSWORD_OTP);
            // _forgotPasswordBloc.webFormKey.currentState!.reset();
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
                body: Container(
                    width: screenWidth,
                    height: screenHeight,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/splash.png"),
                          fit: BoxFit.cover),
                    ),
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'The Membership\nClub Ever!',
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 24.0,
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Image.asset(
                                  "assets/images/logo1.png",
                                  width: 113,
                                  height: 73,
                                  alignment: Alignment.center,
                                ),
                              ],
                            )),
                            Container(
                                padding: const EdgeInsets.all(20),
                                margin:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 60),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Form(
                                  key: _forgotPasswordBloc.webFormKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Forgot Password ?",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromRGBO(1, 51, 51, 1),
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 30),
                                        child: const Text(
                                          "Enter your phone number to receive verification code",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color.fromRGBO(
                                                106, 106, 106, 1),
                                            fontFamily:
                                                'NeueHaasGroteskTextPro',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller:
                                            _forgotPasswordBloc.mobleController,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          _UsPhoneNumberFormatter(),
                                        ],
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Phone number is Required';
                                          } else if (value.length < 14) {
                                            return 'Enter a Valid 10 Digit Phone Number';
                                          }
                                          return null;
                                        },
                                        maxLength: 14,
                                        decoration: const InputDecoration(
                                          counterText: "",
                                          labelText: 'Phone Number',
                                          errorStyle: TextStyle(fontSize: 13.0),
                                          hintStyle: TextStyle(
                                              fontSize: 13,
                                              color:
                                                  Color.fromRGBO(27, 27, 27, 1),
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              fontWeight: FontWeight.w300),
                                          labelStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  106, 106, 106, 1),
                                              fontSize: 13,
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              fontWeight: FontWeight.w500),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  204, 204, 204, 1),
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  204, 204, 204, 1),
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: Color.fromRGBO(27, 27, 27, 1),
                                          fontSize: 13,
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              QR.back();
                                            },
                                            child: Container(
                                              height: 42,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 20, 0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'NeueHaasGroteskTextPro',
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        35, 44, 58, 1)),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  55, 74, 156, 1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _forgotPasswordBloc
                                                    .forgotPassword();
                                                _forgotPasswordBloc
                                                    .webFormKey.currentState!
                                                    .reset();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets
                                                    .zero, // Ensure no internal padding inside the button
                                                minimumSize:
                                                    const Size(100, 42),
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              child: const Text(
                                                'Continue',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        )))),
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

String capitalize(String s) =>
    s[0].toUpperCase() + s.substring(1).toLowerCase();

class _UsPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Extract only digits from the input
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // If more than 10 digits are entered, truncate the input
    if (digitsOnly.length > 10) {
      digitsOnly = digitsOnly.substring(0, 10);
    }

    // Format the phone number (e.g., (555) 555-1234)
    String formattedValue = _formatPhoneNumber(digitsOnly);

    // Create a new TextEditingValue with the formatted number
    TextEditingValue newFormattedValue = newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.fromPosition(
        TextPosition(offset: formattedValue.length),
      ),
    );

    return newFormattedValue;
  }

  String _formatPhoneNumber(String number) {
    // Add formatting to match (555) 555-1234 pattern
    if (number.length > 6) {
      return '(${number.substring(0, 3)}) ${number.substring(3, 6)}-${number.substring(6, min(number.length, 10))}';
    } else if (number.length > 3) {
      return '(${number.substring(0, 3)}) ${number.substring(3)}';
    } else {
      return number;
    }
  }
}
