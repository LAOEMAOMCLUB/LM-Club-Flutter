// EditBusinessProfile a BusinessUser can edit there profile.

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';
import 'package:lm_club/app/presentation/business_module/business_profile/bloc/business_profile.bloc.dart';
import 'package:lm_club/app/presentation/business_module/business_profile/bloc/business_profile.state.dart';
import 'package:lm_club/app/presentation/profile/profile.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:searchfield/searchfield.dart';
import 'package:lm_club/utils/globals.dart' as globals;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class EditBusinessProfile extends StatefulWidget {
  const EditBusinessProfile({super.key, this.id});
  final String? id;
  @override
  State<EditBusinessProfile> createState() => _EditBusinessProfileState();
}

class _EditBusinessProfileState extends State<EditBusinessProfile> {
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String formattedDate = DateFormat('MM/dd/yyyy').format(selectedDate);
        _businessProfileBloc.businessEstablishDateController.text =
            formattedDate;
      });
    }
  }

  // String selectedTimeTo = 'Select Time';
  // String selectedTimeFrom = 'Select Time';

  // Future<void> _selectTimeFrom(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );

  //   if (pickedTime != null) {
  //     setState(() {
  //       selectedTimeFrom = pickedTime.format(context);
  //       _businessProfileBloc.operationHoursFromController.text =
  //           selectedTimeFrom;
  //     });
  //   }
  // }

  // Future<void> _selectTimeTo(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );

  //   if (pickedTime != null) {
  //     setState(() {
  //       selectedTimeTo = pickedTime.format(context);
  //       _businessProfileBloc.operationHoursToController.text = selectedTimeTo;
  //     });
  //   }
  // }
  String selectedTimeTo = 'Select Time';
  String selectedTimeFrom = 'Select Time';
  Future<void> _selectTimeFrom(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final localTime = DateTime(
          now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      final usTimeZone =
          tz.getLocation('America/New_York'); // Change to desired timezone
      final usTime = tz.TZDateTime.from(localTime, usTimeZone);

      setState(() {
        selectedTimeFrom =
            TimeOfDay(hour: usTime.hour, minute: usTime.minute).format(context);
        _businessProfileBloc.operationHoursFromController.text =
            selectedTimeFrom;
      });
    }
  }

  Future<void> _selectTimeTo(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final localTime = DateTime(
          now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      final usTimeZone =
          tz.getLocation('America/New_York'); // Change to desired timezone
      final usTime = tz.TZDateTime.from(localTime, usTimeZone);

      setState(() {
        selectedTimeTo =
            TimeOfDay(hour: usTime.hour, minute: usTime.minute).format(context);
        _businessProfileBloc.operationHoursToController.text = selectedTimeTo;
      });
    }
  }

  XFile? image;
  File? imageFile;
  String? selectedImage = '';
  final ImagePicker picker = ImagePicker();
  final FocusNode _focusNode = FocusNode();
  bool isDropdownOpen = false;

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(
      source: media,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    setState(() {
      image = img;
    });
    if (img != null) {
      File pickedImageFile = File(img.path);
      int maxSizeInBytes = 5 * 1024 * 1024; // 5MB in bytes
      int fileSizeInBytes = await pickedImageFile.length();
      if (fileSizeInBytes > maxSizeInBytes) {
        setState(() {
          image = null;
          imageFile = null;
          selectedImage = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Center(
              child: Text(
                'Selected image exceeds 5MB.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      } else {
        setState(() {
          imageFile = File(img.path);
          selectedImage = imageFile!.path;
          String? fileName = selectedImage!.split('/').last;
          _businessProfileBloc.logoController.text = fileName;
        });
      }
    }
    _businessProfileBloc.uploadImage(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _businessProfileBloc
          ..getUserDetails(globals.userId)
          ..getStates(),
        child: BlocConsumer<BusinessProfileBloc, BusinessProfileState>(
            listener: (context, state) {
          if (state.stateUpdated &&
              state.stateId != null &&
              state.stateId!.id != null &&
              state.stateId!.id!.toString().isNotEmpty) {
            _businessProfileBloc.getCities(state.stateId!);
          }
          if (state.isSuccesful!) {
            _businessProfileBloc.getUserDetails(globals.userId);
            _businessProfileBloc.populateUserDetails(state.userDetails!);
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(id: globals.userId),
              ),
            );
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
                        'Edit Business Profile',
                        style: TextStyle(
                          color: Color.fromRGBO(238, 238, 238, 1),
                          fontSize: 18,
                          fontFamily: 'NeueHaasGroteskTextPro',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      centerTitle: false,
                      elevation: 0,
                      actions: const [
                        // IconButton(
                        //   onPressed: () {
                        //     // _businessProfileBloc
                        //     //     .populateUserDetails(state.userDetails!);
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => const EditProfile()));
                        //   },
                        //   icon: Image.asset(
                        //     'assets/images/edit-2.png',
                        //     width: 22,
                        //     height: 22,
                        //   ),
                        // ),
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
                                controller:
                                    _businessProfileBloc.emailController,
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: 'Email is Required'),
                                  EmailValidator(
                                      errorText:
                                          'Please Enter a Valid Email Address'),
                                ]),

                                maxLength: 50,
                                readOnly: true,
                                enabled: false,
                                // autovalidateMode:
                                //     AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  labelText: 'Business Email',
                                  counterText: "",
                                  errorStyle: TextStyle(fontSize: 13.0),
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
                                controller:
                                    _businessProfileBloc.phoneController,
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
                                enabled: false,
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
                              // key: _newListingBloc.cityKey,

                              child: SearchField(
                                  suggestionState: Suggestion.expand,
                                  focusNode: _focusNode,
                                  suggestionAction: SuggestionAction.unfocus,
                                  suggestions: states
                                      .map((states) => SearchFieldListItem(
                                          states.searchKey,
                                          item: states.searchKey,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 19, right: 19),
                                                child: Center(
                                                  child: Text(
                                                    states.searchKey,
                                                    style: const TextStyle(
                                                        fontFamily: 'Söhne',
                                                        fontSize: 14,
                                                        color: Color.fromRGBO(
                                                            35, 44, 58, 1)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )))
                                      .toList(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Business By is Required';
                                    }
                                    bool stateExists = states.any((states) =>
                                        states.searchKey.toLowerCase() ==
                                        value.toLowerCase());
                                    if (!stateExists) {
                                      return 'Business By not found. Please select a valid business By.';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.search,
                                  controller:
                                      _businessProfileBloc.businessByController,
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
                                    labelText: 'Business By',
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
                                    // borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  suggestionsDecoration: SuggestionDecoration(),
                                  onSuggestionTap: (x) {
                                    selectedBusinessType = x.searchKey;
                                    _businessProfileBloc.businessByController
                                        .text = selectedBusinessType!;
                                  },
                                  onSubmit: (value) {
                                    if (!_businessProfileBloc
                                        .businessProfileFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                  }),
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
                                onTap: () {
                                  _selectDate(context);
                                },
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
                                    decoration: InputDecoration(
                                      labelText: 'Business Establish Date',
                                      // hintText: '31 Oct 2023',
                                      errorStyle:
                                          const TextStyle(fontSize: 13.0),
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
                                controller:
                                    _businessProfileBloc.streetController,
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
                                  // bool stateExists = state.states.any((state) =>
                                  //     state.name!.toLowerCase() ==
                                  //     value.toLowerCase());
                                  // if (!stateExists) {
                                  //   return 'State not found. Please select a valid state.';
                                  // }
                                  return null;
                                },
                                textInputAction: TextInputAction.search,
                                controller:
                                    _businessProfileBloc.statesController,
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
                                  suffixIcon: Image.asset(
                                    "assets/images/dropdown.png",
                                    width: 23.0,
                                    height: 23.0,
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
                                  StateData stateSelected = state.states!
                                      .firstWhere(
                                          (element) => element.id == x.item);
                                  _businessProfileBloc
                                      .updateState(stateSelected);
                                },
                                onSubmit: (value) {
                                  if (!_businessProfileBloc
                                      .businessProfileFormKey.currentState!
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
                                                // bool cityExists = state.cities!
                                                //     .any((city) =>
                                                //         city.cityName!
                                                //             .toLowerCase() ==
                                                //         value.toLowerCase());
                                                // if (!cityExists) {
                                                //   return 'City not found. Please select a valid city.';
                                                // }
                                                return null;
                                              },
                                              textInputAction:
                                                  TextInputAction.search,
                                              controller: _businessProfileBloc
                                                  .cityController,
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
                                                suffixIcon: Image.asset(
                                                  "assets/images/dropdown.png",
                                                  width: 23.0,
                                                  height: 23.0,
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
                                                _businessProfileBloc
                                                    .updateCity(citySelected);
                                              },
                                              onSubmit: (value) {
                                                if (!_businessProfileBloc
                                                    .businessProfileFormKey
                                                    .currentState!
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
                                              controller: _businessProfileBloc
                                                  .zipcodeController,
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
                                                  _businessProfileBloc
                                                      .zipcodeController
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
                                  top: 15.0,
                                  left: 8.0,
                                  bottom: 8.0,
                                  right: 8.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  onTap: () async {
                                                    _selectTimeFrom(context);
                                                  },
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
                                                //
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
                                                        onTap: () async {
                                                          _selectTimeTo(
                                                              context);
                                                        },
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
                bottomNavigationBar: Container(
                    // height: 50,
                    margin:
                        const EdgeInsets.only(top: 20, bottom: 20, left: 20),
                    child: BottomAppBar(
                      color: Colors.transparent,
                      elevation: 0,
                      height: 42,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 42,
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
                              _businessProfileBloc.updateBusinessUserDetails();
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.transparent),
                              elevation: WidgetStateProperty.all<double>(0),
                              overlayColor: WidgetStateProperty.all<Color>(
                                  Colors.transparent),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
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
                                  height: 42,
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 2, 40, 2),
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
                                            fontFamily:
                                                'NeueHaasGroteskTextPro'),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ))),
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

  void showImageSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
              child: Text("Select Source",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'NeueHaasGroteskTextPro',
                    color: Color.fromRGBO(55, 74, 156, 1),
                  ))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text("Gallery",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NeueHaasGroteskTextPro',
                        color: Color.fromRGBO(35, 44, 58, 1),
                      )),
                  onTap: () {
                    getImage(ImageSource.gallery);
                    Navigator.pop(context);
                    //   _profileBloc.uploadImage(image!.path);
                    // _profileBloc.uploadProfileImage(image!.path);
                  },
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  child: const Text("Camera",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NeueHaasGroteskTextPro',
                        color: Color.fromRGBO(35, 44, 58, 1),
                      )),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.pop(context);

                    // _profileBloc.uploadImage(image!.path);
                    // _profileBloc.uploadProfileImage(image!.path);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
