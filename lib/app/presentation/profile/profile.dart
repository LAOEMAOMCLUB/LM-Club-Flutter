// profilePage we can see our profile as a user.

import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lm_club/app/domain/local_storage/shared_pref_repository.dart';
import 'package:lm_club/app/presentation/business_module/business_profile/pages/business_profile.dart';
import 'package:lm_club/app/presentation/dashboard/dashboard.dart';
import 'package:lm_club/app/presentation/profile/profile_bloc.dart';
import 'package:lm_club/app/presentation/profile/profile_state.dart';
import 'package:lm_club/app/presentation/profile/view_profile.dart';
import 'package:lm_club/utils/string_extention.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lm_club/utils/globals.dart' as globals;
import '../../../routes/app_routes.dart';
import '../../core/di/locator.dart';

final SharedPrefRepository _sharedPrefRepository =
    getIt.get<SharedPrefRepository>();

class Profile extends StatefulWidget {
  final String id;
  const Profile({Key? key, required this.id}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

final Map<String, String> planImages = {
  'bronze': "assets/images/bronze.png",
  'silver': 'assets/images/silver.png',
  'gold': 'assets/images/gold.png',
  'platinum': 'assets/images/platinum.png'
  // Add other plan types and their respective image paths
};

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  int page = 2;
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();
  Future<bool> removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  @override
  void initState() {
    super.initState();
    _profileBloc.getUserDetails(widget.id);
  }

  final String path = 'uploads/userprofile/${globals.userId}/';
  final String generateUrlPath = "";
  XFile? image;
  File? imageFile;

  final ImagePicker picker = ImagePicker();

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
      setState(() {
        imageFile = File(img.path);
      });
    }

