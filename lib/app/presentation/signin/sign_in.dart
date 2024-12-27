// loginPage once user or businessUser enrolled we can login here.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/models/auth/shipping_address.dart';

import 'package:lm_club/app/presentation/signin/bloc/sign_in_bloc.dart';
import 'package:lm_club/app/presentation/signin/bloc/sign_in_state.dart';
import 'package:lm_club/constants/string_constanta.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:lm_club/utils/globals.dart' as globals;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void dispose() {
    _signInBloc.emailController.clear();
    _signInBloc.passwordController.clear();
    _signInBloc.webFormKey.currentState?.reset();
    super.dispose();
  }

  final SignInBloc _signInBloc = getIt.get<SignInBloc>();
  bool _showPassword = false;
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
        create: (context) => _signInBloc,
        child:
            BlocConsumer<SignInBloc, SignInState>(listener: (context, state) {
          if (state.loginSuccesful!) {
            QR.navigator.replaceAllWithName(
              Routes.DASHBOARD.name,
            );
            _signInBloc.disposeControllers();
          } else if (state.message == Constants.notEnrolled) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Alert'),
                  content: Text(state.message ?? ''),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        globals.planId = state.data?.data.planId ?? '';
                        Navigator.pop(context);
                        var shippingAddress = ShippingAddress(
                            recipientName: state.data?.data.username ?? '',
                            line1: state.data?.data.street ?? '',
                            city: state.data?.data.city?.cityName ?? '',
                            postalCode: state.data?.data.zipcode ?? '',
                            phone: state.data?.data.mobile ?? '',
                            state: state.data?.data.state?.name ?? '');
                        QR.toName(Routes.PAYPAL.name, params: {
                          'amount': state.data?.data.planAmount,
                          'shipping_address': shippingAddress
                        });
                      },
                    ),
                  ],
                );
              },
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
          } else if (state.message!.isNotEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message!)));
            Navigator.pop(context);
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
                                const Flexible(
                                  child: Text(
                                    'The Membership\nClub Ever!',
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontSize: 24.0,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Image.asset(
                                  "assets/images/logo1.png",
                                  width: 113,
                                  height: 65,
                                  alignment: Alignment.center,
                                ),
                              ],
                            )),
                            Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                              ),
                              child: Form(
                                  key: _signInBloc.webFormKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        // isTapped
                                        //     ? 'Business User Login'
                                        //     :
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromRGBO(1, 51, 51, 1),
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText: 'Email is Required'),
                                          EmailValidator(
                                              errorText:
                                                  'Please Enter a Valid Email Address'),
                                        ]),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _signInBloc.emailController,
                                        decoration: const InputDecoration(
                                          //  hintText: 'victor@gmail.com',
                                          labelText: 'Email',
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
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText:
                                                  'Password is Required'),
                                        ]),
                                        controller:
                                            _signInBloc.passwordController,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _showPassword =
                                                    !_showPassword; // Toggle the password visibility
                                              });
                                            },
                                            child: Icon(
                                              _showPassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors
                                                  .grey, // Change color as needed
                                            ),
                                          ),
                                          errorStyle:
                                              const TextStyle(fontSize: 13.0),
                                          hintStyle: const TextStyle(
                                              fontSize: 13,
                                              color:
                                                  Color.fromRGBO(27, 27, 27, 1),
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              fontWeight: FontWeight.w300),
                                          labelStyle: const TextStyle(
                                              color: Color.fromRGBO(
                                                  106, 106, 106, 1),
                                              fontSize: 13,
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              fontWeight: FontWeight.w500),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  204, 204, 204, 1),
                                            ),
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
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
                                        obscureText: !_showPassword,
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
                                              QR.to(Routes.FORGOT_PASSWORD);

                                              _signInBloc.disposeControllers();
                                            },
                                            child: const Text(
                                              'Forgot Password?',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    55, 74, 156, 1),
                                                fontSize: 12,
                                                fontFamily:
                                                    'NeueHaasGroteskTextPro',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 42,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              color: const Color.fromRGBO(
                                                  55, 74, 156, 1),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.16),
                                                  blurRadius: 6.0,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _signInBloc.signIn();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets
                                                    .zero, // Ensure no internal padding inside the button
                                                minimumSize: const Size(100,
                                                    42), // Set a minimum size for the button
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                              ),
                                              child: const Text(
                                                'Login',
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
                                      const SizedBox(height: 25),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "Don't have an account ?",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                  fontSize: 14,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (globals.subscription) {
                                                    QR.toName(
                                                      Routes.CHOOSE_PLAN.name,
                                                      params: {
                                                        'subscriptionPlan': ''
                                                      },
                                                    );
                                                  } else {
                                                    QR.toName(
                                                        Routes.ENROLL.name,
                                                        params: {
                                                          'id': globals.planId
                                                        });
                                                  }
                                                  _signInBloc.emailController
                                                      .clear();
                                                  _signInBloc.passwordController
                                                      .clear();
                                                  _signInBloc
                                                      .webFormKey.currentState
                                                      ?.reset();
                                                },
                                                child: const Text(
                                                  "User Enroll",
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        55, 74, 156, 1),
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'NeueHaasGroteskTextPro',
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                        Color.fromRGBO(
                                                            55, 74, 156, 1),
                                                    decorationThickness: 2.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                isTapped = !isTapped;
                                                _signInBloc.emailController
                                                    .clear();
                                                _signInBloc.passwordController
                                                    .clear();
                                                _signInBloc
                                                    .webFormKey.currentState
                                                    ?.reset();
                                                QR.to(Routes.BUSINESS);
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      35, 44, 59, 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              elevation: 3,
                                            ),
                                            child: const SizedBox(
                                              // width: 169,
                                              height: 42,
                                              child: Center(
                                                child: Text(
                                                  // isTapped
                                                  //     ? 'USER LOGIN'
                                                  //     :

                                                  'BUSINESS USER ENROLL',

                                                  // 'USER LOGIN / ENROLL',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "NeueHaasGroteskTextPro",
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 1)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        )))),
            if (state.isLoading)
              Container(
                color: Colors.transparent
                    // ignore: deprecated_member_use
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
