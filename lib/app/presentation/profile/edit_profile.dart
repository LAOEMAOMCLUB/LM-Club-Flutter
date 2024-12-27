// editProfilePage we can editProfile as a user.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';
import 'package:lm_club/app/presentation/profile/profile.dart';
import 'package:lm_club/app/presentation/profile/profile_bloc.dart';
import 'package:lm_club/app/presentation/profile/profile_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:searchfield/searchfield.dart';
import '../../core/di/locator.dart';
import 'package:lm_club/utils/globals.dart' as globals;

class EditProfile extends StatefulWidget {
  final String? id;

  const EditProfile({super.key, this.id});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileBloc _profileBloc = getIt.get<ProfileBloc>();

  //final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String errorText = '';
  String? selectedState;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode1 = FocusNode();
  bool isDropdownOpen = false;
  bool isDropdownOpen1 = false;
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
          ..getUserDetails(globals.userId)
          // ..getplan(widget.id)
          ..getStates(),
        child:
            BlocConsumer<ProfileBloc, ProfileState>(listener: (context, state) {
          if (state.stateUpdated! &&
              state.stateId != null &&
              state.stateId!.id != null &&
              state.stateId!.id!.toString().isNotEmpty) {
            _profileBloc.getCities(state.stateId!);
          }
          if (state.updateUserSuccess!) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color.fromRGBO(55, 74, 156, 1),
                content: Center(
                  child: Text(
                    state.message!,
                    style: const TextStyle(
                      color: Color.fromRGBO(235, 237, 245, 1),
                      fontSize: 16,
                    ),
                  ),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
            // QR.to(Routes.PROFILE);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(id: globals.userId),
              ),
            );
          }
          if (state.isSuccesful!) {
            _profileBloc.getUserDetails(globals.userId);
            _profileBloc.populateUserDetails(state.userDetails!);

            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => const Otp()));
            // _enrollBloc.disposeControllers();
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
                        'Edit Profile',
                        style: TextStyle(
                          color: Color.fromRGBO(238, 238, 238, 1),
                          fontSize: 18,
                          fontFamily: 'NeueHaasGroteskTextPro',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      centerTitle: false,
                      elevation: 0,
                      // actions: [
                      //   IconButton(
                      //     onPressed: () {},
                      //     icon: Image.asset(
                      //       'assets/images/edit-2.png',
                      //       width: 22,
                      //       height: 22,
                      //     ),
                      //   ),
                      // ],
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
                                  errorStyle: TextStyle(
                                      fontSize: 13.0, color: Colors.red),
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
                                      color: Colors
                                          .red, // Customize the error border color
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
                                enabled: false,
                                readOnly: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  // hintText: 'Email',
                                  labelText: 'Email',
                                  counterText: "",
                                  errorStyle: TextStyle(
                                      fontSize: 13.0, color: Colors.red),
                                  labelStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(170, 170, 170, 1),
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(170, 170, 170, 1),
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
                                    color: Color.fromRGBO(170, 170, 170, 1),
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
                                enabled: false,
                                readOnly: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                  errorStyle: TextStyle(
                                      fontSize: 13.0, color: Colors.red),
                                  labelStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(170, 170, 170, 1),
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(170, 170, 170, 1),
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
                                  color: Color.fromRGBO(170, 170, 170, 1),
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
                                ],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Street is Required';
                                  }

                                  return null;
                                },
                                maxLength: 100,
                                controller: _profileBloc.streetController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
                                  labelText: 'Street',
                                  errorStyle: TextStyle(
                                      fontSize: 13.0, color: Colors.red),
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
                                      color: Colors
                                          .red, // Customize the error border color
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
                              //  key: _newListingBloc.cityKey,
                              child: SearchField(
                                  suggestionState: Suggestion.expand,
                                  focusNode: _focusNode,
                                  suggestionAction: SuggestionAction.unfocus,
                                  suggestions: state.states!
                                      .map((states) => SearchFieldListItem(
                                          states.name!,
                                          item: states.id,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 19,
                                                  right: 19,
                                                ),
                                                child: Text(
                                                  states.name!,
                                                  style: const TextStyle(
                                                      fontFamily: 'Söhne',
                                                      fontSize: 14,
                                                      color: Color.fromRGBO(
                                                          35, 44, 58, 1)),
                                                ),
                                              ),
                                            ],
                                          )))
                                      .toList(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Select State is Required';
                                    }
                                    bool stateExists = state.states!.any(
                                        (state) =>
                                            state.name!.toLowerCase() ==
                                            value.toLowerCase());
                                    if (!stateExists) {
                                      return 'State not found. Please select a valid state.';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.search,
                                  controller: _profileBloc.statesController,
                                  maxSuggestionsInViewPort: 4,
                                  itemHeight: 40,
                                  searchStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  searchInputDecoration: InputDecoration(
                                    // hintText: 'State',
                                    labelText: 'State/Province/Region',
                                    errorStyle: const TextStyle(
                                        fontSize: 13.0, color: Colors.red),
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
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(184, 188, 204, 1),
                                      ),
                                    ),
                                    errorBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors
                                            .red, // Customize the error border color
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
                                  suggestionsDecoration:
                                      SuggestionDecoration(color: Colors.white),
                                  suggestionItemDecoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                  ),
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  onSuggestionTap: (x) {
                                    StateData stateSelected = state.states!
                                        .firstWhere(
                                            (element) => element.id == x.item);
                                    _profileBloc.updateState(stateSelected);
                                  },
                                  onSubmit: (value) {
                                    if (!_profileBloc
                                        .profileFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                  }),
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
                                                            // cities.cityName!,
                                                            cities.cityName ??
                                                                '',
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
                                                                          left:
                                                                              19,
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
                                                                        color: Color.fromRGBO(
                                                                            35,
                                                                            44,
                                                                            58,
                                                                            1)),
                                                                  ),
                                                                ),
                                                              ],
                                                            )))
                                                    .toList(),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Select City is Required';
                                                  }
                                                  //   if (value.isEmpty){
                                                  // bool cityExists = state
                                                  //     .cities!
                                                  //     .any((city) =>
                                                  //         city.cityName!
                                                  //             .toLowerCase() ==
                                                  //         value.toLowerCase());
                                                  // if (!cityExists) {
                                                  //   return 'City not found. Please select a valid city.';
                                                  // }
                                                  return null;
                                                  // }
                                                },
                                                textInputAction:
                                                    TextInputAction.search,
                                                controller:
                                                    _profileBloc.cityController,
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
                                                  // hintText: 'State',
                                                  labelText: 'City/Town',
                                                  errorStyle: const TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.red),
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
                                                  border:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromRGBO(
                                                          184, 188, 204, 1),
                                                    ),
                                                  ),
                                                  errorBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors
                                                          .red, // Customize the error border color
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
                                                suggestionStyle:
                                                    const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                ),
                                                suggestionsDecoration:
                                                    SuggestionDecoration(
                                                        color: Colors.white),
                                                suggestionItemDecoration:
                                                    BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                onSuggestionTap: (p) {
                                                  // _profileBloc
                                                  //     .updateCity(p.item);

                                                  CityData citySelected = state
                                                      .cities!
                                                      .firstWhere((element) =>
                                                          element.id == p.item);
                                                  _profileBloc
                                                      .updateCity(citySelected);
                                                },
                                                onSubmit: (value) {
                                                  if (!_profileBloc
                                                      .profileFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    return;
                                                  }
                                                }),
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
                                              controller: _profileBloc
                                                  .zipcodeController,
                                              maxLength: 9,
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
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              decoration: const InputDecoration(
                                                // hintText: 'ZIP Code',
                                                errorMaxLines: 3,
                                                labelText: 'ZIP Code',
                                                errorStyle: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.red),
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
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        184, 188, 204, 1),
                                                  ),
                                                ),
                                                errorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors
                                                        .red, // Customize the error border color
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
                                                  _profileBloc.zipcodeController
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
                                    controller: _profileBloc.planTypeController,
                                    enabled: false,
                                    readOnly: true,
                                    //maxLength: 6,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: const InputDecoration(
                                      // hintText: 'LMC20',
                                      labelText: 'Plan',
                                      errorStyle: TextStyle(
                                          fontSize: 13.0, color: Colors.red),
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(170, 170, 170, 1),
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Color.fromRGBO(170, 170, 170, 1),
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
                                      color: Color.fromRGBO(170, 170, 170, 1),
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
                                    controller:
                                        _profileBloc.planValidityContoller,
                                    enabled: false,
                                    readOnly: true,
                                    //maxLength: 6,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: const InputDecoration(
                                      // hintText: 'LMC20',
                                      labelText: 'Plan Validity',
                                      errorStyle: TextStyle(
                                          fontSize: 13.0, color: Colors.red),
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(170, 170, 170, 1),
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Color.fromRGBO(170, 170, 170, 1),
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
                                      color: Color.fromRGBO(170, 170, 170, 1),
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
                bottomNavigationBar: BottomAppBar(
                                  color: Colors.transparent,
                                  elevation: 0,
                                  // height: 42,
                                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // QR.back();
                    },
                    child: Container(
                      // height: 42,
                      padding: const EdgeInsets.fromLTRB(40, 2, 40, 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color.fromRGBO(170, 170, 170, 1),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'NeueHaasGroteskTextPro',
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(116, 116, 116, 1)),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _profileBloc.updateUserDetails('');
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.transparent),
                      elevation: WidgetStateProperty.all<double>(0),
                      overlayColor: WidgetStateProperty.all<Color>(
                          Colors.transparent),
                      shape:
                          WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(55, 74, 156, 1),
                        borderRadius: BorderRadius.circular(4.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.16),
                            blurRadius: 4.0,
                            spreadRadius: 4.0,
                          ),
                        ],
                      ),
                      child: Container(
                          // width: 154,
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(40, 2, 40, 2),
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'NeueHaasGroteskTextPro'),
                              ),
                            ],
                          )),
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
