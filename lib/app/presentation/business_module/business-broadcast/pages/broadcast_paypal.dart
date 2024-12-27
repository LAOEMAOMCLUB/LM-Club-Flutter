import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/models/auth/request_model/business_broadcast_request_model.dart';
import 'package:lm_club/app/models/auth/shipping_address.dart';
import 'package:lm_club/app/presentation/business_module/business-broadcast/bloc/businessbroadcast_bloc.dart';
import 'package:lm_club/app/presentation/business_module/business-broadcast/bloc/businessbroadcast_state.dart';
import 'package:lm_club/constants/endpoints.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:lm_club/utils/globals.dart' as globals;

class BusinessPaypal extends StatefulWidget {
  const BusinessPaypal({Key? key}) : super(key: key);
  @override
  State<BusinessPaypal> createState() => _MyBusinessPaypalState();
}

class _MyBusinessPaypalState extends State<BusinessPaypal> {
  final BusinessBroadcastBloc _businessBroadcastBloc =
      getIt.get<BusinessBroadcastBloc>();

  bool isLightTheme = false;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final String amount = QR.params.asMap["amount"]?.value as String;
  final String description = QR.params.asMap["description"]?.value as String;
  final BusinessBroadcastModel request =
      QR.params.asMap["request"]?.value as BusinessBroadcastModel;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      isLightTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );
    return BlocProvider(
        create: (context) => _businessBroadcastBloc,
        child: BlocConsumer<BusinessBroadcastBloc, BusinessBroadcastState>(
            listener: (context, state) {
          if (state.isSuccesful!) {
            QR.to(Routes.POST_SUCCESS);
          } else if (state.isSuccesfulPayment!) {
            // _businessBroadcastBloc.uploadBusinessBroadcast(widget.request);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color.fromARGB(
                    255, 67, 194, 17), // Change background color of SnackBar
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

            if (request.image != null) {
              _businessBroadcastBloc.uploadBusinessBroadcast(request);
            } else {
              _businessBroadcastBloc.editDraftBusinessBroadcast(request);
            }
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
          return Scaffold(
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
                              // QR.to(Routes.BROADCAST);
                              QR.back();
                              QR.back();
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
            body: PaypalCheckoutView(
            sandboxMode: LMCEndpoints.sandboxMode,
            clientId: LMCEndpoints.clientId,
            secretKey: LMCEndpoints.secretKey,
            transactions: getTransations(
                amount,
                description,
                [
                  {
                    "name": description,
                    "quantity": 1,
                    "price": amount,
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
              _businessBroadcastBloc.checkout(amount);
            },
            onError: (error) {
              log("onError: $error");
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error.toString())));
              QR.back();
            },
            onCancel: () {
              if (kDebugMode) {
                print('cancelled:');
              }
              QR.back();
            },
          ));
        }));
  }
}

List<dynamic> getTransations(String amount, String description,
    List<dynamic> items, ShippingAddress shippingAddress) {
  var transaction = {
    "amount": {
      "total": amount,
      "currency": "USD",
      "details": {"subtotal": amount, "shipping": '0', "shipping_discount": 0}
    },
    "description": description,
  };
  if (shippingAddress.recipientName != null &&
      shippingAddress.recipientName != '' &&
      shippingAddress.line1 != null &&
      shippingAddress.line1 != '' &&
      shippingAddress.city != null &&
      shippingAddress.city != '' &&
      shippingAddress.state != null &&
      shippingAddress.state != '' &&
      shippingAddress.postalCode != null &&
      shippingAddress.postalCode != '' &&
      shippingAddress.phone != null &&
      shippingAddress.phone != '') {
    transaction['item_list'] = {
      "items": items,
      'shipping_address': {
        "recipient_name": shippingAddress.recipientName,
        "line1": shippingAddress.line1,
        "line2": "",
        "city": shippingAddress.city,
        "country_code": "US",
        "postal_code": shippingAddress.postalCode,
        "phone": shippingAddress.phone,
        "state": shippingAddress.state
      }
    };
  } else {
    transaction['item_list'] = {
      "items": items,
    };
  }
  return [transaction];
}
