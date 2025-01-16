// Here we can Enroll as user.

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/plan_details.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';
import 'package:lm_club/app/models/auth/shipping_address.dart';
import 'package:lm_club/app/presentation/enroll/bloc/enroll_bloc.dart';
import 'package:lm_club/app/presentation/enroll/bloc/enroll_state.dart';
import 'package:lm_club/constants/color_constants.dart';
import 'package:lm_club/constants/string_constanta.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:searchfield/searchfield.dart';
import 'package:lm_club/utils/globals.dart' as globals;

//import 'package:shared_preferences/shared_preferences.dart';

class Enroll extends StatefulWidget {
  const Enroll({super.key, required this.id});

  final String id;

  @override
  State<Enroll> createState() => _EnrollState();
}

class _EnrollState extends State<Enroll> {
  String errorText = '';
  // final String id = QR.params.asMap["id"]?.value as String;
  final String id = globals.planId;

  bool isDropdownOpen = false;
  bool isDropdownOpen1 = false;
  final Map<String, String> planImages = {
    'bronze': "assets/images/bronze.png",
    'silver': 'assets/images/silver.png',
    'gold': 'assets/images/gold.png',
    'platinum': 'assets/images/platinum.png'
  };

  String? selectedState;

  final EnrollBloc _enrollBloc = getIt.get<EnrollBloc>();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode1 = FocusNode();
  bool _showConfirmPassword = false;
  bool _showPassword = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  bool containsAlphanumeric(String text) {
    RegExp regex = RegExp(r'[a-zA-Z0-9]');
    return regex.hasMatch(text);
  }

  bool isValidAddress(String address) {
    return address.trim().length >= 5; // Adjust the minimum length as needed
  }

