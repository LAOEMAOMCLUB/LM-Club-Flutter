// paypalPage this page is used to make payments

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/models/auth/shipping_address.dart';
import 'package:lm_club/app/presentation/paypal/bloc/paypal_bloc.dart';
import 'package:lm_club/app/presentation/paypal/bloc/paypal_state.dart';
import 'package:lm_club/constants/endpoints.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../business_module/business-broadcast/pages/broadcast_paypal.dart';

class Paypal extends StatefulWidget {
  const Paypal({Key? key, required this.amount}) : super(key: key);
  final String amount;

  @override
  State<Paypal> createState() => _MyPaypalState();
}

class _MyPaypalState extends State<Paypal> {
  final PaypalBloc _paypalBloc = getIt.get<PaypalBloc>();

  bool isLightTheme = false;
  final String amount = QR.params.asMap["amount"]?.value as String;
  final ShippingAddress shippingAddress =
      QR.params.asMap["shipping_address"]?.value as ShippingAddress;

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
      print(widget.amount);
    }

    // final String amount = widget.amount;
    const String renewalRegistrationAmount = "60";

    // Convert to numeric types
    final double amountDouble = double.parse(amount);
    final double renewalRegistrationAmountDouble =
        double.parse(renewalRegistrationAmount);

    // Add the amounts
    final double totalAmount = amountDouble + renewalRegistrationAmountDouble;

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
                showAlertDialog(state.message ?? '');
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
                        (amountDouble + renewalRegistrationAmountDouble)
                            .toString(),
                        'Renewal/Registration Amount',
                        [
                          {
                            "name": 'Subscription',
                            "quantity": 1,
                            "price": amountDouble,
                            "currency": "USD"
                          },
                          {
                            "name": 'Renewal/Registration Amount',
                            "quantity": 1,
                            "price": renewalRegistrationAmountDouble,
                            "currency": "USD"
                          }
                        ],
                        shippingAddress),
                    note: "Contact us for any questions on your order.",
                    onSuccess: (Map params) async {
                      log("onSuccess: $params");
                      _paypalBloc.checkout(totalAmount.toString());
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

  void showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Status'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                QR.navigator.replaceAllWithName(
                  Routes.DASHBOARD.name,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
