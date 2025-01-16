// reniwalpayPage once plan expires we have to reniwalPayment again here.

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/presentation/paypal/bloc/paypal_bloc.dart';
import 'package:lm_club/app/presentation/paypal/bloc/paypal_state.dart';
import 'package:lm_club/constants/endpoints.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../models/auth/shipping_address.dart';
import '../business_module/business-broadcast/pages/broadcast_paypal.dart';
import 'package:lm_club/utils/globals.dart' as globals;

class ReniwalPay extends StatefulWidget {
  const ReniwalPay(
      {Key? key,
      required this.reniwal,
      required this.planId,
      this.subscriptionPlan,
      this.registrationAmount})
      : super(key: key);
  final String reniwal;
  final String planId;
  final String? subscriptionPlan;
  final String? registrationAmount;
  @override
  State<ReniwalPay> createState() => _MyPaypalState();
}

class _MyPaypalState extends State<ReniwalPay> {
  final PaypalBloc _paypalBloc = getIt.get<PaypalBloc>();

  bool isLightTheme = false;
  final String reniwal = QR.params.asMap["reniwal"]?.value as String;
  final String planId = QR.params.asMap["planId"]?.value as String;
  final String subscriptionPlan =
      QR.params.asMap["subscriptionPlan"]?.value as String;
  final String registrationAmount =
      QR.params.asMap["registrationAmount"]?.value as String;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(widget.reniwal);
    }

    // final String amount = widget.amount;
    // const String renewalRegistrationAmount = "60";

    // Convert to numeric types
    final double amountDouble = double.parse(reniwal);
    // final double renewalRegistrationAmountDouble =
    //     double.parse(renewalRegistrationAmount);

    // Add the amounts
    final double totalAmount = amountDouble;

    // Print the result
    if (kDebugMode) {
      print("Total Amount: \$${totalAmount.toStringAsFixed(2)}");
    }
    SystemChrome.setSystemUIOverlayStyle(
      isLightTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      themeMode: isLightTheme ? ThemeMode.light : ThemeMode.dark,
      theme: ThemeData(
        textTheme: const TextTheme(
          // Text style for text fields' input.
          titleMedium: TextStyle(color: Colors.black, fontSize: 18),
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.white,
          background: Colors.black,
          // Defines colors like cursor color of the text fields.
          primary: Colors.black,
        ),
        // Decoration theme for the text fields.
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.black),
          labelStyle: const TextStyle(color: Colors.black),
          focusedBorder: border,
          enabledBorder: border,
        ),
      ),
      darkTheme: ThemeData(
        textTheme: const TextTheme(
          // Text style for text fields' input.
          titleMedium: TextStyle(color: Colors.black, fontSize: 18),
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.black,
          background: Colors.white,
          // Defines colors like cursor color of the text fields.
          primary: Colors.white,
        ),
        // Decoration theme for the text fields.
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Color.fromARGB(255, 28, 27, 27)),
          labelStyle: const TextStyle(color: Color.fromARGB(255, 28, 27, 27)),
          focusedBorder: border,
          enabledBorder: border,
        ),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text("Alert",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'NeueHaasGroteskTextPro',
                              color: Color.fromRGBO(55, 74, 156, 1),
                            )),
                        content: const Text("Are you sure you want to go back?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'NeueHaasGroteskTextPro',
                              color: Color.fromRGBO(35, 44, 58, 1),
                            )),
                        actions: [
                          TextButton(
                            child: const Text("Yes",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  color: Color.fromRGBO(35, 44, 58, 1),
                                )),
                            onPressed: () {
                              QR.back();
                              QR.back();
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             Enroll(id: globals.planId)));
                            },
                          ),
                          TextButton(
                            child: const Text("Cancel",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  color: Color.fromRGBO(35, 44, 58, 1),
                                )),
                            onPressed: () {
                              // Navigator.of(context).pop();
                              QR.back();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              title: const Text(
                'Checkout',
                style: TextStyle(
                  color: Color.fromRGBO(238, 238, 238, 1),
                  fontSize: 18,
                  fontFamily: 'NeueHaasGroteskTextPro',
                  fontWeight: FontWeight.w500,
                ),
              ),
              centerTitle: false,
              elevation: 0,
            ),
          ),
        ),
        body: BlocProvider(
            create: (context) => _paypalBloc,
            child: BlocConsumer<PaypalBloc, PaypalState>(
                listener: (context, state) {
              if (state.isSuccesful!) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color.fromARGB(255, 67, 194,
                        17), // Change background color of SnackBar
                    content: Center(
                      child: Text(
                        state.message!,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 28, 28,
                              28), // Change text color of SnackBar content
                          fontSize: 16, // Change font size of SnackBar content
                          // Add other text styles as needed
                        ),
                      ),
                    ),
                    duration:
                        const Duration(seconds: 2), // Adjust duration as needed
                  ),
                );
                QR.navigator.replaceAllWithName(
                  Routes.SIGN_IN.name,
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
                          color: Colors
                              .white, // Change text color of SnackBar content
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
              return GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Stack(children: [
                  PaypalCheckoutView(
                    sandboxMode: LMCEndpoints.sandboxMode,
                    clientId: LMCEndpoints.clientId,
                    secretKey: LMCEndpoints.secretKey,
                    transactions: getTransations(
                        reniwal,
                        'Renewal/Registration Amount',
                        [
                          {
                            "name": 'Renewal/Registration Amount',
                            "quantity": 1,
                            "price": reniwal,
                            "currency": "USD"
                          },
                        ],
                        ShippingAddress(
                            recipientName: globals.userName,
                            line1: globals.street,
                            city: globals.city,
                            postalCode: globals.zipcode,
                            phone: globals.mobile,
                            state: globals.state)),
                    note: "Contact us for any questions on your order.",
                    onSuccess: (Map params) async {
                      log("onSuccess: $params");
                      _paypalBloc.renewalPay(reniwal, planId);
                    },
                    onError: (error) {
                      log("onError: $error");
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                      QR.back();
                    },
                    onCancel: () {
                      if (kDebugMode) {
                        print('cancelled:');
                      }
                      QR.back();
                    },
                  )
                ]),
              );
            })),
      ),
    );
  }
}
