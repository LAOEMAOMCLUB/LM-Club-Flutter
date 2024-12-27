// BusinessProfilePage Business User can see there profile here 

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/presentation/business_module/business_profile/bloc/business_profile.bloc.dart';
import 'package:lm_club/app/presentation/business_module/business_profile/bloc/business_profile.state.dart';
import 'package:lm_club/app/presentation/business_module/business_profile/pages/edit_business_profile.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:searchfield/searchfield.dart';
import 'package:lm_club/utils/globals.dart' as globals;

class ViewBusinessProfile extends StatefulWidget {
  const ViewBusinessProfile({super.key, this.id});
  final String? id;
  @override
  State<ViewBusinessProfile> createState() => _ViewBusinessProfileState();
}

class _ViewBusinessProfileState extends State<ViewBusinessProfile> {
  final BusinessProfileBloc _businessProfileBloc =
      getIt.get<BusinessProfileBloc>();

  String errorText = '';
  String? selectedState;
  String? selectedBusinessType;
  DateTime selectedDate = DateTime.now();

  bool containsAlphanumeric(String text) {
    RegExp regex = RegExp(r'[a-zA-Z0-9]');
    return regex.hasMatch(text);
  }

  bool isValidAddress(String address) {
    return address.trim().length >= 5;
  }

  final Map<String, String> planImages = {
    'bronze': "assets/images/bronze.png",
    'silver': 'assets/images/silver.png',
    'gold': 'assets/images/gold.png',
    'platinum': 'assets/images/platinum.png'
  };

  List<SearchFieldListItem<String>> suggestions = [
    SearchFieldListItem("Dining"),
    SearchFieldListItem("Coupouns/Deals"),
    SearchFieldListItem("Events"),
  ];
 
  List<SearchFieldListItem<String>> states = [
    SearchFieldListItem("Owner"),
    SearchFieldListItem("Manager"),
    SearchFieldListItem("Others"),
  ];


