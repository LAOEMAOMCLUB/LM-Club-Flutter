// AddBehivePage to post Beehive

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/models/auth/response_model/categories_response.dart';
import 'package:lm_club/app/presentation/beehive/bloc/beehive_bloc.dart';
import 'package:lm_club/app/presentation/beehive/bloc/beehive_state.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:searchfield/searchfield.dart';
import 'package:video_player/video_player.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

enum MediaType { images, videos }

class AddBeehive extends StatefulWidget {
  const AddBeehive({super.key});

  @override
  State<AddBeehive> createState() => _AddBeehiveState();
}

class _AddBeehiveState extends State<AddBeehive> {
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  // XFile? image;
  // File? imageFile;
  // List<ImageModel> imgModels = [];
  // List<XFile>? images = [];
  // List<String> imageFiles = [];
  // List<File> imageFiles1 = [];
  String fileName = '';
  String fileSize = '';
  String mimeType = '';
  DateTime selectedDate = DateTime.now().toLocal();
  final FocusNode _focusNode = FocusNode();
  // final ImagePicker picker = ImagePicker();
  final BeehiveBloc _beehiveBloc = getIt.get<BeehiveBloc>();

  // Future<void> getImage(ImageSource media) async {
  //   setState(() {
  //     imageFiles = [];
  //   });

  //   if (media == ImageSource.camera) {
  //     PermissionStatus status = await Permission.camera.request();
  //     if (status.isGranted) {
  //       XFile? pickedImage = await picker.pickImage(
  //         source: media,
  //         // maxWidth: 800,
  //         // maxHeight: 800,
  //         // imageQuality: 80,
  //       );
  //       if (pickedImage != null) {
  //         int maxSize = 10 * 1024 * 1024;
  //         File imageFile = File(pickedImage.path);
  //         int imageSize = await imageFile.length();