    _profileBloc.uploadImage(imageFile);
  }

  final ProfileBloc _profileBloc = getIt.get<ProfileBloc>();
  @override
  Widget build(BuildContext context) {
    //double containerHeight = MediaQuery.of(context).size.height - 293;

    return BlocProvider(
      create: (context) => _profileBloc
        ..getUserDetails(widget.id)
        ..getUserPoints()
        ..getReferalCode(),
      child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {},
          builder: (context, state) {
            // String planType = state.userDetails?.planType ?? '';
            // String imagePath = planImages[planType.toLowerCase()] ?? '';
            String beehiveSumData = state.pointsData?.beehiveSum ?? '';
            double? beehiveSum;

            if (beehiveSumData.contains(".")) {
              // If the string contains a decimal point, parse as double
              beehiveSum = double.tryParse(beehiveSumData.trim());
            } else {
              // If the string does not contain a decimal point, parse as integer and convert to double
              beehiveSum = int.tryParse(beehiveSumData.trim())?.toDouble();
            }

            beehiveSum ??= 0.0;

            String broadcastSumData = state.pointsData?.broadcastSum ?? '';
            double? broadcastSum;

            if (broadcastSumData.contains(".")) {
              // If the string contains a decimal point, parse as double
              broadcastSum = double.tryParse(broadcastSumData.trim());
            } else {
              // If the string does not contain a decimal point, parse as integer and convert to double
              broadcastSum = int.tryParse(broadcastSumData.trim())?.toDouble();
            }

            broadcastSum ??= 0.0;

            int referalSum = state.pointsData?.referalSum ?? 0;
            double totalSum = beehiveSum + referalSum + broadcastSum;
            return Stack(children: [
              Scaffold(
                backgroundColor: const Color.fromRGBO(208, 231, 250, 1),
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
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Color.fromRGBO(255, 255, 255, 1),
                      //     blurRadius: 15.0,
                      //     spreadRadius: 10.0,
                      //   ),
                      // ],
                    ),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          // QR.back();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Dashboard(),
                            ),
                          );
                        },
                      ),
                      title: const Text(
                        'My Profile',
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
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  elevation: 1,
                                  shadowColor: Colors.grey,
                                  title: const Text("Alert",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        color: Color.fromRGBO(55, 74, 156, 1),
                                      )),
                                  content: const Text(
                                      "Are you sure you want to Sign out ?",
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
                                            fontFamily:
                                                'NeueHaasGroteskTextPro',
                                            color:
                                                Color.fromRGBO(35, 44, 58, 1),
                                          )),
                                      onPressed: () {
                                        _sharedPrefRepository.removeAll();
                                        globals.removeAll();
                                        _sharedPrefRepository.storeBool(
                                            'first_seen', false);
                                        QR.navigator.replaceAllWithName(
                                          Routes.SIGN_IN.name,
                                        );
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Cancel",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily:
                                                'NeueHaasGroteskTextPro',
                                            color:
                                                Color.fromRGBO(35, 44, 58, 1),
                                          )),
                                      onPressed: () {
                                        // QR.back();\
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.power_settings_new_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
                body: Container(
                  color: state.userDetails!.role!.id == 1
                      ? const Color.fromRGBO(208, 231, 250, 1)
                      : Colors.white,
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 18),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(221, 221, 221, 1),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (state.userDetails!.imagePath!
                                            .isNotEmpty) {
                                          _dialogBuilder(context, state);
                                        }
                                      },
                                      child: state.userDetails!.role!.id == 1
                                          ? Container(
                                              width: 96,
                                              height: 96,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        112, 112, 112, 1),
                                                    width: 2.0,
                                                  ),
                                                  image: state.userDetails!
                                                          .imagePath!.isNotEmpty
                                                      ? DecorationImage(
                                                          image: NetworkImage(
                                                              state.userDetails!
                                                                  .imagePath!),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : const DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/profile_icon.png'),
                                                          fit: BoxFit.cover,
                                                        )),
                                            )
                                          : Container(
                                              width: 96,
                                              height: 96,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        112, 112, 112, 1),
                                                    width: 2.0,
                                                  ),
                                                  image: state
                                                          .userDetails!
                                                          .businessDetails!
                                                          .logoImage!
                                                          .isNotEmpty
                                                      ? DecorationImage(
                                                          image: NetworkImage(state
                                                              .userDetails!
                                                              .businessDetails!
                                                              .logoImage!),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : const DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/profile_icon.png'),
                                                          fit: BoxFit.cover,
                                                        ))),
                                    ),
                                    Positioned(
                                      bottom: 13,
                                      left: 73,
                                      child: GestureDetector(
                                          onTap: () {
                                            showImageSelectionDialog();
                                          },
                                          child: Container(
                                              height: 22,
                                              width: 22,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      141, 229, 230, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Center(
                                                child: Image.asset(
                                                    "assets/images/camera.png",
                                                    width: 14,
                                                    height: 14),
                                              ))),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: SizedBox(
                                        width: 200,
                                        child: Text(
                                          state.userDetails!.username!
                                              .capitalizeOnlyFirstLater(),
                                          style: const TextStyle(
                                            color:
                                                Color.fromRGBO(49, 52, 80, 1),
                                            fontSize: 16,
                                            fontFamily:
                                                'NeueHaasGroteskTextPro',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0), // Add padding here
                                            child: SizedBox(
                                              width: 60,
                                              child: Text(
                                                state.userDetails!.subscription!
                                                    .toUpperCase(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      49, 52, 80, 1),
                                                  fontSize: 10,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        state.userDetails!.role!.id == 1
                                            ? Container(
                                                width: 33,
                                                height: 33,
                                                padding:
                                                    const EdgeInsets.all(1),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              112, 112, 112, 1),
                                                      width: 2.0,
                                                    ),
                                                    image: state
                                                            .userDetails!
                                                            .planImage!
                                                            .isNotEmpty
                                                        ? DecorationImage(
                                                            image: NetworkImage(
                                                                state
                                                                    .userDetails!
                                                                    .planImage!),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : const DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/bronze.png'),
                                                            fit: BoxFit.cover,
                                                          )),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        state.userDetails!.role!.id == 1
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ViewProfile(id: ''),
                                                ),
                                              )
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ViewBusinessProfile(
                                                          id: ''),
                                                ),
                                              );

                                        // ? QR.to(Routes.VIEWPROFILE)
                                        // : QR.to(Routes.VIEWBUSINESSPROFILE);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.transparent),
                                        elevation:
                                            WidgetStateProperty.all<double>(0),
                                        overlayColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.transparent),
                                        shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                      ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              55, 74, 156, 1),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Container(
                                          //width: 154,
                                          height: 26,
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 5, 15, 5),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            "View Profile",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'NeueHaasGroteskTextPro'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          state.userDetails!.role!.id == 1
                              ? Container(
                                  width: MediaQuery.of(context).size.width - 80,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Stack(
                                          alignment: state.refeeralCode!
                                                      .referalCount! >=
                                                  10
                                              ? const Alignment(0, -0.5)
                                              : Alignment.topCenter,
                                          children: [
                                            Opacity(
                                              opacity: state.refeeralCode!
                                                          .referalCount! >=
                                                      10
                                                  ? 1.0
                                                  : 0.5, // Adjust opacity based on referral count
                                              child: Image.asset(
                                                "assets/images/badge.png",
                                                width: 48,
                                                height: 48,
                                                alignment: Alignment.center,
                                              ),
                                            ),
                                            Text(
                                              getLevel(state
                                                  .refeeralCode!.referalCount!),
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    35, 44, 58, 1),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    'NeueHaasGroteskTextPro',
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          width: 0.5,
                                          height: 80,
                                          color: const Color.fromRGBO(
                                              184, 188, 204, 1),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/medal.png",
                                                  width: 48,
                                                  height: 48,
                                                  alignment: Alignment.center,
                                                ),
                                                const SizedBox(
                                                    width:
                                                        4), // Adjust spacing between image and text as needed
                                                Text(
                                                  totalSum.toString(),
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        35, 44, 58, 1),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        'NeueHaasGroteskTextPro',
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ]),
                                )
                              : const SizedBox()
                        ]),
                  ),
                ),
                bottomSheet: Container(
                    height: MediaQuery.of(context).size.height - 445,
                    color: Colors.white),
              ),
              if (state.isLoading)
                Container(
                  color: Colors.transparent
                      // ignore: deprecated_member_use
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
          }),
    );
  }

  String getLevel(int referralCount) {
    List<RangeData> ranges = [
      RangeData(start: 1, end: 10, label: '1-10', level: '1'),
      RangeData(start: 11, end: 20, label: '11-20', level: '2'),
      RangeData(start: 21, end: 30, label: '21-30', level: '3'),
      RangeData(start: 31, end: 40, label: '31-40', level: '4'),
      // Add more ranges as needed
    ];

    for (var range in ranges.reversed) {
      if (referralCount >= range.end) {
        return range.level;
      }
    }

    // Default level
    return '';
  }

  Future<void> _dialogBuilder(BuildContext context, ProfileState state) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: SizedBox(
            width: 290,
            height: 200,
            child: Stack(
              children: [
                // state.userDetails!.imagePath!.isNotEmpty
                // ?
                Image.network(
                  state.userDetails!.imagePath!,
                  fit: BoxFit.cover,
                  width: 290,
                  height: 200,
                ),
                // : Image.asset(
                //     'assets/images/profile_icon.png',
                //     fit: BoxFit.cover,
                //     width: 290,
                //     height: 200,
                //   ),
                Positioned(
                  top: -15,
                  right: -15,
                  child: IconButton(
                    onPressed: () {
                      // QR.back();
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      CupertinoIcons.clear_circled,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                    // QR.back();
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
                    // QR.back();
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

class RangeData {
  final int start;
  final int end;
  final String label;
  final String level;

  RangeData(
      {required this.start,
      required this.end,
      required this.label,
      required this.level});
}
