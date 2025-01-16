// viewProfilePage here we can see our profile in details as a user.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lm_club/app/presentation/profile/edit_profile.dart';
import 'package:lm_club/app/presentation/profile/profile_bloc.dart';
import 'package:lm_club/app/presentation/profile/profile_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../core/di/locator.dart';
import 'package:lm_club/utils/globals.dart' as globals;

class ViewProfile extends StatefulWidget {
  final String id;

  const ViewProfile({super.key, required this.id});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  // final EnrollBloc _profileBloc = getIt.get<EnrollBloc>();
  final ProfileBloc _profileBloc = getIt.get<ProfileBloc>();
  //final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String errorText = '';
  String? selectedState;

  bool containsAlphanumeric(String text) {
    RegExp regex = RegExp(r'[a-zA-Z0-9]');
    return regex.hasMatch(text);
  }

  final Map<String, String> planImages = {
    'bronze': "assets/images/bronze.png",
    'silver': 'assets/images/silver.png',
    'gold': 'assets/images/gold.png',
    'platinum': 'assets/images/platinum.png'
  };
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _profileBloc
          // ..getplan(widget.id)
          // ..getStates()
          ..getUserDetails(globals.userId),

        // ..getCities(stateId),
        child:
            BlocConsumer<ProfileBloc, ProfileState>(listener: (context, state) {
          if (state.isSuccesful!) {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => const Otp()));
            _profileBloc.getUserDetails(globals.userId);
            _profileBloc.populateUserDetails(state.userDetails!);
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
                        // QR.back();
                      },
                    ),
                    title: const Text(
                      'Profile',
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
                          // _profileBloc
                          //     .populateUserDetails(state.userDetails!);
                          // QR.to(Routes.EDITPROFILE);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditProfile()));
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
                  padding: const EdgeInsets.all(20),
                  child: Form(
                      key: _profileBloc.profileFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Username is Required';
                                } else if (value.length < 3) {
                                  return 'Username must Contain minimum 3 characters';
                                }
                                return null;
                              },
                              maxLength: 50,
                              readOnly: true,
                              enabled: true,
                              controller: _profileBloc.usernameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(184, 188, 204, 1),
                                  ),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 92, 216,
                                        21), // Customize the error border color
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
                              controller: _profileBloc.emailController,
                              maxLength: 50,
                              enabled: true,
                              readOnly: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                              controller: _profileBloc.phoneController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Phone number is Required';
                                } else if (value.length < 12) {
                                  return 'Enter a Valid 10 Digit Phone Number';
                                }
                                return null;
                              },
                              maxLength: 12,
                              enabled: true,
                              readOnly: true,
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
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter Street';
                                }

                                return null;
                              },
                              maxLength: 100,
                              enabled: true,
                              readOnly: true,
                              controller: _profileBloc.streetController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                              controller: _profileBloc.statesController,
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
                                                  _profileBloc.cityController,
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
                                                _profileBloc.zipcodeController,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _profileBloc.planTypeController,
                                  enabled: true,
                                  readOnly: true,
                                  //maxLength: 6,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    // hintText: 'LMC20',
                                    labelText: 'Plan',
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
                                  // obscureText: true,
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
                                  keyboardType: TextInputType.datetime,
                                  enabled: true,
                                  readOnly: true,
                                  controller:
                                      _profileBloc.planValidityContoller,
                                  //maxLength: 6,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    // hintText: 'LMC20',
                                    labelText: 'Plan Validity',
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
                                  // obscureText: true,
                                ),
                              ],
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