  @override
  Widget build(BuildContext context) {
    String? colorValue = globals.colorValue;
    // Replace this with your hex color

    Color hexToRgba(String hexColor) {
      if (hexColor == '') {
        return const Color.fromRGBO(255, 255, 255, 1 / 255.0);
      }
      hexColor = hexColor.replaceAll("#", "");
      int value = int.parse(hexColor, radix: 16);

      int alpha = (value >> 24) & 0xFF;
      int red = (value >> 16) & 0xFF;
      int green = (value >> 8) & 0xFF;
      int blue = value & 0xFF;

      return Color.fromRGBO(red, green, blue, alpha / 255.0);
    }

    Color rgbaColor = hexToRgba(colorValue);

    return BlocProvider(
        create: (context) => _enrollBloc
          ..getplan(id)
          ..getStates(),
        // ..getCities(stateId),
        child:
            BlocConsumer<EnrollBloc, EnrollState>(listener: (context, state) {
          if (state.stateUpdated &&
              state.stateId != null &&
              state.stateId!.id != null &&
              state.stateId!.id!.toString().isNotEmpty) {
            _enrollBloc.getCities(state.stateId!);
          }
          if (state.signUpSuccesful) {
            var shippingAddress = ShippingAddress(
                recipientName: state.data?.data?.username ?? '',
                line1: state.data?.data?.street ?? '',
                city: state.data?.data?.city?.cityName ?? '',
                postalCode: state.data?.data?.zipcode ?? '',
                phone: state.data?.data?.mobile ?? '',
                state: state.data?.data?.state?.name ?? '');
            _enrollBloc.disposeControllers();
            if (state.message == Constants.notEnrolled) {
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
                          globals.planId = state.data?.data?.planId ?? '';
                          Navigator.pop(context);
                          QR.toName(Routes.PAYPAL.name, params: {
                            'amount': state.data?.data?.planAmount ?? '',
                            'shipping_address': shippingAddress
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              if (state.data!.data!.isVerifiedUser == true) {
                globals.planId = state.data?.data?.planId ?? '';
              }
              state.data!.data!.isVerifiedUser == true
                  ? QR.toName(Routes.PAYPAL.name, params: {
                      'amount': state.choosePlanModal!.planAmount.toString(),
                      'shipping_address': shippingAddress
                    })
                  : QR.toName(Routes.OTP.name, params: {
                      'subscriptionFee':
                          state.choosePlanModal!.planAmount.toString(),
                      'shipping_address': shippingAddress
                    });
            }
          } else if (state.error!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Center(
                  child: Text(
                    state.error!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }, builder: (context, state) {
          return Stack(children: [
            Scaffold(
                backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
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
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const ChoosePlan()));
                        },
                      ),
                      title: Text(
                        globals.subscription
                            ? 'Enroll for a ${state.choosePlanModal!.plan} account'
                            : 'Enroll',
                        style: const TextStyle(
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
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                        key: _enrollBloc.enrollFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            globals.subscription
                                ? Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        color: state.choosePlanModal!.plan ==
                                                'Bronze'
                                            ? ColorCons.bronze
                                            : state.choosePlanModal!.plan ==
                                                    'Silver'
                                                ? ColorCons.silver
                                                : state.choosePlanModal!.plan ==
                                                        'Gold'
                                                    ? ColorCons.gold
                                                    : state.choosePlanModal!
                                                                .plan ==
                                                            'Platinum'
                                                        ? ColorCons.platinum
                                                        : rgbaColor,
                                        // border: Border.all(
                                        //   width: 2.0,
                                        // ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    margin: const EdgeInsets.only(
                                        left: 0, bottom: 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      200,
                                                  child: Text(
                                                      state.choosePlanModal!
                                                          .plan!,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: ColorCons
                                                              .buttonBG,
                                                          fontSize: 18.0,
                                                          fontFamily:
                                                              'NeueHaasGroteskTextPro',
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          overflow: TextOverflow
                                                              .ellipsis)),
                                                ),
                                                const SizedBox(height: 6),
                                                ...state
                                                    .choosePlanModal!.widgets!
                                                    .map((item) => SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              200,
                                                          child: Text(
                                                            item.name!,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color: ColorCons
                                                                  .buttonBG,
                                                              fontSize: 12.0,
                                                              fontFamily:
                                                                  'NeueHaasGroteskTextPro',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        )),
                                              ],
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.18,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.18,
                                              padding: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        112, 112, 112, 1),
                                                    width: 2.0,
                                                  ),
                                                  image: state.choosePlanModal!
                                                          .imagePath!.isNotEmpty
                                                      ? DecorationImage(
                                                          image: NetworkImage(state
                                                              .choosePlanModal!
                                                              .imagePath!),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : const DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/bronze.png'),
                                                          fit: BoxFit.cover,
                                                        )),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Divider(
                                          color: state.choosePlanModal!.plan ==
                                                  'Bronze'
                                              ? ColorCons.bronzeDivider
                                              : state.choosePlanModal!.plan ==
                                                      'Silver'
                                                  ? ColorCons.silverDivider
                                                  : state.choosePlanModal!
                                                              .plan ==
                                                          'Gold'
                                                      ? ColorCons.goldDivider
                                                      : state.choosePlanModal!
                                                                  .plan ==
                                                              'Platinum'
                                                          ? ColorCons
                                                              .platinumDivider
                                                          : rgbaColor,
                                          height: 1,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: state.choosePlanModal!
                                                            .plan !=
                                                        'FREE'
                                                    ? Text(
                                                        "Registration / Renewal   \$${state.choosePlanModal!.registrationAmount!}",
                                                        style: TextStyle(
                                                          color: ColorCons
                                                              .buttonBG,
                                                          fontFamily:
                                                              'NeueHaasGroteskTextPro',
                                                          fontSize: 10.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      )
                                                    : const SizedBox(),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '\$${state.choosePlanModal!.planAmount}/month',
                                                    style: TextStyle(
                                                      color: ColorCons.buttonBG,
                                                      fontFamily:
                                                          'NeueHaasGroteskTextPro',
                                                      fontSize: 21.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ],
                                    ))
                                : const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9\s]'),
                                  ),
                                  TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                    final regExp = RegExp(r'^[a-zA-Z0-9\s]');
                                    if (newValue.text.isEmpty) {
                                      return newValue;
                                    } else if (newValue.text.length == 1 &&
                                        newValue.text.startsWith(' ')) {
                                      return oldValue;
                                    } else if (regExp.hasMatch(newValue.text)) {
                                      return newValue;
                                    } else {
                                      return oldValue;
                                    }
                                  }),
                                ],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Username is Required';
                                  } else if (value.length < 3) {
                                    return 'Username must Contain minimum 3 characters';
                                  }
                                  return null;
                                },
                                maxLength: 50,
                                controller: _enrollBloc.usernameController,
                                // autovalidateMode:
                                //     AutovalidateMode.onUserInteraction,
                                onChanged: (value) {
                                  setState(() {
                                    if (value.isNotEmpty && value.length >= 3) {
                                      errorText = '';
                                    }
                                  });
                                },
                                decoration: const InputDecoration(
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
                                  // hintText: 'Username',
                                  labelText: 'Username',
                                  errorStyle: TextStyle(fontSize: 13.0),
                                  labelStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(116, 116, 116, 1),
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    fontSize: 13,
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 188, 204, 1),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 188, 204, 1),
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Color.fromRGBO(35, 44, 58, 1),
                                  fontSize: 13,
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: 'Email is Required'),
                                  EmailValidator(
                                      errorText:
                                          'Please Enter a Valid Email Address'),
                                ]),
                                controller: _enrollBloc.emailController,
                                textCapitalization: TextCapitalization.none,
                                autocorrect: false,
                                maxLength: 50,
                                // autovalidateMode:
                                //     AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  // hintText: 'Email',
                                  labelText: 'Email',
                                  counterText: "",
                                  errorStyle: TextStyle(fontSize: 13.0),
                                  labelStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(116, 116, 116, 1),
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    fontSize: 13,
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 188, 204, 1),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 188, 204, 1),
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    fontSize: 13,
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: _enrollBloc.phoneController,
                                // autovalidateMode:
                                //     AutovalidateMode.onUserInteraction,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
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
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
                                  // hintText: 'Phone Number',
                                  labelText: 'Phone Number',
                                  errorStyle: TextStyle(fontSize: 13.0),
                                  labelStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(116, 116, 116, 1),
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    fontSize: 13,
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 188, 204, 1),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 188, 204, 1),
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Color.fromRGBO(35, 44, 58, 1),
                                  fontSize: 13,
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'^\s+')), // Deny leading spaces
                                  // FilteringTextInputFormatter.allow(
                                  //     RegExp(r'^[a-zA-Z0-9\s\.,#\-]+$'))
                                ],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Street is Required';
                                  }
                                  // if (!isValidAddress(value)) {
                                  //   return 'Street is Required';
                                  // }
                                  return null;
                                },
                                maxLength: 100,
                                controller: _enrollBloc.streetController,
                                textCapitalization: TextCapitalization.none,
                                autocorrect: false,
                                // autovalidateMode:
                                //     AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
                                  labelText: 'Street',
                                  errorStyle: TextStyle(fontSize: 13.0),
                                  labelStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(116, 116, 116, 1),
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    fontSize: 13,
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 188, 204, 1),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 188, 204, 1),
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Color.fromRGBO(35, 44, 58, 1),
                                  fontSize: 13,
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SearchField(
                                suggestionState: Suggestion.expand,
                                focusNode: _focusNode,
                                suggestionAction: SuggestionAction.unfocus,
                                suggestions: state.states
                                    .map((states) => SearchFieldListItem(
                                          states.name!,
                                          item: states.id,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 19, right: 19),
                                                child: Center(
                                                  child: Text(
                                                    states.name!,
                                                    style: const TextStyle(
                                                        fontFamily: 'Söhne',
                                                        fontSize: 14,
                                                        color: Color.fromRGBO(
                                                            35, 44, 58, 1)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Select State is Required';
                                  }
                                  bool stateExists = state.states.any((state) =>
                                      state.name!.toLowerCase() ==
                                      value.toLowerCase());
                                  if (!stateExists) {
                                    return 'State not found. Please select a valid state.';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.search,
                                controller: _enrollBloc.statesController,
                                maxSuggestionsInViewPort: 4,
                                itemHeight: 40,
                                searchStyle: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromRGBO(35, 44, 58, 1),
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  fontWeight: FontWeight.w500,
                                ),
                                searchInputDecoration: InputDecoration(
                                  labelText: 'State/Province/Region',
                                  errorStyle: const TextStyle(fontSize: 13.0),
                                  labelStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(116, 116, 116, 1),
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    fontSize: 13,
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 188, 204, 1),
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 188, 204, 1),
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isDropdownOpen) {
                                          _focusNode.unfocus();
                                        } else {
                                          _focusNode.requestFocus();
                                        }
                                        isDropdownOpen = !isDropdownOpen;
                                      });
                                    },
                                    child: Image.asset(
                                      "assets/images/dropdown.png",
                                      width: 23.0,
                                      height: 23.0,
                                    ),
                                  ),
                                ),
                                suggestionStyle: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  color: Color.fromRGBO(35, 44, 58, 1),
                                ),
                                suggestionItemDecoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0.5,
                                  ),
                                ),
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                onSuggestionTap: (x) {
                                  StateData stateSelected = state.states
                                      .firstWhere(
                                          (element) => element.id == x.item);
                                  _enrollBloc.updateState(stateSelected);
                                },
                                onSubmit: (value) {
                                  if (!_enrollBloc.enrollFormKey.currentState!
                                      .validate()) {
                                    return;
                                  }
                                  // Handle valid state selection
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                // height: 80,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: [
                                            SearchField(
                                              suggestionState:
                                                  Suggestion.expand,
                                              focusNode: _focusNode1,
                                              suggestionAction:
                                                  SuggestionAction.unfocus,
                                              suggestions: state.cities!
                                                  .map((cities) =>
                                                      SearchFieldListItem(
                                                        cities.cityName ?? '',
                                                        item: cities.id,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 19,
                                                                      right:
                                                                          19),
                                                              child: Text(
                                                                cities.cityName ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'Söhne',
                                                                    fontSize:
                                                                        14,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            35,
                                                                            44,
                                                                            58,
                                                                            1)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ))
                                                  .toList(),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Select City is Required';
                                                }
                                                bool cityExists = state.cities!
                                                    .any((city) =>
                                                        city.cityName!
                                                            .toLowerCase() ==
                                                        value.toLowerCase());
                                                if (!cityExists) {
                                                  return 'City not found. Please select a valid city.';
                                                }
                                                return null;
                                              },
                                              textInputAction:
                                                  TextInputAction.search,
                                              controller:
                                                  _enrollBloc.cityController,
                                              maxSuggestionsInViewPort: 4,
                                              itemHeight: 40,
                                              searchStyle: const TextStyle(
                                                fontSize: 13,
                                                color: Color.fromRGBO(
                                                    35, 44, 58, 1),
                                                fontFamily:
                                                    'NeueHaasGroteskTextPro',
                                                fontWeight: FontWeight.w500,
                                              ),
                                              searchInputDecoration:
                                                  InputDecoration(
                                                labelText: 'City/Town',
                                                errorStyle: const TextStyle(
                                                    fontSize: 13.0),
                                                labelStyle: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      116, 116, 116, 1),
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                hintStyle: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                  fontSize: 13,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        184, 188, 204, 1),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        184, 188, 204, 1),
                                                  ),
                                                ),
                                                suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (isDropdownOpen1) {
                                                        _focusNode1.unfocus();
                                                      } else {
                                                        _focusNode1
                                                            .requestFocus();
                                                      }
                                                      isDropdownOpen1 =
                                                          !isDropdownOpen1;
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    "assets/images/dropdown.png",
                                                    width: 23.0,
                                                    height: 23.0,
                                                  ),
                                                ),
                                              ),
                                              suggestionStyle: const TextStyle(
                                                fontSize: 14,
                                                fontFamily:
                                                    'NeueHaasGroteskTextPro',
                                                color: Color.fromRGBO(
                                                    35, 44, 58, 1),
                                              ),
                                              suggestionItemDecoration:
                                                  BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5,
                                                ),
                                              ),
                                              onTapOutside: (event) {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              onSuggestionTap: (x) {
                                                CityData citySelected = state
                                                    .cities!
                                                    .firstWhere((element) =>
                                                        element.id == x.item);
                                                _enrollBloc
                                                    .updateCity(citySelected);
                                              },
                                              onSubmit: (value) {
                                                if (!_enrollBloc
                                                    .enrollFormKey.currentState!
                                                    .validate()) {
                                                  return;
                                                }
                                                // Handle valid city selection
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Zipcode is Required';
                                                } else if (value.length != 5 &&
                                                    value.length != 10) {
                                                  return 'Please enter a valid Zipcode.';
                                                }
                                                return null;
                                              },
                                              maxLength: 9,
                                              controller:
                                                  _enrollBloc.zipcodeController,
                                              decoration: const InputDecoration(
                                                // hintText: 'ZIP Code',
                                                errorMaxLines: 3,
                                                labelText: 'ZIP Code',
                                                errorStyle:
                                                    TextStyle(fontSize: 13.0),
                                                labelStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      116, 116, 116, 1),
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                hintStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                  fontSize: 13,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        184, 188, 204, 1),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        184, 188, 204, 1),
                                                  ),
                                                ),
                                                counterStyle: TextStyle(
                                                  height: double.minPositive,
                                                ),
                                                counterText: "",
                                              ),
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    35, 44, 58, 1),
                                                fontSize: 13,
                                                fontFamily:
                                                    'NeueHaasGroteskTextPro',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              onChanged: (value) {
                                                if (value.length > 5 &&
                                                    value.length <= 9) {
                                                  _enrollBloc.zipcodeController
                                                      .value = TextEditingValue(
                                                    text:
                                                        '${value.substring(0, 5)}-${value.substring(5, 9)}',
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset:
                                                                value.length +
                                                                    1),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller:
                                        _enrollBloc.referalCodeContoller,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'^\s+')),
                                    ],
                                    validator: (value) {
                                      if (value != null && value.isNotEmpty) {
                                        if (value.length != 10) {
                                          return 'Referral code must be 10 characters';
                                        }
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      final upperCaseValue =
                                          value.toUpperCase();
                                      if (_enrollBloc
                                              .referalCodeContoller.text !=
                                          upperCaseValue) {
                                        _enrollBloc.referalCodeContoller.value =
                                            TextEditingValue(
                                          text: upperCaseValue,
                                          selection: TextSelection.fromPosition(
                                            TextPosition(
                                                offset: upperCaseValue.length),
                                          ),
                                        );
                                      }

                                      if (upperCaseValue.length == 10) {
                                        _enrollBloc.validateReferalCode(
                                            upperCaseValue);
                                      } else {
                                        _enrollBloc.clearValidationStatus();
                                      }
                                    },
                                    maxLength: 10,
                                    decoration: const InputDecoration(
                                      labelText: 'Referral Code (Optional)',
                                      errorStyle: TextStyle(fontSize: 13.0),
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(116, 116, 116, 1),
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Color.fromRGBO(35, 44, 58, 1),
                                        fontSize: 13,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(184, 188, 204, 1),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(184, 188, 204, 1),
                                        ),
                                      ),
                                      counterStyle: TextStyle(
                                        height: double.minPositive,
                                      ),
                                      counterText: "",
                                    ),
                                    style: const TextStyle(
                                      color: Color.fromRGBO(35, 44, 58, 1),
                                      fontSize: 13,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: !_showPassword,
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'Password is Required'),
                                      PatternValidator(
                                          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#^])[A-Za-z\d@$!%*?&#^]{6,}$",
                                          errorText:
                                              'Password must have 6-10 characters in length, One Upper case, One Lower case, One Special Character.'),
                                    ]),
                                    controller: _enrollBloc.passwordController,
                                    maxLength: 10,
                                    // autovalidateMode:
                                    //     AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      // hintText: 'Password',
                                      errorMaxLines: 3,
                                      labelText: 'Password',
                                      errorStyle:
                                          const TextStyle(fontSize: 13.0),
                                      labelStyle: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(116, 116, 116, 1),
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w500,
                                      ),

                                      counterText: "",
                                      counterStyle: const TextStyle(
                                        height: double.minPositive,
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _showPassword = !_showPassword;
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
                                      hintStyle: const TextStyle(
                                        color: Color.fromRGBO(35, 44, 58, 1),
                                        fontSize: 13,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(184, 188, 204, 1),
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(184, 188, 204, 1),
                                        ),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Color.fromRGBO(35, 44, 58, 1),
                                      fontSize: 13,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return 'Confirm Password is Required';
                                      } else if (val !=
                                          _enrollBloc.passwordController.text
                                              .trim()) {
                                        return 'Given Password and Confirm Password Not Matched';
                                      }
                                      return null;
                                    },
                                    controller:
                                        _enrollBloc.confirmpasswordController,
                                    // autovalidateMode:
                                    //     AutovalidateMode.onUserInteraction,
                                    obscureText: !_showConfirmPassword,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                      // hintText: 'Confirm Password',
                                      errorMaxLines: 2,
                                      labelText: 'Confirm Password',
                                      errorStyle:
                                          const TextStyle(fontSize: 13.0),
                                      labelStyle: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(116, 116, 116, 1),
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      counterText: "",
                                      counterStyle: const TextStyle(
                                        height: double.minPositive,
                                      ),
                                      hintStyle: const TextStyle(
                                        color: Color.fromRGBO(35, 44, 58, 1),
                                        fontSize: 13,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _showConfirmPassword =
                                                !_showConfirmPassword;
                                          });
                                        },
                                        child: Icon(
                                          _showConfirmPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(184, 188, 204, 1),
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(184, 188, 204, 1),
                                        ),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Color.fromRGBO(35, 44, 58, 1),
                                      fontSize: 13,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 21, 0, 0),
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    fontSize: 10,
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                  ),
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text:
                                          'By clicking the "Enroll" button below, I certify that I have read and agree to the LAOE MAOM ',
                                    ),
                                    TextSpan(
                                        text: 'Terms of use',
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(0, 176, 80, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            TC? termsAndConditions =
                                                state.choosePlanModal!.tc;
                                            if (termsAndConditions != null) {
                                              QR.toName(
                                                  Routes.PRIVACYENROLLPAGE.name,
                                                  params: {
                                                    'termsAndConditions':
                                                        termsAndConditions
                                                  });
                                            }
                                          }),
                                    const TextSpan(
                                      text: ' and ',
                                    ),
                                    TextSpan(
                                        text: 'privacy policy.',
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(0, 176, 80, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            TC? termsAndConditions =
                                                state.choosePlanModal!.tc;
                                            if (termsAndConditions != null) {
                                              QR.toName(
                                                  Routes.PRIVACYENROLLPAGE.name,
                                                  params: {
                                                    'termsAndConditions':
                                                        termsAndConditions
                                                  });
                                            }
                                          }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _enrollBloc.createUser(
                                context, state.choosePlanModal!.plan);
                            // _enrollBloc.cityController.clear();
                            // _enrollBloc.statesController.clear();
                            // _enrollBloc.usernameController.clear();
                            // _enrollBloc.enrollFormKey.currentState?.reset();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(55, 74, 156, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            // padding:
                            //     const EdgeInsets.symmetric(horizontal: 10),
                            elevation: 0,
                          ),
                          child: const SizedBox(
                            // height: 42,
                            child: Center(
                              child: Text(
                                'Enroll',
                                style: TextStyle(
                                  fontFamily: "NeueHaasGroteskTextPro",
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
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

// class _UsPhoneNumberFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     // Format the phone number with dashes (e.g., 123-456-7890)
//     if (newValue.text.isNotEmpty) {
//       final number = newValue.text.replaceAll(RegExp(r'\D'), '');
//       final formattedValue = _formatPhoneNumber(number);
//       return newValue.copyWith(
//         text: formattedValue,
//         selection: TextSelection.fromPosition(
//           TextPosition(offset: formattedValue.length),
//         ),
//       );
//     }
//     return newValue;
//   }

//   String _formatPhoneNumber(String number) {
//     if (number.length <= 3) {
//       return number;
//     } else if (number.length <= 6) {
//       return '${number.substring(0, 3)} ${number.substring(3)}';
//     } else {
//       return '${number.substring(0, 3)} ${number.substring(3, 6)}-${number.substring(6, 10)}';
//     }
//   }
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

Color getColorForIndex(int index) {
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.brown,
    // Add the remaining colors here
  ];

  // Ensure the index is within bounds
  return colorList[index % colorList.length];
}

Color hexToRgba(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  int value = int.parse(hexColor, radix: 16);

  int alpha = (value >> 24) & 0xFF;
  int red = (value >> 16) & 0xFF;
  int green = (value >> 8) & 0xFF;
  int blue = value & 0xFF;

  return Color.fromRGBO(red, green, blue, alpha / 255.0);
}