  //         if (imageSize > maxSize) {
  //           // ignore: use_build_context_synchronously
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(
  //               content: Text('Please select an image smaller than 10MB.'),
  //               duration: Duration(seconds: 3),
  //               backgroundColor: Colors.red,
  //             ),
  //           );
  //           return;
  //         }

  //         List<String> allFilePaths = imageFiles;
  //         allFilePaths.add(pickedImage.path);

  //         setState(() {
  //           imageFiles = allFilePaths;
  //         });

  //         List<File> uploadedFiles =
  //             allFilePaths.map((path) => File(path)).toList();

  //         _beehiveBloc.uploadImage(uploadedFiles);
  //       }
  //     }
  //   } else {
  //     XFile? pickedImage = await picker.pickImage(
  //       source: media,
  //       // maxWidth: 800,
  //       // maxHeight: 800,
  //       // imageQuality: 80,
  //     );

  //     if (pickedImage != null) {
  //       List<String> allowedExtensions = ['jpg', 'jpeg', 'png'];
  //       if (allowedExtensions
  //           .contains(pickedImage.path.split('.').last.toLowerCase())) {
  //         File imageFile = File(pickedImage.path);
  //         int maxSize = 10 * 1024 * 1024;
  //         int imageSize = await imageFile.length();

  //         if (imageSize > maxSize) {
  //           // ignore: use_build_context_synchronously
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(
  //               content: Text('Please select an image smaller than 10MB.'),
  //               duration: Duration(seconds: 3),
  //               backgroundColor: Colors.red,
  //             ),
  //           );
  //           return;
  //         }

  //         List<File> fileObjects = [File(pickedImage.path)];
  //         Uint8List bytes = await pickedImage.readAsBytes();
  //         ByteData byteData = ByteData.view(bytes.buffer);
  //         if (kDebugMode) {
  //           print('byteData.lengthInBytes---${byteData.lengthInBytes}');
  //           final kb = byteData.lengthInBytes / 1024;
  //           final mb = kb / 1024;
  //           print('byteData.mb---$mb');
  //         }

  //         setState(() {
  //           imageFiles = [pickedImage.path];
  //         });

  //         _beehiveBloc.uploadImage(fileObjects);
  //       } else {
  //         // ignore: use_build_context_synchronously
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('Please select JPG, JPEG, or PNG files only.'),
  //             duration: Duration(seconds: 3),
  //             backgroundColor: Colors.red,
  //           ),
  //         );
  //       }
  //     }
  //   }
  // }

  XFile? image;
  File? _video;
  File? imageFile;
  List<String> imageFiles = [];
  MediaType? currentMediaType; // Track current media type, initially null
  List<File> uploadedFiles = [];
  bool isDropdownOpen = false;

  bool isValidAddress(String address) {
    return address.trim().length >= 5;
  }

  final ImagePicker picker = ImagePicker();
  Future<void> getImage(ImageSource media, {MediaType? mediaType}) async {
    setState(() {
      imageFiles = [];
    });

    if (media == ImageSource.camera) {
      PermissionStatus cameraStatus = await Permission.camera.request();
      bool allStatus = false;
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
        PermissionStatus microphoneStatus =
            await Permission.microphone.request();
        allStatus = cameraStatus.isGranted && microphoneStatus.isGranted;
      } else {
        allStatus = cameraStatus.isGranted;
      }
      if (allStatus) {
        if (mediaType == MediaType.videos) {
          XFile? pickedFile = await picker.pickVideo(
              source: media, maxDuration: const Duration(seconds: 30));
          if (pickedFile != null) {
            File videoFile = File(pickedFile.path);
            // int fileSizeInBytes = await videoFile.length();

            // if (fileSizeInBytes < 20 * 1024 * 1024) {
            List<String> allFilePaths = imageFiles;
            allFilePaths.add(pickedFile.path);
            _video = videoFile;

            setState(() {
              imageFiles = allFilePaths;
              currentMediaType =
                  MediaType.videos; // Set current media type to images
            });

            List<File> uploadedFiles =
                allFilePaths.map((path) => File(path)).toList();

            _beehiveBloc.uploadImage(uploadedFiles);
            // }
            // else {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(
            //       content: Text('Please select a video file smaller than 20MB'),
            //       duration: Duration(seconds: 3),
            //       backgroundColor: Colors.red,
            //     ),
            //   );
            // }
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

              List<File> uploadedFiles =
                  allFilePaths.map((path) => File(path)).toList();

              _beehiveBloc.uploadImage(uploadedFiles);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select image files smaller than 20MB"),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      } else {
        String type =
            mediaType == MediaType.videos ? 'camera or microphone' : 'camera';
        // Handle when camera permission is not granted.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Access to the $type has been prohibited; please enable it in the Settings app to continue."),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
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
            maxDuration: const Duration(minutes: 2));
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

            List<File> uploadedFiles =
                allFilePaths.map((path) => File(path)).toList();

            _beehiveBloc.uploadImage(uploadedFiles);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select a video file smaller than 20MB'),
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

          setState(() {
            imageFiles = validImageFiles;
            currentMediaType =
                MediaType.images; // Set current media type to images
          });

          _beehiveBloc.uploadImage(fileObjects);
        }
      }
    }
  }

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

        String formattedDate = DateFormat().add_yMMMEd().format(picked);

        _beehiveBloc.validUptoController.text = formattedDate;
      });
    }
  }

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? DateTime.now().toLocal(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;

        String formattedDate = DateFormat.yMMMEd().format(picked);
        _beehiveBloc.validFromController.text = formattedDate;
        if (selectedEndDate != null && selectedEndDate!.isBefore(picked)) {
          selectedEndDate = null;
          _beehiveBloc.validUptoController.text = '';
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    if (selectedStartDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start date first')),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate ?? selectedStartDate!.toLocal(),
      firstDate: selectedStartDate!.toLocal(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;

        String formattedEndDate = DateFormat.yMMMEd().format(picked);
        _beehiveBloc.validUptoController.text = formattedEndDate;
      });
    }
  }

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
        _beehiveBloc.operationHoursFromController.text = selectedTimeFrom;
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
        _beehiveBloc.operationHoursToController.text = selectedTimeTo;
      });
    }
  }

  // Future<void> _selectTimeFrom(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );

  //   if (pickedTime != null) {
  //     setState(() {
  //       selectedTimeFrom = pickedTime.format(context);
  //       _beehiveBloc.operationHoursFromController.text = selectedTimeFrom;
  //     });
  //   }
  // }

  // Future<void> _selectTimeTo(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );

  //   if (pickedTime != null) {
  //     final fromTimeParts = selectedTimeFrom.split(' ')[0].split(':');
  //     final fromTimePeriod = selectedTimeFrom.split(' ')[1];
  //     final fromHour =
  //         int.parse(fromTimeParts[0]) + (fromTimePeriod == 'PM' ? 12 : 0);
  //     final fromMinute = int.parse(fromTimeParts[1]);

  //     final fromDateTime = DateTime(
  //       DateTime.now().year,
  //       DateTime.now().month,
  //       DateTime.now().day,
  //       fromHour,
  //       fromMinute,
  //     );

  //     // Create DateTime for pickedTime
  //     final pickedDateTime = DateTime(
  //       DateTime.now().year,
  //       DateTime.now().month,
  //       DateTime.now().day,
  //       pickedTime.hour,
  //       pickedTime.minute,
  //     );

  //     // Check if the picked time is within 24 hours from the selected time
  //     if (pickedDateTime.isBefore(fromDateTime) ||
  //         pickedDateTime.isAfter(fromDateTime.add(const Duration(hours: 24)))) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           backgroundColor: Colors.red,
  //           content: Center(
  //             child: Text(
  //               'Please select a time within 24 hours from the "From" time',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 16,
  //               ),
  //             ),
  //           ),
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //     } else {
  //       setState(() {
  //         selectedTimeTo = pickedTime.format(context);
  //         _beehiveBloc.operationHoursToController.text = selectedTimeTo;
  //       });
  //     }
  //   }
  // }

  clearForm() {
    setState(() {
      imageFiles = [];
    });
    _beehiveBloc.titleController.clear();
    _beehiveBloc.descriptionController.clear();
    _beehiveBloc.validUptoController.clear();
    _beehiveBloc.validFromController.clear();
    _beehiveBloc.isDraftController.clear();
    _beehiveBloc.couponCodeController.clear();
    _beehiveBloc.companyController.clear();
    _beehiveBloc.operationHoursFromController.clear();
    _beehiveBloc.operationHoursToController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _beehiveBloc..getBeehiveCategories(),
        child:
            BlocConsumer<BeehiveBloc, BeehiveState>(listener: (context, state) {
          if (state.isSuccesful) {
            // _beehiveBloc.disposeControllers();
            // QR.navigator.replaceLastName(
            //   Routes.BEEHIVE_SUCCESS_POST.name,
            // );
            QR.to(Routes.BEEHIVE_SUCCESS_POST);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const BeehiveSuccessPost(),
            //   ),
            // );
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
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const Beehive(),
                        //   ),
                        // );
                      },
                    ),
                    title: const Text(
                      'Add Beehive',
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
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 23, left: 23, top: 6.0),
                  child: Form(
                      key: _beehiveBloc.webFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SearchField(
                              suggestionState: Suggestion.expand,
                              focusNode: _focusNode,
                              suggestionAction: SuggestionAction.unfocus,
                              suggestions: state.beehiveCategories!
                                  .where((i) => i.isActive ?? false)
                                  .toList()
                                  .map((beehiveCategories) =>
                                      SearchFieldListItem(
                                          beehiveCategories.category,
                                          item: beehiveCategories,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 19, right: 19),
                                                child: Center(
                                                  child: Text(
                                                    beehiveCategories.category,
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
                                  return 'Select Category is Required';
                                }
                                bool stateExists = state.beehiveCategories!.any(
                                    (state) =>
                                        state.category.toLowerCase() ==
                                        value.toLowerCase());
                                if (!stateExists) {
                                  return 'Category not found. Please select a valid category.';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.search,
                              controller: _beehiveBloc.categoryController,
                              maxSuggestionsInViewPort: 4,
                              itemHeight: 40,
                              searchStyle: const TextStyle(
                                fontSize: 13,
                                color: Color.fromRGBO(35, 44, 58, 1),
                                fontFamily: 'NeueHaasGroteskTextPro',
                                fontWeight: FontWeight.w500,
                              ),
                              searchInputDecoration: InputDecoration(
                                // : 'State',
                                labelText: 'Select Category',
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
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                                // borderRadius: BorderRadius.circular(8.0),
                              ),
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              onSuggestionTap: (x) {
                                BeehiveCategory catSelected = state
                                    .beehiveCategories!
                                    .firstWhere((element) => element == x.item);
                                _beehiveBloc.updateBeehiveCategory(catSelected);
                                clearForm();
                              },
                              onSubmit: (p0) {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _beehiveBloc.titleController,
                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
                              textCapitalization: TextCapitalization.none,
                              autocorrect: false,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^\s+')),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]')),
                              ],
                              validator: state.categoryId == '3'
                                  ? MultiValidator([
                                      RequiredValidator(
                                          errorText: 'Event Name is Required'),
                                      MinLengthValidator(3,
                                          errorText:
                                              'Event Name must be at least 3 characters')
                                    ])
                                  : MultiValidator([
                                      RequiredValidator(
                                          errorText: 'Post Name is Required'),
                                      MinLengthValidator(3,
                                          errorText:
                                              'post Name must be at least 3 characters')
                                    ]),
                              decoration: InputDecoration(
                                labelText: state.categoryId == '3'
                                    ? 'Event Name'
                                    : 'Post Name',
                                counterText: "",
                                errorStyle: const TextStyle(fontSize: 13.0),
                                labelStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(116, 116, 116, 1),
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w500),
                                hintStyle: const TextStyle(
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    fontSize: 13,
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w400),
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
                              ),
                              maxLength: 50,
                              style: const TextStyle(
                                  color: Color.fromRGBO(35, 44, 58, 1),
                                  fontSize: 13,
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          state.categoryId == '3'
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: _beehiveBloc.companyController,
                                    // autovalidateMode:
                                    //     AutovalidateMode.onUserInteraction,
                                    textCapitalization: TextCapitalization.none,
                                    autocorrect: false,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'^\s+')),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z\s]')),
                                    ],
                                    decoration: const InputDecoration(
                                      labelText: 'Company Name (Optional)',
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
                                    maxLength: 50,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(35, 44, 58, 1),
                                      fontSize: 13,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    validator: (value) {
                                      if (_beehiveBloc
                                          .companyController.text.isNotEmpty) {
                                        return MultiValidator([
                                          MinLengthValidator(3,
                                              errorText:
                                                  'Company Name must be at least 3 characters')
                                        ])(value);
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              : const SizedBox(),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _beehiveBloc.descriptionController,
                                // autovalidateMode:
                                //     AutovalidateMode.onUserInteraction,
                                textCapitalization: TextCapitalization.none,
                                autocorrect: false,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'^\s+')),
                                  // FilteringTextInputFormatter.allow(
                                  //   RegExp(r'.*'),
                                  // ),
                                ],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Description is Required';
                                  } else if (value.length >= 500) {
                                    return 'Description cannot be more than 500 characters';
                                  }
                                  return null;
                                },
                                // validator: MultiValidator([
                                //   RequiredValidator(
                                //       errorText: 'Description is Required'),
                                //   // MinLengthValidator(5,
                                //   //     errorText:
                                //   //         'Description be at least 5 characters')
                                // ]),
                                decoration: const InputDecoration(
                                  labelText: 'Description',
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
                                maxLength: 500,
                                style: const TextStyle(
                                  color: Color.fromRGBO(35, 44, 58, 1),
                                  fontSize: 13,
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                          state.categoryId == '1'
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller:
                                        _beehiveBloc.couponCodeController,
                                    // autovalidateMode:
                                    //     AutovalidateMode.onUserInteraction,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'\s')),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z0-9]')),
                                    ],
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'Coupon Code is Required'),
                                      MinLengthValidator(6,
                                          errorText:
                                              'Coupon Code must be at least 6 characters'),
                                      MaxLengthValidator(20,
                                          errorText:
                                              'Coupon Code must not exceed 20 characters'),
                                    ]),
                                    onChanged: (value) {
                                      _beehiveBloc.couponCodeController.text =
                                          value.toUpperCase();
                                      _beehiveBloc
                                              .couponCodeController.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: value.length));
                                    },
                                    maxLength: 20,
                                    decoration: const InputDecoration(
                                      labelText: 'Coupon Code',
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
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ))
                              : const SizedBox(),
                          state.categoryId == '1'
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        keyboardType: TextInputType.datetime,
                                        controller:
                                            _beehiveBloc.validUptoController,
                                        // autovalidateMode:
                                        //     AutovalidateMode.onUserInteraction,
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText:
                                                  'Valid upto is Required'),
                                        ]),
                                        decoration: InputDecoration(
                                          labelText: 'Valid upto',
                                          // : '31 Oct 2023',
                                          errorStyle:
                                              const TextStyle(fontSize: 13.0),
                                          labelStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Color.fromRGBO(
                                                116, 116, 116, 1),
                                            fontFamily:
                                                'NeueHaasGroteskTextPro',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          hintStyle: const TextStyle(
                                            color:
                                                Color.fromRGBO(35, 44, 58, 1),
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

                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Image.asset(
                                              "assets/images/calender.png",
                                              width: 23.0,
                                              height: 23.0,
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
                                )
                              : const SizedBox(),
                          state.categoryId == '3'
                              ? Padding(
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
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _selectStartDate(context);
                                                    },
                                                    child: AbsorbPointer(
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .datetime,
                                                        controller: _beehiveBloc
                                                            .validFromController,
                                                        // autovalidateMode:
                                                        //     AutovalidateMode.onUserInteraction,
                                                        validator:
                                                            MultiValidator([
                                                          RequiredValidator(
                                                              errorText:
                                                                  'Event Start Date is Required'),
                                                        ]),
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Event  start date',
                                                          // : '31 Oct 2023',
                                                          errorStyle:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      13.0),
                                                          labelStyle:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Color.fromRGBO(
                                                                    116,
                                                                    116,
                                                                    116,
                                                                    1),
                                                            fontFamily:
                                                                'NeueHaasGroteskTextPro',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          hintStyle:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    35,
                                                                    44,
                                                                    58,
                                                                    1),
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'NeueHaasGroteskTextPro',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          enabledBorder:
                                                              const UnderlineInputBorder(
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
                                                              const UnderlineInputBorder(
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

                                                          suffixIcon: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 8.0),
                                                            child: Image.asset(
                                                              "assets/images/calender.png",
                                                              width: 23.0,
                                                              height: 23.0,
                                                              // color: const Color.fromRGBO(
                                                              //     55, 74, 156, 1),
                                                            ),
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
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _selectEndDate(context);
                                                    },
                                                    child: AbsorbPointer(
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .datetime,
                                                        controller: _beehiveBloc
                                                            .validUptoController,
                                                        // autovalidateMode:
                                                        //     AutovalidateMode.onUserInteraction,
                                                        validator:
                                                            MultiValidator([
                                                          RequiredValidator(
                                                              errorText:
                                                                  'Event end Date is Required'),
                                                        ]),
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Event end date',
                                                          // : '31 Oct 2023',
                                                          errorStyle:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      13.0),
                                                          labelStyle:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Color.fromRGBO(
                                                                    116,
                                                                    116,
                                                                    116,
                                                                    1),
                                                            fontFamily:
                                                                'NeueHaasGroteskTextPro',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          hintStyle:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    35,
                                                                    44,
                                                                    58,
                                                                    1),
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'NeueHaasGroteskTextPro',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          enabledBorder:
                                                              const UnderlineInputBorder(
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
                                                              const UnderlineInputBorder(
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

                                                          suffixIcon: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 8.0),
                                                            child: Image.asset(
                                                              "assets/images/calender.png",
                                                              width: 23.0,
                                                              height: 23.0,
                                                              // color: const Color.fromRGBO(
                                                              //     55, 74, 156, 1),
                                                            ),
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
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                )
                              : const SizedBox(),
                          state.categoryId == '3'
                              ? Padding(
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
                                                    // const Text(
                                                    //   'From ',
                                                    //   style: TextStyle(
                                                    //     color: Color.fromRGBO(
                                                    //         35, 44, 58, 1),
                                                    //     fontSize: 13,
                                                    //     fontFamily:
                                                    //         'NeueHaasGroteskTextPro',
                                                    //     fontWeight:
                                                    //         FontWeight.w400,
                                                    //   ),
                                                    // ),
                                                    Expanded(
                                                        child: GestureDetector(
                                                      onTap: () async {
                                                        _selectTimeFrom(
                                                            context);
                                                      },
                                                      child: AbsorbPointer(
                                                          child: TextFormField(
                                                        keyboardType:
                                                            TextInputType.text,
                                                        controller: _beehiveBloc
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
                                                          labelText:
                                                              'Event start time',
                                                          counterText: "",
                                                          errorStyle: TextStyle(
                                                              fontSize: 13.0),
                                                          labelStyle: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Color.fromRGBO(
                                                                    116,
                                                                    116,
                                                                    116,
                                                                    1),
                                                            fontFamily:
                                                                'NeueHaasGroteskTextPro',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          hintStyle: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    35,
                                                                    44,
                                                                    58,
                                                                    1),
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
                                                    // Container(
                                                    //   width: 1,
                                                    //   height: 17,
                                                    //   color: const Color
                                                    //       .fromRGBO(
                                                    //       184, 188, 204, 1),
                                                    //   margin: const EdgeInsets
                                                    //       .symmetric(
                                                    //       horizontal: 5),
                                                    // ),
                                                    // const Text(
                                                    //   ' AM',
                                                    //   style: TextStyle(
                                                    //     color: Color.fromRGBO(
                                                    //         35, 44, 58, 1),
                                                    //     fontSize: 13,
                                                    //     fontFamily:
                                                    //         'NeueHaasGroteskTextPro',
                                                    //     fontWeight:
                                                    //         FontWeight.w400,
                                                    //   ),
                                                    // ),
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
                                                    Expanded(
                                                        child: GestureDetector(
                                                            onTap: () async {
                                                              _selectTimeTo(
                                                                  context);
                                                            },
                                                            child:
                                                                AbsorbPointer(
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                controller:
                                                                    _beehiveBloc
                                                                        .operationHoursToController,
                                                                inputFormatters: <TextInputFormatter>[
                                                                  FilteringTextInputFormatter
                                                                      .deny(
                                                                    RegExp(
                                                                        r'^\s+'),
                                                                  ),
                                                                ],
                                                                validator:
                                                                    (value) {
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
                                                                          .all(
                                                                              5),
                                                                  counterStyle:
                                                                      TextStyle(
                                                                    height: double
                                                                        .minPositive,
                                                                  ),
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color.fromRGBO(
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
                                                                      color: Color.fromRGBO(
                                                                          184,
                                                                          188,
                                                                          204,
                                                                          1),
                                                                    ),
                                                                  ),
                                                                  hintText:
                                                                      "00:00",
                                                                  labelText:
                                                                      'Event end time',
                                                                  counterText:
                                                                      "",
                                                                  errorStyle:
                                                                      TextStyle(
                                                                          fontSize:
                                                                              13.0),
                                                                  labelStyle:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
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
                                                                    fontSize:
                                                                        13,
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
                                                    // Container(
                                                    //   width: 1,
                                                    //   height: 17,
                                                    //   color: const Color
                                                    //       .fromRGBO(
                                                    //       184, 188, 204, 1),
                                                    //   margin: const EdgeInsets
                                                    //       .symmetric(
                                                    //       horizontal: 5),
                                                    // ),
                                                    // const Text(
                                                    //   ' PM',
                                                    //   style: TextStyle(
                                                    //     color: Color.fromRGBO(
                                                    //         35, 44, 58, 1),
                                                    //     fontSize: 13,
                                                    //     fontFamily:
                                                    //         'NeueHaasGroteskTextPro',
                                                    //     fontWeight:
                                                    //         FontWeight.w400,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                )
                              : const SizedBox(),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Image',
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
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: 45.0,
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(10),
                                    dashPattern: const [6, 4],
                                    color: const Color.fromRGBO(55, 74, 156, 1),
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
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: 80.0,
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(10),
                                    dashPattern: const [6, 4],
                                    color: const Color.fromRGBO(55, 74, 156, 1),
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
                                            "Upload Picture / Video",
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
                          const SizedBox(height: 8.0),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 22),
                              child: imageFiles.isNotEmpty
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: buildImageList(imageFiles),
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                          )
                        ],
                      )),
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                color: const Color.fromRGBO(255, 255, 255, 1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (state.categoryId == '1') {
                            if (imageFiles.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Center(
                                    child: Text(
                                      ('Please upload an image.'),
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
                              _beehiveBloc.uploadBeehive();
                            }
                          } else {
                            _beehiveBloc.uploadBeehive();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(55, 74, 156, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          elevation: 4,
                        ),
                        child: const SizedBox(
                          width: 290,
                          height: 42,
                          child: Center(
                            child: Text(
                              'Create',
                              style: TextStyle(
                                  fontFamily: "NeueHaasGroteskTextPro",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
          ]);
        }));
  }

  // List<Widget> buildImageList(List<String> imageFiles) {
  //   return List.generate(imageFiles.length, (index) {
  //     return Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //       child: Stack(
  //         children: [
  //           Container(
  //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
  //             width: 90,
  //             height: 90,
  //             child: Image.file(
  //               File(imageFiles[index]),
  //               fit: BoxFit.fill,
  //             ),
  //           ),
  //           Positioned(
  //             top: -3,
  //             right: -4,
  //             child: GestureDetector(
  //               onTap: () {
  //                 setState(() {
  //                   imageFiles.removeAt(index);
  //                 });
  //               },
  //               child: Container(
  //                 padding: const EdgeInsets.all(4.0),
  //                 decoration: const BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   color: Colors.black54,
  //                 ),
  //                 child: const Icon(
  //                   Icons.close,
  //                   color: Color.fromARGB(255, 230, 25, 25),
  //                   size: 20.0,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   });
  // }

  List<Widget> buildImageList(List<String> imageFiles) {
    return List.generate(imageFiles.length, (index) {
      bool isImage = imageFiles[index].toLowerCase().endsWith('.jpg') ||
          imageFiles[index].toLowerCase().endsWith('.jpeg') ||
          imageFiles[index].toLowerCase().endsWith('.png');
      bool isVideo = imageFiles[index].toLowerCase().endsWith('.mp4') ||
          imageFiles[index].toLowerCase().endsWith('.avi') ||
          imageFiles[index].toLowerCase().endsWith('.mov');
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
                      File(imageFiles[index]),
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
