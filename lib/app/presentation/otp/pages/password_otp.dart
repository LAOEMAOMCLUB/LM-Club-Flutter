// passwordOtpPage here we can enter recived otp.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/presentation/otp/bloc/otp_bloc.dart';
import 'package:lm_club/app/presentation/otp/bloc/otp_state.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lm_club/utils/globals.dart' as globals;
import 'package:qlevar_router/qlevar_router.dart';

class PasswordOtp extends StatefulWidget {
  const PasswordOtp({Key? key}) : super(key: key);

  @override
  State<PasswordOtp> createState() => _PasswordOtpState();
}

class _PasswordOtpState extends State<PasswordOtp> {
  final OtpBloc _otpBloc = getIt.get<OtpBloc>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _otpBloc,
        child: BlocConsumer<OtpBloc, OtpState>(listener: (context, state) {
          if (state.isSuccesful!) {
            QR.to(Routes.RESET_PASSWORD);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ResetPassword()),
            // );
            _otpBloc.disposeControllers();
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
                    key: _otpBloc.otpFormKey,
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
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 37,
                                    height: 37,
                                    child: TextFormField(
                                      maxLength: 1,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromRGBO(35, 44, 58, 1),
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w900),
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      controller: _otpBloc.otpController1,
                                      onChanged: (value) {
                                        if (value.length == 1) {
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                        counterText: "",
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                116, 116, 116, 1),
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                116, 116, 116, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 37,
                                    height: 37,
                                    child: TextFormField(
                                      maxLength: 1,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromRGBO(35, 44, 58, 1),
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w900),
                                      keyboardType: TextInputType.number,
                                      controller: _otpBloc.otpController2,
                                      autofocus: true,
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          // Clear the field and move focus to the previous field
                                          _otpBloc.otpController2.clear();
                                          FocusScope.of(context)
                                              .previousFocus();
                                        } else if (value.length == 1) {
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                        counterText: "",
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                116, 116, 116, 1),
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                116, 116, 116, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 37,
                                    height: 37,
                                    child: TextFormField(
                                      maxLength: 1,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromRGBO(35, 44, 58, 1),
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w900),
                                      keyboardType: TextInputType.number,
                                      controller: _otpBloc.otpController3,
                                      autofocus: true,
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          // Clear the field and move focus to the previous field
                                          _otpBloc.otpController3.clear();
                                          FocusScope.of(context)
                                              .previousFocus();
                                        } else if (value.length == 1) {
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                        counterText: "",
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                116, 116, 116, 1),
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                116, 116, 116, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 37,
                                    height: 37,
                                    child: TextFormField(
                                      maxLength: 1,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromRGBO(35, 44, 58, 1),
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w900),
                                      keyboardType: TextInputType.number,
                                      controller: _otpBloc.otpController4,
                                      autofocus: true,
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          // Clear the field and move focus to the previous field
                                          _otpBloc.otpController4.clear();
                                          FocusScope.of(context)
                                              .previousFocus();
                                        } else if (value.length == 1) {
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                        counterText: "",
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                116, 116, 116, 1),
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                116, 116, 116, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 37,
                                    height: 37,
                                    child: TextFormField(
                                      maxLength: 1,
                                      autofocus: true,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromRGBO(35, 44, 58, 1),
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w900),
                                      keyboardType: TextInputType.number,
                                      controller: _otpBloc.otpController5,
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          // Clear the field and move focus to the previous field
                                          _otpBloc.otpController5.clear();
                                          FocusScope.of(context)
                                              .previousFocus();
                                        } else if (value.length == 1) {
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                        counterText: "",
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                116, 116, 116, 1),
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                116, 116, 116, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 37,
                                    height: 37,
                                    child: TextFormField(
                                      maxLength: 1,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromRGBO(35, 44, 58, 1),
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w900),
                                      keyboardType: TextInputType.number,
                                      controller: _otpBloc.otpController6,
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          // Clear the field and move focus to the previous field
                                          _otpBloc.otpController6.clear();
                                          FocusScope.of(context)
                                              .previousFocus();
                                        }
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                        counterText: "",
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                116, 116, 116, 1),
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                116, 116, 116, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]

                                // List.generate(
                                //   4,
                                //   (index) => const  SizedBox(
                                //     width: 37,
                                //     height: 37,
                                //     child: TextFormField(
                                //       maxLength: 1,
                                //       textAlign: TextAlign.center,
                                //       style:  TextStyle(
                                //           fontSize: 16,
                                //           color: Colors.white,
                                //           fontFamily: 'NeueHaasGroteskTextPro',
                                //           fontWeight: FontWeight.w900),
                                //       keyboardType: TextInputType.number,
                                //      // controller: _otpBloc.otpController,
                                //       //   validator: (value) {
                                //       //   if (value == null || value.isEmpty) {
                                //       //     return 'Please enter otp';
                                //       //   }
                                //       //   return null;
                                //       // },
                                //       decoration:const InputDecoration(
                                //         counterText: "",
                                //         focusedBorder: UnderlineInputBorder(
                                //           borderSide: BorderSide(
                                //             color: Color.fromRGBO(0, 176, 80, 1),
                                //           ),
                                //         ),
                                //         enabledBorder: UnderlineInputBorder(
                                //           borderSide: BorderSide(
                                //             color: Color.fromRGBO(116, 116, 116, 1),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () {
                                _otpBloc.verifyOtp();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(55, 74, 156, 1),
                                  // gradient: const LinearGradient(
                                  //   colors: [
                                  //     Color.fromRGBO(148, 197, 115, 1),
                                  //     Color.fromRGBO(75, 116, 48, 1)
                                  //   ],
                                  //   begin: Alignment.topCenter,
                                  //   end: Alignment.bottomCenter,
                                  // ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Container(
                                  width: 150,
                                  height: 42,
                                  padding: const EdgeInsets.all(12),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                    ),
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
                                    _otpBloc.forgotPassword();
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
