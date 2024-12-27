import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/models/auth/request_model/business_broadcast_request_model.dart';
import 'package:lm_club/app/presentation/business_module/business-broadcast/bloc/businessbroadcast_bloc.dart';
import 'package:lm_club/app/presentation/business_module/business-broadcast/bloc/businessbroadcast_state.dart';
import 'package:lm_club/app/presentation/webpages/webview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:searchfield/searchfield.dart';
import 'package:video_player/video_player.dart';
import '../../../../../routes/app_routes.dart';
import 'package:lm_club/utils/globals.dart' as globals;

enum MediaType { images, videos }

class BusinessCreatePost extends StatefulWidget {
  const BusinessCreatePost({Key? key}) : super(key: key);

  @override
  State<BusinessCreatePost> createState() => _BusinessCreatePostState();
}

class _BusinessCreatePostState extends State<BusinessCreatePost> {
  String? promotingText = '';
  String? durationId = '';
  String? keyAmount = '';
  String? planDescription = '';
  String? lengthFlag = '';
  MediaType? currentMediaType; // Track current media type, initially null
  int? selectedTileIndex;
  XFile? image;
  File? _video;
  File? imageFile;
  List<String> imageFiles = [];
  List<File> uploadedFiles = [];
  final FocusNode _focusNode = FocusNode();
  bool isDropdownOpen = false;
  DateTime selectedDate = DateTime.now();
  bool isValidAddress(String address) {
    return address.trim().length >= 5;
  }