 String selectedTimeTo = 'Select Time';
  String selectedTimeFrom = 'Select Time';




  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            _businessProfileBloc..getUserDetails(globals.userId),
        child: BlocConsumer<BusinessProfileBloc, BusinessProfileState>(
            listener: (context, state) {
          if (state.isSuccesful!) {
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
          // String planType = state.choosePlanModal?.plan ?? '';
          // // ignore: unused_local_variable
          // String imagePath = planImages[planType.toLowerCase()] ?? '';
          return Stack(children: [
            Scaffold(
              backgroundColor: Colors.white,
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
                  ),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: const Text(
                      'View Business Profile',
                      style: TextStyle(
                        color: Color.fromRGBO(238, 238, 238, 1),
                        fontSize: 18,
                        fontFamily: 'NeueHaasGroteskTextPro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    centerTitle: false,
                    elevation: 0,
                    actions: [
                      IconButton(
                        onPressed: () {
                          // _businessProfileBloc
                          //     .populateUserDetails(state.userDetails!);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditBusinessProfile()));
                        },
                        icon: Image.asset(
                          'assets/images/edit-2.png',
                          width: 22,
                          height: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Form(
                      key: _businessProfileBloc.businessProfileFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textCapitalization: TextCapitalization.none,
                              autocorrect: false,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^\s+')),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]')),
                              ],
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'Business Name is Required'),
                              ]),
                              readOnly: true,
                              enabled: true,
                              controller:
                                  _businessProfileBloc.usernameController,
                              // inputFormatters: <TextInputFormatter>[
                              //   FilteringTextInputFormatter.allow(
                              //     RegExp(r'[a-zA-Z0-9\s]'),
                              //   ),
                              // ],
                              maxLength: 50,

                              decoration: const InputDecoration(
                                counterStyle: TextStyle(
                                  height: double.minPositive,
                                ),
                                counterText: "",
                                // hintText: 'Username',
                                labelText: 'Business Name',
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
                              controller: _businessProfileBloc.emailController,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'Email is Required'),
                                EmailValidator(
                                    errorText:
                                        'Please Enter a Valid Email Address'),
                              ]),

                              maxLength: 50,
                              readOnly: true,
                              enabled: true,
                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: 'Business Email',
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
                              controller: _businessProfileBloc.phoneController,
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
                              readOnly: true,
                              enabled: true,
                              decoration: const InputDecoration(
                                counterStyle: TextStyle(
                                  height: double.minPositive,
                                ),
                                counterText: "",
                                // hintText: 'Phone Number',
                                labelText: 'Business Phone Number',
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
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   // key: _newListingBloc.cityKey,
                          //   child: SearchField(
                          //     suggestionState: Suggestion.expand,
                          //     suggestionAction: SuggestionAction.unfocus,
                          //     suggestions: states,
                          //     // .map((states) => SearchFieldListItem(states.name!,
                          //     //     item: states.id,
                          //     //     child: Row(
                          //     //       mainAxisAlignment:
                          //     //           MainAxisAlignment.spaceBetween,
                          //     //       children: [
                          //     //         Padding(
                          //     //           padding: const EdgeInsets.only(
                          //     //               left: 19, right: 19),
                          //     //           child: Center(
                          //     //             child: Text(
                          //     //               states.name!,
                          //     //               style: const TextStyle(
                          //     //                   fontFamily: 'Söhne',
                          //     //                   fontSize: 14,
                          //     //                   color: Color.fromRGBO(
                          //     //                       35, 44, 58, 1)),
                          //     //             ),
                          //     //           ),
                          //     //         ),
                          //     //       ],
                          //     //     )))
                          //     // .toList(),
                          //     readOnly: true,
                          //     enabled: true,
                          //     validator: MultiValidator([
                          //       RequiredValidator(
                          //           errorText: 'Select By is Required'),
                          //     ]),
                          //     textInputAction: TextInputAction.continueAction,
                          //     controller:
                          //         _businessProfileBloc.businessByController,
                          //     maxSuggestionsInViewPort: 4,
                          //     itemHeight: 40,
                          //     searchStyle: const TextStyle(
                          //       fontSize: 13,
                          //       color: Color.fromRGBO(35, 44, 58, 1),
                          //       fontFamily: 'NeueHaasGroteskTextPro',
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //     searchInputDecoration: const InputDecoration(
                          //       // hintText: 'State',
                          //       labelText: 'Business By',
                          //       errorStyle: TextStyle(fontSize: 13.0),
                          //       labelStyle: TextStyle(
                          //         fontSize: 14,
                          //         color: Color.fromRGBO(116, 116, 116, 1),
                          //         fontFamily: 'NeueHaasGroteskTextPro',
                          //         fontWeight: FontWeight.w500,
                          //       ),
                          //       hintStyle: TextStyle(
                          //         color: Color.fromRGBO(35, 44, 58, 1),
                          //         fontSize: 13,
                          //         fontFamily: 'NeueHaasGroteskTextPro',
                          //         fontWeight: FontWeight.w400,
                          //       ),
                          //       enabledBorder: UnderlineInputBorder(
                          //         borderSide: BorderSide(
                          //           color: Color.fromRGBO(184, 188, 204, 1),
                          //         ),
                          //       ),
                          //       focusedBorder: UnderlineInputBorder(
                          //         borderSide: BorderSide(
                          //           color: Color.fromRGBO(184, 188, 204, 1),
                          //         ),
                          //       ),
                          //       suffixIcon: Icon(
                          //         Icons.arrow_drop_down_circle,
                          //         color: Color.fromRGBO(221, 221, 221, 1),
                          //         size: 20,
                          //       ),
                          //     ),
                          //     suggestionStyle: const TextStyle(
                          //       fontSize: 14,
                          //       fontFamily: 'NeueHaasGroteskTextPro',
                          //       color: Color.fromRGBO(35, 44, 58, 1),
                          //     ),
                          //     suggestionItemDecoration: BoxDecoration(
                          //       border: Border.all(
                          //         color: Colors.grey,
                          //         width: 0.5,
                          //       ),
                          //       // borderRadius: BorderRadius.circular(8.0),
                          //     ),
                          //     // suggestionsDecoration: SuggestionDecoration(),
                          //     // onSuggestionTap: (x) {
                          //     //   selectedBusinesasType = x.searchKey;
                          //     //   _businessProfileBloc.businessByController.text =
                          //     //       selectedBusinessType!;
                          //     // },
                          //     // onSubmit: (p0) {},
                          //   ),
                          // ),

                           Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller:_businessProfileBloc.businessByController,
                              maxLength: 50,
                              enabled: true,
                              readOnly: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                // hintText: 'Email',
                                labelText: 'Business By',
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
                              keyboardType: TextInputType.text,
                              controller:
                                  _businessProfileBloc.businessNameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textCapitalization: TextCapitalization.none,
                              autocorrect: false,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^\s+')),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]')),
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Business Person name is Required';
                                }
                                // if (!isValidAddress(value)) {
                                //   return 'Business Person name is Required';
                                // }
                                return null;
                              },
                              maxLength: 50,
                              readOnly: true,
                              enabled: true,
                              decoration: const InputDecoration(
                                counterStyle: TextStyle(
                                  height: double.minPositive,
                                ),
                                counterText: "",
                                labelText: 'Business Person name',
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
                              controller:
                                  _businessProfileBloc.businessTypeController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textCapitalization: TextCapitalization.none,
                              autocorrect: false,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^\s+')),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]')),
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Type of Business/Industry is Required';
                                }
                                // if (!isValidAddress(value)) {
                                //   return 'Type of Business/Industry is Required';
                                // }
                                return null;
                              },
                              maxLength: 50,
                              readOnly: true,
                              enabled: true,
                              decoration: const InputDecoration(
                                counterStyle: TextStyle(
                                  height: double.minPositive,
                                ),
                                counterText: "",
                                labelText: 'Type of Business/Industry',
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
                            child: GestureDetector(
                              // onTap: () {
                              //   _selectDate(context);
                              // },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Business Establish Date is Required';
                                    }
                                    if (!isValidAddress(value)) {
                                      return 'Business Establish Date is Required';
                                    }
                                    return null;
                                  },
                                  controller: _businessProfileBloc
                                      .businessEstablishDateController,
                                  readOnly: true,
                                  enabled: true,
                                  decoration: InputDecoration(
                                    labelText: 'Business Establish Date',
                                    // hintText: '31 Oct 2023',
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

                                    suffixIcon: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Image.asset(
                                        "assets/images/note.png",
                                        width: 10.0,
                                        height: 10.0,
                                        color: const Color.fromRGBO(
                                            116, 116, 116, 1),
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
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextFormField(
                          //     keyboardType: TextInputType.text,
                          //     controller:
                          //         _businessProfileBloc.locationController,
                          //     inputFormatters: <TextInputFormatter>[
                          //       FilteringTextInputFormatter.deny(
                          //           RegExp(r'^\s+')), // Deny leading spaces
                          //       // FilteringTextInputFormatter.allow(
                          //       //     RegExp(r'^[a-zA-Z0-9\s\.,#\-]+$'))
                          //     ],
                          //     validator: (value) {
                          //       if (value!.isEmpty) {
                          //         return 'Location is Required';
                          //       }
                          //       // if (!isValidAddress(value)) {
                          //       //   return 'Location is Required';
                          //       // }
                          //       return null;
                          //     },
                          //     maxLength: 150,
                          //     readOnly: true,
                          //     enabled: true,
                          //     decoration: const InputDecoration(
                          //       counterStyle: TextStyle(
                          //         height: double.minPositive,
                          //       ),
                          //       counterText: "",
                          //       labelText: 'Location',
                          //       errorStyle: TextStyle(fontSize: 13.0),
                          //       labelStyle: TextStyle(
                          //         fontSize: 14,
                          //         color: Color.fromRGBO(116, 116, 116, 1),
                          //         fontFamily: 'NeueHaasGroteskTextPro',
                          //         fontWeight: FontWeight.w500,
                          //       ),
                          //       hintStyle: TextStyle(
                          //         color: Color.fromRGBO(35, 44, 58, 1),
                          //         fontSize: 13,
                          //         fontFamily: 'NeueHaasGroteskTextPro',
                          //         fontWeight: FontWeight.w400,
                          //       ),
                          //       enabledBorder: UnderlineInputBorder(
                          //         borderSide: BorderSide(
                          //           color: Color.fromRGBO(184, 188, 204, 1),
                          //         ),
                          //       ),
                          //       focusedBorder: UnderlineInputBorder(
                          //         borderSide: BorderSide(
                          //           color: Color.fromRGBO(184, 188, 204, 1),
                          //         ),
                          //       ),
                          //     ),
                          //     style: const TextStyle(
                          //       color: Color.fromRGBO(35, 44, 58, 1),
                          //       fontSize: 13,
                          //       fontFamily: 'NeueHaasGroteskTextPro',
                          //       fontWeight: FontWeight.w400,
                          //     ),
                          //   ),
                          // ),
                         
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
                                controller: _businessProfileBloc.streetController,
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
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _businessProfileBloc.statesController,
                              maxLength: 50,
                              enabled: true,
                              readOnly: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                // hintText: 'Email',
                                labelText: 'State',
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
                            child: SizedBox(
                              // height: 80,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller:
                                                  _businessProfileBloc.cityController,
                                              maxLength: 50,
                                              enabled: true,
                                              readOnly: true,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              decoration: const InputDecoration(
                                                // hintText: 'Email',
                                                labelText: 'City/Town',
                                                counterText: "",
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
                                              ),
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                  fontSize: 13,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w400),
                                            ),
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
                                            keyboardType: TextInputType.number,
                                            controller:
                                                _businessProfileBloc.zipcodeController,
                                            maxLength: 9,
                                            enabled: true,
                                            readOnly: true,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
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
                                              color:
                                                  Color.fromRGBO(35, 44, 58, 1),
                                              fontSize: 13,
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _businessProfileBloc
                                  .servicesOfferedController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textCapitalization: TextCapitalization.none,
                              autocorrect: false,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^\s+')),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]')),
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Services Offered is Required';
                                }

                                return null;
                              },
                              maxLength: 100,
                              readOnly: true,
                              enabled: true,
                              decoration: const InputDecoration(
                                counterStyle: TextStyle(
                                  height: double.minPositive,
                                ),
                                counterText: "",
                                labelText: 'Services Offered',
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
                          const Padding(
                            padding: EdgeInsets.only(
                                top: 15.0, left: 8.0, bottom: 8.0, right: 8.0),
                            child: Text(
                              'Hours of Operation',
                              style: TextStyle(
                                color: Color.fromRGBO(116, 116, 116, 1),
                                fontSize: 13,
                                fontFamily: 'NeueHaasGroteskTextPro',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              // height: 80,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'From ',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                  fontSize: 13,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Expanded(
                                                  child: GestureDetector(
                                                // onTap: () async {
                                                //   _selectTimeFrom(context);
                                                // },
                                                child: AbsorbPointer(
                                                    child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.text,
                                                  controller: _businessProfileBloc
                                                      .operationHoursFromController,
                                                  // inputFormatters: <TextInputFormatter>[
                                                  //   FilteringTextInputFormatter
                                                  //       .deny(
                                                  //     RegExp(r'^\s+'),
                                                  //   ),
                                                  // ],
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .deny(
                                                      RegExp(r'^\s+'),
                                                    ),
                                                  ],
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Hours are Required';
                                                    }
                                                    return null;
                                                  },
                                                  readOnly: true,
                                                  enabled: true,
                                                  decoration:
                                                      const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(5),
                                                    counterStyle: TextStyle(
                                                      height:
                                                          double.minPositive,
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
                                                    hintText: "00:00",
                                                    counterText: "",
                                                    errorStyle: TextStyle(
                                                        fontSize: 13.0),
                                                    labelStyle: TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromRGBO(
                                                          116, 116, 116, 1),
                                                      fontFamily:
                                                          'NeueHaasGroteskTextPro',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    hintStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          35, 44, 58, 1),
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'NeueHaasGroteskTextPro',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        35, 44, 58, 1),
                                                    fontSize: 13,
                                                    fontFamily:
                                                        'NeueHaasGroteskTextPro',
                                                    fontWeight:
                                                        FontWeight.w400,
                                                  ),
                                                )),
                                              )),
                                              
                                            ],
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
                                          Row(
                                            children: [
                                              const Text(
                                                'To',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                  fontSize: 13,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Expanded(
                                                  child: GestureDetector(
                                                      // onTap: () async {
                                                      //   _selectTimeTo(
                                                      //       context);
                                                      // },
                                                      child: AbsorbPointer(
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                                 
                                                          controller:
                                                              _businessProfileBloc
                                                                  .operationHoursToController,
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .deny(
                                                              RegExp(r'^\s+'),
                                                            ),
                                                          ],
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Hours are Required';
                                                            }
                                                            return null;
                                                          },
                                                          readOnly: true,
                                                          enabled: true,
                                                          decoration:
                                                              const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .all(5),
                                                            counterStyle:
                                                                TextStyle(
                                                              height: double
                                                                  .minPositive,
                                                            ),
                                                            enabledBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        184,
                                                                        188,
                                                                        204,
                                                                        1),
                                                              ),
                                                            ),
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        184,
                                                                        188,
                                                                        204,
                                                                        1),
                                                              ),
                                                            ),
                                                            hintText: "00:00",
                                                            counterText: "",
                                                            errorStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        13.0),
                                                            labelStyle:
                                                                TextStyle(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      116,
                                                                      116,
                                                                      116,
                                                                      1),
                                                              fontFamily:
                                                                  'NeueHaasGroteskTextPro',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            hintStyle:
                                                                TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      35,
                                                                      44,
                                                                      58,
                                                                      1),
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'NeueHaasGroteskTextPro',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          style:
                                                              const TextStyle(
                                                            color: Color
                                                                .fromRGBO(
                                                                    35,
                                                                    44,
                                                                    58,
                                                                    1),
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'NeueHaasGroteskTextPro',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                          ),
                                                        ),
                                                      ))),
                                             
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      )),
                ),
              ),

              // bottomNavigationBar: Container(
              //     height: 50,
              //     margin:
              //         const EdgeInsets.only(top: 20, bottom: 20, left: 20),
              //     child: BottomAppBar(
              //       color: Colors.transparent,
              //       elevation: 0,
              //       height: 42,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           InkWell(
              //             onTap: () {
              //               Navigator.pop(context);
              //             },
              //             child: Container(
              //               height: 42,
              //               padding:
              //                   const EdgeInsets.fromLTRB(40, 2, 40, 2),
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(4),
              //                 border: Border.all(
              //                   color:
              //                       const Color.fromRGBO(170, 170, 170, 1),
              //                 ),
              //               ),
              //               alignment: Alignment.centerLeft,
              //               child: const Text(
              //                 'Cancel',
              //                 style: TextStyle(
              //                     fontSize: 14,
              //                     fontFamily: 'NeueHaasGroteskTextPro',
              //                     fontWeight: FontWeight.w500,
              //                     color: Color.fromRGBO(116, 116, 116, 1)),
              //               ),
              //             ),
              //           ),
              //           ElevatedButton(
              //             onPressed: () {},
              //             style: ButtonStyle(
              //               backgroundColor:
              //                   MaterialStateProperty.all<Color>(
              //                       Colors.transparent),
              //               elevation: MaterialStateProperty.all<double>(0),
              //               overlayColor: MaterialStateProperty.all<Color>(
              //                   Colors.transparent),
              //               shape: MaterialStateProperty.all<
              //                   RoundedRectangleBorder>(
              //                 RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(4.0),
              //                 ),
              //               ),
              //             ),
              //             child: Ink(
              //               decoration: BoxDecoration(
              //                 color: const Color.fromRGBO(55, 74, 156, 1),
              //                 borderRadius: BorderRadius.circular(4.0),
              //                 boxShadow: const [
              //                   BoxShadow(
              //                     color: Color.fromRGBO(0, 0, 0, 0.16),
              //                     blurRadius: 4.0,
              //                     spreadRadius: 4.0,
              //                   ),
              //                 ],
              //               ),
              //               child: Container(
              //                   // width: 154,
              //                   height: 42,
              //                   padding:
              //                       const EdgeInsets.fromLTRB(40, 2, 40, 2),
              //                   alignment: Alignment.center,
              //                   child: const Row(
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.center,
              //                     children: [
              //                       Text(
              //                         "Submit",
              //                         style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 14.0,
              //                             fontWeight: FontWeight.w500,
              //                             fontFamily:
              //                                 'NeueHaasGroteskTextPro'),
              //                       ),
              //                     ],
              //                   )),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ))
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