  final ImagePicker picker = ImagePicker();
  Future<void> getImage(ImageSource media, {MediaType? mediaType}) async {
    setState(() {
      imageFiles = [];
    });

    if (media == ImageSource.camera) {
      PermissionStatus status = await Permission.camera.request();
      if (status.isGranted) {
        if (currentMediaType != null && currentMediaType != mediaType) {
          // Throw an error if there's a conflict in media type
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'You can only upload either images or videos, not both at the same time.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        if (mediaType == MediaType.videos) {
          XFile? pickedFile = await picker.pickVideo(
            source: media,
            maxDuration: const Duration(minutes: 2),
          );
          if (pickedFile != null) {
            File videoFile = File(pickedFile.path);
            int fileSizeInBytes = await videoFile.length();
            if (fileSizeInBytes < 20 * 1024 * 1024) {
              List<String> allFilePaths = imageFiles;
              allFilePaths.add(pickedFile.path);
              _video = videoFile;

              setState(() {
                imageFiles = allFilePaths;
                currentMediaType =
                    MediaType.videos; // Set current media type to images
              });

              uploadedFiles = allFilePaths.map((path) => File(path)).toList();

              //_businessBroadcastBloc.uploadImage(uploadedFiles);
            } else {
              // Video size is greater than 20MB
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select a video smaller than 20MB.'),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } else {
          XFile? pickedImage = await picker.pickImage(
            source: media,
            // maxWidth: 800,
            // maxHeight: 800,
            // imageQuality: 80,
          );
          if (pickedImage != null) {
            File imageFile = File(pickedImage.path);
            int fileSizeInBytes = await imageFile.length();
            if (fileSizeInBytes < 20 * 1024 * 1024) {
              List<String> allFilePaths = imageFiles;
              allFilePaths.add(pickedImage.path);

              setState(() {
                imageFiles = allFilePaths;
                currentMediaType =
                    MediaType.images; // Set current media type to images
              });

              uploadedFiles = allFilePaths.map((path) => File(path)).toList();

              // _businessBroadcastBloc.uploadImage(uploadedFiles);
            } else {
              // Image size is greater than 20MB
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select an image smaller than 20MB.'),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      } else {
        // Handle when camera permission is not granted.
      }
    } else {
      // Gallery selection

      if (currentMediaType != null && currentMediaType != mediaType) {
        // Throw an error if there's a conflict in media type
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'You can only upload either images or videos, not both at the same time.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (mediaType == MediaType.videos) {
        final XFile? pickedFile = await picker.pickVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(minutes: 2),
        );
        if (pickedFile != null) {
          File videoFile = File(pickedFile.path);
          int fileSizeInBytes = await videoFile.length();
          if (fileSizeInBytes < 20 * 1024 * 1024) {
            List<String> allFilePaths = imageFiles;
            allFilePaths.add(pickedFile.path);
            _video = videoFile;

            setState(() {
              imageFiles = allFilePaths;
              currentMediaType =
                  MediaType.videos; // Set current media type to images
            });

            uploadedFiles = allFilePaths.map((path) => File(path)).toList();

            //  _businessBroadcastBloc.uploadImage(uploadedFiles);
          } else {
            // Video size is greater than 20MB
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select a video smaller than 20MB.'),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else if (mediaType == MediaType.images) {
        List<XFile>? pickedImages = await picker.pickMultiImage(
            // maxWidth: 800,
            // maxHeight: 800,
            // imageQuality: 80,
            );
        if (pickedImages.isNotEmpty) {
          int totalSize = 0;
          List<String> allowedExtensions = ['jpg', 'jpeg', 'png'];
          List<String> validImageFiles = [];
          List<File> fileObjects = [];

          for (XFile image in pickedImages) {
            File file = File(image.path);
            int fileSize = await file.length();
            String extension = image.path.split('.').last.toLowerCase();

            if (fileSize + totalSize <= 20 * 1024 * 1024) {
              if (allowedExtensions.contains(extension)) {
                totalSize += fileSize;
                validImageFiles.add(image.path);
                fileObjects.add(file);
                uploadedFiles.addAll(fileObjects);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Please select images in JPG, JPEG, or PNG format.'),
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Please select images whose total size is less than 20MB.'),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
          }
          // List<String> validImageFiles = pickedImages
          //     .where((image) => allowedExtensions
          //         .contains(image.path.split('.').last.toLowerCase()))
          //     .map((image) => image.path)
          //     .toList();
          // List<File> fileObjects =
          //     pickedImages.map((xfile) => File(xfile.path)).toList();

          // uploadedFiles.addAll(fileObjects);

          if (validImageFiles.isNotEmpty) {
            setState(() {
              imageFiles = validImageFiles;
              currentMediaType =
                  MediaType.images; // Set current media type to images
            });

            // _businessBroadcastBloc.uploadImage(uploadedFiles);
          }
        }
      }
    }
  }

  List<SearchFieldListItem<String>> suggestions = [
    SearchFieldListItem("Coupons"),
    SearchFieldListItem("Incentives"),
    SearchFieldListItem("Sales"),
    SearchFieldListItem("Others"),
  ];

  final List<MyObject> myObjects = [
    MyObject(name: '1 day', value: '30'),
    MyObject(name: '1 Week', value: '150'),
    MyObject(name: '1 Month', value: '650'),
  ];
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        String formattedDate = DateFormat('MM/dd/yyyy').format(picked);

        _businessBroadcastBloc.validFromController.text = formattedDate;
      });
    }
  }

  final BusinessBroadcastBloc _businessBroadcastBloc =
      getIt.get<BusinessBroadcastBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _businessBroadcastBloc..fetchBroadcastPlans(),
      child: BlocConsumer<BusinessBroadcastBloc, BusinessBroadcastState>(
          listener: (context, state) {
        if (state.isDraftSuccesful!) {
          QR.to(Routes.BROADCAST);
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => const Brodcast()));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color.fromARGB(
                  255, 67, 194, 17), // Change background color of SnackBar
              content: Center(
                child: Text(
                  state.uploadPostDraftMessage!,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 28, 28,
                        28), // Change text color of SnackBar content
                    fontSize: 16, // Change font size of SnackBar content
                    // Add other text styles as needed
                  ),
                ),
              ),
              duration: const Duration(seconds: 2), // Adjust duration as needed
            ),
          );
        } else if ((state.isSuccesful ?? false) &&
            (state.uploadPostMessage?.isNotEmpty ?? false)) {
          QR.to(Routes.POST_SUCCESS);
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
                        },
                      ),
                      title: const Text(
                        'Post Ad',
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
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                      child: Form(
                          key: _businessBroadcastBloc.businessBroadcastFormKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                globals.broadcast
                                    ? Column(children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RichText(
                                              text: const TextSpan(
                                                text: 'Choose your plan, get ',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color.fromRGBO(
                                                        35, 44, 58, 1)),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: 'Premium Access',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            35, 44, 58, 1),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text: ', And Post your AD',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Color.fromRGBO(
                                                            35, 44, 58, 1)),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        Row(
                                          children: state.broadcastPlanDetails!
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            final currentObject = entry.value;
                                            final index = currentObject.id;
                                            final isSelected =
                                                selectedTileIndex == index;
                                            return Expanded(
                                                child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedTileIndex =
                                                            index;
                                                        planDescription =
                                                            currentObject
                                                                    .description ??
                                                                '';
                                                        keyAmount =
                                                            currentObject.key!;
                                                        lengthFlag =
                                                            currentObject.flag!;

                                                        _businessBroadcastBloc
                                                            .postDurationController
                                                            .text = lengthFlag!;
                                                      });
                                                    },
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .all(
                                                          8.0), // Add margin as needed
                                                      decoration: BoxDecoration(
                                                        border: isSelected
                                                            ? Border.all(
                                                                color: const Color
                                                                    .fromRGBO(0,
                                                                    176, 80, 1))
                                                            : Border.all(
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    184,
                                                                    188,
                                                                    204,
                                                                    1)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        // Add other decoration properties as needed
                                                      ),
                                                      child: ListTile(
                                                        title: Center(
                                                            child: Text(
                                                          currentObject.flag!
                                                              .split("for")[1]
                                                              .trim(),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: isSelected
                                                                  ? const Color
                                                                      .fromRGBO(
                                                                      0,
                                                                      176,
                                                                      80,
                                                                      1)
                                                                  : const Color
                                                                      .fromRGBO(
                                                                      35,
                                                                      44,
                                                                      58,
                                                                      1)),
                                                        )),
                                                        subtitle: Center(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Divider(
                                                              color: isSelected
                                                                  ? const Color
                                                                      .fromRGBO(
                                                                      0,
                                                                      176,
                                                                      80,
                                                                      1)
                                                                  : const Color
                                                                      .fromRGBO(
                                                                      35,
                                                                      44,
                                                                      58,
                                                                      1),
                                                            ), // Add a line between name and value
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  '\$',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: isSelected
                                                                        ? const Color
                                                                            .fromRGBO(
                                                                            0,
                                                                            176,
                                                                            80,
                                                                            1)
                                                                        : const Color
                                                                            .fromRGBO(
                                                                            35,
                                                                            44,
                                                                            58,
                                                                            1),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  currentObject
                                                                      .key!,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: isSelected
                                                                        ? const Color
                                                                            .fromRGBO(
                                                                            0,
                                                                            176,
                                                                            80,
                                                                            1)
                                                                        : const Color
                                                                            .fromRGBO(
                                                                            35,
                                                                            44,
                                                                            58,
                                                                            1),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        )),
                                                      ),
                                                    )));
                                          }).toList(),
                                        ),
                                        // const Padding(
                                        //   padding: EdgeInsets.all(8.0),
                                        //   child: Text(
                                        //     'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.',
                                        //     style: TextStyle(
                                        //         fontSize: 12,
                                        //         fontWeight: FontWeight.normal,
                                        //         color: Color.fromRGBO(35, 44, 58, 1)),
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.phone,
                                            controller: _businessBroadcastBloc
                                                .postDurationController,
                                            // autovalidateMode:
                                            //     AutovalidateMode.onUserInteraction,
                                            readOnly: true,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Length of promotion is Required';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Length of Ad/Promotion (days)',
                                              errorStyle:
                                                  TextStyle(fontSize: 13.0),
                                              labelStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      116, 116, 116, 1),
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w500),
                                              hintStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                  fontSize: 13,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w400),
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
                                        )
                                      ])
                                    : const SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SearchField(
                                      suggestionState: Suggestion.expand,
                                      focusNode: _focusNode,
                                      suggestionAction:
                                          SuggestionAction.unfocus,
                                      controller: _businessBroadcastBloc
                                          .promotingController,
                                      suggestions: suggestions
                                          .map((suggestions) =>
                                              SearchFieldListItem(
                                                  suggestions.searchKey,
                                                  item: suggestions.searchKey,
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
                                                                right: 19),
                                                        child: Center(
                                                          child: Text(
                                                            suggestions
                                                                .searchKey,
                                                            style:
                                                                const TextStyle(
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
                                                      ),
                                                    ],
                                                  )))
                                          .toList(),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Select Promoting is Required';
                                        }
                                        bool stateExists = suggestions.any(
                                            (state) =>
                                                state.searchKey.toLowerCase() ==
                                                value.toLowerCase());
                                        if (!stateExists) {
                                          return 'Promoting not found. Please select a valid promoting.';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.search,
                                      // controller:,
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
                                        labelText: 'What are you promoting',
                                        errorStyle:
                                            const TextStyle(fontSize: 13.0),
                                        labelStyle: const TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(116, 116, 116, 1),
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        hintStyle: const TextStyle(
                                          color: Color.fromRGBO(35, 44, 58, 1),
                                          fontSize: 13,
                                          fontFamily: 'NeueHaasGroteskTextPro',
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
                                      // suggestionsDecoration: SuggestionDecoration(),
                                      onSuggestionTap: (x) {
                                        setState(() {
                                          promotingText = x.searchKey;
                                        });
                                      },
                                      onSubmit: (value) {
                                        if (!_businessBroadcastBloc
                                            .webFormKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                      }),
                                ),
                                // if (promotingText == 'Coupons')
                                //   Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: TextFormField(
                                //       keyboardType: TextInputType.phone,
                                //       controller: _businessBroadcastBloc
                                //           .couponCodeController,
                                //       decoration: const InputDecoration(
                                //         labelText: 'Coupon Code',
                                //         errorStyle: TextStyle(fontSize: 13.0),
                                //         labelStyle: TextStyle(
                                //             fontSize: 14,
                                //             color: Color.fromRGBO(
                                //                 116, 116, 116, 1),
                                //             fontFamily:
                                //                 'NeueHaasGroteskTextPro',
                                //             fontWeight: FontWeight.w500),
                                //         hintStyle: TextStyle(
                                //             color:
                                //                 Color.fromRGBO(35, 44, 58, 1),
                                //             fontSize: 13,
                                //             fontFamily:
                                //                 'NeueHaasGroteskTextPro',
                                //             fontWeight: FontWeight.w400),
                                //         enabledBorder: UnderlineInputBorder(
                                //           borderSide: BorderSide(
                                //             color: Color.fromRGBO(
                                //                 184, 188, 204, 1),
                                //           ),
                                //         ),
                                //         focusedBorder: UnderlineInputBorder(
                                //           borderSide: BorderSide(
                                //             color: Color.fromRGBO(
                                //                 184, 188, 204, 1),
                                //           ),
                                //         ),
                                //       ),
                                //       style: const TextStyle(
                                //           color: Color.fromRGBO(35, 44, 58, 1),
                                //           fontSize: 13,
                                //           fontFamily: 'NeueHaasGroteskTextPro',
                                //           fontWeight: FontWeight.w400),
                                //     ),
                                //   ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        keyboardType: TextInputType.datetime,
                                        controller: _businessBroadcastBloc
                                            .validFromController,
                                        // autovalidateMode:
                                        //     AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Valid Date is Required';
                                          }
                                          if (!isValidAddress(value)) {
                                            return 'Valid Date is Required';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Ad/Promotion Start date',
                                          // hintText: '31 Oct 2023',
                                          errorStyle: TextStyle(fontSize: 13.0),
                                          labelStyle: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromRGBO(
                                                116, 116, 116, 1),
                                            fontFamily:
                                                'NeueHaasGroteskTextPro',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          hintStyle: TextStyle(
                                            color:
                                                Color.fromRGBO(35, 44, 58, 1),
                                            fontSize: 13,
                                            fontFamily:
                                                'NeueHaasGroteskTextPro',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  184, 188, 204, 1),
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  184, 188, 204, 1),
                                            ),
                                          ),

                                          suffixIcon: Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            // child: Image.asset(
                                            //   "assets/images/note.png",
                                            //   width: 10.0,
                                            //   height: 10.0,
                                            //   color: const Color.fromRGBO(
                                            //       116, 116, 116, 1),
                                            // ),
                                            child: Icon(
                                              Icons.calendar_today,
                                              size: 20.0,
                                              color: Color.fromRGBO(
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    // keyboardType: TextInputType.,
                                    controller:
                                        _businessBroadcastBloc.titleController,
                                    // autovalidateMode:
                                    //     AutovalidateMode.onUserInteraction,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'^\s+')),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z\s]')),
                                    ],
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Title is Required';
                                      }
                                      // if (!isValidAddress(value)) {
                                      //   return 'Business Person name is Required';
                                      // }
                                      return null;
                                    },
                                    maxLength: 50,
                                    decoration: const InputDecoration(
                                      labelText: 'Ad Post Title',
                                      errorStyle: TextStyle(fontSize: 13.0),
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(116, 116, 116, 1),
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w500),
                                      hintStyle: TextStyle(
                                          color: Color.fromRGBO(35, 44, 58, 1),
                                          fontSize: 13,
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w400),
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
                                    ),
                                    style: const TextStyle(
                                        color: Color.fromRGBO(35, 44, 58, 1),
                                        fontSize: 13,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                    'Ad post Media',
                                    style: TextStyle(
                                        color: Color.fromRGBO(35, 44, 58, 1),
                                        fontSize: 13,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w400),
                                    // textAlign: TextAlign.left,
                                  ),
                                ),
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.fromLTRB(0, 13, 0, 22),
                                //   child: GestureDetector(
                                //     onTap: () {
                                //       showImageSelectionDialog();
                                //       // _broadcastBloc.uploadImage(
                                //       //     imageFile, image!.path);
                                //     },
                                //     child: Container(
                                //       decoration: BoxDecoration(
                                //         color: Colors.white,
                                //         borderRadius: BorderRadius.circular(10),
                                //       ),
                                //       width: MediaQuery.of(context).size.width,
                                //       height: 80.0,
                                //       child: DottedBorder(
                                //         borderType: BorderType.RRect,
                                //         radius: const Radius.circular(10),
                                //         dashPattern: const [6, 4],
                                //         color: const Color.fromRGBO(
                                //             184, 188, 204, 1),
                                //         strokeWidth: 1,
                                //         child: Align(
                                //           alignment: Alignment.center,
                                //           child: Column(
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment.center,
                                //             children: <Widget>[
                                //               Image.asset(
                                //                 "assets/images/upload.png",
                                //                 width: 23.0,
                                //                 height: 23.0,
                                //               ),
                                //               const SizedBox(
                                //                 height: 4.0,
                                //               ),
                                //               // ElevatedButton(
                                //               //   onPressed: () {
                                //               //     getImage(ImageSource.gallery);
                                //               //     _broadcastBloc.uploadImage(
                                //               //         imageFile, image!.path);
                                //               //   },
                                //               const Text(
                                //                 "Upload Photo / Video",
                                //                 style: TextStyle(
                                //                   fontSize: 12.0,
                                //                   fontFamily:
                                //                       'NeueHaasGroteskTextPro',
                                //                   color: Color.fromRGBO(
                                //                       35, 44, 58, 1),
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // QR.back();
                                        showMediaSelectionDialog(
                                            context, ImageSource.camera);
                                      },
                                      // onTap: () {
                                      //   getImage(ImageSource.camera);
                                      // },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 45.0,
                                        child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(10),
                                          dashPattern: const [6, 4],
                                          color: const Color.fromRGBO(
                                              55, 74, 156, 1),
                                          strokeWidth: 1,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                  "assets/images/boldcamera.png",
                                                  width: 23.0,
                                                  height: 23.0,
                                                  color: const Color.fromRGBO(
                                                      55, 74, 156, 1),
                                                ),
                                                const SizedBox(width: 10),
                                                const Text(
                                                  "Take a Picture/Video",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontFamily:
                                                        'NeueHaasGroteskTextPro',
                                                    color: Color.fromRGBO(
                                                        55, 74, 156, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                                const Center(
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      color: Color.fromRGBO(170, 170, 170, 1),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      // onTap: () {
                                      //   getImage(ImageSource.gallery);
                                      // },
                                      onTap: () {
                                        //   QR.back();
                                        showMediaSelectionDialog(
                                            context, ImageSource.gallery);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 80.0,
                                        child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(10),
                                          dashPattern: const [6, 4],
                                          color: const Color.fromRGBO(
                                              55, 74, 156, 1),
                                          strokeWidth: 1,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                  "assets/images/upload.png",
                                                  width: 23.0,
                                                  height: 23.0,
                                                  color: const Color.fromRGBO(
                                                      55, 74, 156, 1),
                                                ),
                                                const SizedBox(
                                                  height: 4.0,
                                                ),
                                                const Text(
                                                  "Upload Picture/Video",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontFamily:
                                                        'NeueHaasGroteskTextPro',
                                                    color: Color.fromRGBO(
                                                        55, 74, 156, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 22),
                                  child: imageFiles.isNotEmpty
                                      ? SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children:
                                                buildImageList(uploadedFiles),
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 18),
                                    child: TextFormField(
                                      controller: _businessBroadcastBloc
                                          .descriptionController,
                                      // autovalidateMode:
                                      //     AutovalidateMode.onUserInteraction,
                                      maxLength: 500,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Description is Required';
                                        } else if (value.length >= 500) {
                                          return 'Description cannot be more than 500 characters';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        counterStyle: TextStyle(
                                          height: double.minPositive,
                                        ),
                                        counterText: "",
                                        labelText: 'Description',
                                        // hintText: 'Add desc',
                                        errorStyle: TextStyle(fontSize: 13.0),
                                        labelStyle: TextStyle(
                                          fontSize: 13,
                                          color:
                                              Color.fromRGBO(116, 116, 116, 1),
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
                                            color: Color.fromRGBO(
                                                184, 188, 204, 1),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                184, 188, 204, 1),
                                          ),
                                        ),
                                      ),
                                      style: const TextStyle(
                                        color: Color.fromRGBO(35, 44, 58, 1),
                                        fontSize: 13,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                              ]))),
                ),
                bottomNavigationBar: Container(
                    // height: 50,
                    margin:
                        const EdgeInsets.only(top: 20, bottom: 30, left: 20),
                    child: BottomAppBar(
                      color: Colors.transparent,
                      elevation: 0,
                      height: 42,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              // if (_businessBroadcastBloc
                              //     .businessBroadcastFormKey.currentState!
                              //     .validate()) {
                              //   if (imageFiles.isEmpty) {
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       const SnackBar(
                              //         backgroundColor: Colors.red,
                              //         content: Center(
                              //           child: Text(
                              //             ('Please upload an image.'),
                              //             style: TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 16,
                              //             ),
                              //           ),
                              //         ),
                              //         duration: Duration(seconds: 3),
                              //       ),
                              //     );
                              //   } else if (keyAmount!.isEmpty) {
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       const SnackBar(
                              //         backgroundColor: Colors.red,
                              //         content: Center(
                              //           child: Text(
                              //             ('Please Select Plan Amount.'),
                              //             style: TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 16,
                              //             ),
                              //           ),
                              //         ),
                              //         duration: Duration(seconds: 3),
                              //       ),
                              //     );
                              //   } else {
                              if (_businessBroadcastBloc
                                  .postDurationController.text.isEmpty) {
                                _businessBroadcastBloc.postDurationController
                                    .text = 'Broadcast Plan for 1 Day';
                              }

                              final request = BusinessBroadcastModel(
                                  image: uploadedFiles,
                                  title: _businessBroadcastBloc
                                      .titleController.text,
                                  description: _businessBroadcastBloc
                                      .descriptionController.text,
                                  isDrafted: 'true',
                                  whatPromoting: promotingText,
                                  postDuration: _businessBroadcastBloc
                                      .postDurationController.text,
                                  couponCode: _businessBroadcastBloc
                                      .couponCodeController.text,
                                  validDate: _businessBroadcastBloc
                                      .validFromController.text);
                              _businessBroadcastBloc
                                  .uploadSavedBroadcast(request);
                              QR.back();
                              QR.to(Routes.MY_DRAFTS);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             MyDrafts(id: globals.userId)));
                              //   }
                              // }
                            },
                            child: Container(
                              height: 42,
                              padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: const Color.fromRGBO(55, 74, 156, 1),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Save as Draft',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(55, 74, 156, 1)),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_businessBroadcastBloc
                                  .businessBroadcastFormKey.currentState!
                                  .validate()) {
                                if (uploadedFiles.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Center(
                                        child: Text(
                                          ('Please upload an image/video.'),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                } else if (globals.broadcast &&
                                    keyAmount!.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Center(
                                        child: Text(
                                          ('Please Select Plan Amount.'),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                } else {
                                  final request = BusinessBroadcastModel(
                                      image: uploadedFiles,
                                      title: _businessBroadcastBloc
                                          .titleController.text,
                                      description: _businessBroadcastBloc
                                          .descriptionController.text,
                                      isDrafted: 'false',
                                      whatPromoting: promotingText,
                                      postDuration: _businessBroadcastBloc
                                          .postDurationController.text,
                                      couponCode: _businessBroadcastBloc
                                          .couponCodeController.text,
                                      validDate: _businessBroadcastBloc
                                          .validFromController.text);
                                  showTerms(request);
                                }
                              }
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
                                // gradient: const LinearGradient(
                                //   colors: [
                                //     Color(0xFF93C471),
                                //     Color(0xFF4B742F)
                                //   ],
                                //   begin: Alignment.topCenter,
                                //   end: Alignment.bottomCenter,
                                // ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Container(
                                  // width: 154,
                                  height: 42,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 2, 20, 2),
                                  alignment: Alignment.center,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Proceed",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily:
                                                'NeueHaasGroteskTextPro'),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 15,
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
                color: Colors.transparent.withOpacity(0.2),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.hexagonDots(
                        size: 35,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 10),
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
          ]),
        );
      }),
    );
  }

  List<Widget> buildImageList(List<File> imageFiles) {
    return List.generate(imageFiles.length, (index) {
      bool isImage = imageFiles[index].path.toLowerCase().endsWith('.jpg') ||
          imageFiles[index].path.toLowerCase().endsWith('.jpeg') ||
          imageFiles[index].path.toLowerCase().endsWith('.png');
      bool isVideo = imageFiles[index].path.toLowerCase().endsWith('.mp4') ||
          imageFiles[index].path.toLowerCase().endsWith('.avi') ||
          imageFiles[index].path.toLowerCase().endsWith('.mov');
      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0), // Adjust spacing as needed
        child: Stack(
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              width: 90, // Adjust the width as needed
              height: 90, // Adjust the height as needed
              child: isImage
                  ? Image.file(
                      File(imageFiles[index].path),
                      fit: BoxFit.fill,
                    )
                  : isVideo
                      ? GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => VideoDialog(videoFile: _video!),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/video_thumbnail1.png',
                                // height: 150,
                                // width: 150,
                                fit: BoxFit.fill,
                              ),
                              // SizedBox(height: 20),
                              // Text('Tap to play'),
                            ],
                          ),
                        )
                      : const SizedBox(),
            ),
            Positioned(
              top: 5,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    imageFiles.removeAt(index);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Color.fromARGB(255, 230, 25, 25),
                    size: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void showMediaSelectionDialog(BuildContext context, media) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "Select Media Type",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'NeueHaasGroteskTextPro',
                color: Color.fromRGBO(55, 74, 156, 1),
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text(
                    "Picture",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'NeueHaasGroteskTextPro',
                      color: Color.fromRGBO(35, 44, 58, 1),
                    ),
                  ),
                  onTap: () {
                    getImage(media, mediaType: MediaType.images);
                    QR.back();
                  },
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  child: const Text(
                    "Video",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'NeueHaasGroteskTextPro',
                      color: Color.fromRGBO(35, 44, 58, 1),
                    ),
                  ),
                  onTap: () {
                    getImage(media, mediaType: MediaType.videos);
                    QR.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showTerms(BusinessBroadcastModel request) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool termsAccepted = false;
        bool continueClicked = true;
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              'Terms & Conditions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'NeueHaasGroteskTextPro',
                color: Color.fromRGBO(55, 74, 156, 1),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: [
                const Flexible(
                    child: SingleChildScrollView(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Please Read and Accept Our Terms & Conditions',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NeueHaasGroteskTextPro',
                                color: Color.fromRGBO(35, 44, 58, 1),
                              ),
                            ),
                            Text(
                              '\nBefore you continue, we require you to read and agree to our Terms & Conditions. This ensures you understand your rights and our obligations, providing a safe and enjoyable environment for all users.',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'NeueHaasGroteskTextPro',
                                color: Color.fromRGBO(35, 44, 58, 1),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: termsAccepted,
                      onChanged: (bool? value) {
                        setState(() {
                          termsAccepted = value ?? false;
                          continueClicked = false;
                        });
                      },
                      checkColor: const Color.fromARGB(255, 48, 117, 201),
                      fillColor: WidgetStateProperty.all<Color>(
                          const Color.fromARGB(255, 186, 186, 186)),

                      // visualDensity: VisualDensity.compact,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WebView(),
                            ),
                          );
                        },
                        child: const Text(
                          'I agree to the terms and conditions',
                          style: TextStyle(
                            color: Color.fromRGBO(78, 76, 117, 1),
                            fontSize: 12.0,
                            fontFamily: 'NeueHaasGroteskTextPro',
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: Color.fromRGBO(55, 74, 156, 1),
                            decorationThickness: 1.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: termsAccepted && !continueClicked,
                  child: ElevatedButton(
                    onPressed: termsAccepted
                        ? () {
                            if (globals.broadcast) {
                              QR.back();
                              clearForm();
                              QR.toName(Routes.BUSINESS_PAYPAL.name, params: {
                                'amount': keyAmount!,
                                'description': 'Test Des',
                                'request': request
                              });
                            } else {
                              QR.back();
                              if (request.image != null) {
                                _businessBroadcastBloc
                                    .uploadBusinessBroadcast(request);
                              } else {
                                _businessBroadcastBloc
                                    .editDraftBusinessBroadcast(request);
                              }
                            }
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.transparent),
                      elevation: WidgetStateProperty.all<double>(0),
                      overlayColor:
                          WidgetStateProperty.all<Color>(Colors.transparent),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34.0),
                        ),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(55, 74, 156, 1),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                        alignment: Alignment.center,
                        child: const Text(
                          "Continue",
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
                )
              ]);
            },
          ),
        );
      },
    );
  }

  clearForm() {
    setState(() {
      uploadedFiles = [];
    });
    _businessBroadcastBloc.businessBroadcastFormKey.currentState!.reset();
    _businessBroadcastBloc.promotingController.clear();
    _businessBroadcastBloc.amountController.clear();
    _businessBroadcastBloc.nonceController.clear();
    _businessBroadcastBloc.titleController.clear();
    _businessBroadcastBloc.descriptionController.clear();
    _businessBroadcastBloc.postDurationController.clear();
    _businessBroadcastBloc.couponCodeController.clear();
    _businessBroadcastBloc.validFromController.clear();
  }
}

class MyObject {
  final String name;
  final String value;

  MyObject({required this.name, required this.value});
}

class VideoDialog extends StatefulWidget {
  final File videoFile;

  const VideoDialog({super.key, required this.videoFile});

  @override
  _VideoDialogState createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8), // Adjust spacing as needed
          TextButton(
            onPressed: () {
              _controller.pause();
              QR.back();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
