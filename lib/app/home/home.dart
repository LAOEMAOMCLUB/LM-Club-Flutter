// HpmePage after login user land on this page 

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/domain/local_storage/shared_pref_repository.dart';
import 'package:lm_club/app/home/bloc/home_bloc.dart';
import 'package:lm_club/app/home/bloc/home_state.dart';
import 'package:lm_club/app/models/auth/response_model/user_details.dart';
import 'package:lm_club/app/presentation/webpages/htmlview.dart';
import 'package:lm_club/app/presentation/webpages/webview.dart';
import 'package:lm_club/utils/string_extention.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';
//import 'package:lm_club/app/beehive/beehive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lm_club/utils/globals.dart' as globals;
import '../../routes/app_routes.dart';
import 'package:html/parser.dart' as html_parser;

final SharedPrefRepository _sharedPrefRepository =
    getIt.get<SharedPrefRepository>();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeBloc _homeBloc = getIt.get<HomeBloc>();
  int page = 1;
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late EasyRefreshController _controller;
  @override
  void initState() {
    super.initState();
    fetchUser();
    _homeBloc
      ..getUserDetails(globals.userId)
      ..getAllNotifications();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String userName = '';
  bool termsAccepted = false;
  bool continueClicked = true;
  bool isFirstSeen = true;
  List<String> referUnlock = [];

  Future<void> fetchUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isFirstSeen = prefs.getBool('first_seen') ?? true;
      await prefs.setBool('first_seen', false);
      // final prefs = await SharedPreferences.getInstance();
      referUnlock = prefs.getStringList('refer_unlock') ?? [];
      // await prefs.getStringList('refer_unlock', true);
    } catch (e) {
      if (kDebugMode) {
        print('e--$e');
      }
    }
  }

  Future<bool> removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  void signOut() {
    _sharedPrefRepository.removeAll();
    globals.removeAll();
    _sharedPrefRepository.storeBool('first_seen', false);
    QR.navigator.replaceAllWithName(
      Routes.SIGN_IN.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _homeBloc
          // ..fetchwidgets()
          ..getUserDetails(globals.userId)
          ..getAllNotifications()
          ..getReferalCode(),
        child: BlocConsumer<HomeBloc, HomeState>(listener: (context, state) {
          if (state.isSuccesful!) {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const PostSuccess()));

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error!)));
          } else if (state.error!.isNotEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error!)));
          } else if (state.accountDeleted ?? false) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('We\'ve succesfully deleted your account.')));
            signOut();
          }
        }, builder: (context, state) {
          //double screenWidth = MediaQuery.of(context).size.width;

          return Stack(children: [
            Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(76.0),
                  child: Container(
                    // height: 76.0,
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
                      elevation: 0,
                      leading: GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(
                            'assets/images/home-menu.png',
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ),
                      actions: [
                        state.userDetails!.planStatus == true
                            ? Stack(children: [
                                GestureDetector(
                                    onTap: () {
                                      QR.to(Routes.NOTIFICATION);
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             const Notifications()));
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                253, 128, 48, 1),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  253, 128, 48, 1),
                                              width: 2.0,
                                            ),
                                          ),
                                          width: 40,
                                          height: 40,
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 10, 10, 0),
                                          child: state.unReadCount != null &&
                                                  state.unReadCount!
                                                          .getTotalUnreadCount !=
                                                      null &&
                                                  state.unReadCount!
                                                          .getTotalUnreadCount! >
                                                      0
                                              ? Image.asset(
                                                  'assets/images/Ani-notification.gif',
                                                  // width: 30,
                                                  // height: 30,
                                                  fit: BoxFit.fill,
                                                )
                                              : Image.asset(
                                                  'assets/images/bell.png',
                                                  // width: 30,
                                                  // height: 30,
                                                  fit: BoxFit.fill,
                                                ),
                                        ),
                                        state.unReadCount != null &&
                                                state.unReadCount!
                                                        .getTotalUnreadCount !=
                                                    null &&
                                                state.unReadCount!
                                                        .getTotalUnreadCount! >
                                                    0
                                            ? Positioned(
                                                right: 5,
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 1.0,
                                                    ),
                                                  ),

                                                  // decoration:
                                                  //     const BoxDecoration(
                                                  //   shape: BoxShape.circle,
                                                  //   color: Colors.red,
                                                  // ),
                                                  child: Center(
                                                    child: Text(
                                                      state.unReadCount!
                                                          .getTotalUnreadCount
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    )),
                              ])
                            : const SizedBox()
                      ],
                    ),
                  ),
                ),
                drawer: Drawer(
                  backgroundColor: Colors.white,
                  child: SizedBox(
                    width: 258,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              DrawerHeader(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color.fromRGBO(147, 196, 113, 1),
                                        width: 2.0,
                                      ),
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(12, 57, 131, 1),
                                        Color.fromRGBO(0, 176, 80, 1),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                // child: Container(
                                                //   width: 60,
                                                //   height: 60,
                                                //   decoration: BoxDecoration(
                                                //     shape: BoxShape.circle,
                                                //     border: Border.all(
                                                //       color: const Color.fromRGBO(
                                                //           112, 112, 112, 1),
                                                //       width: 2.0,
                                                //     ),
                                                //     image: state.userDetails!.imagePath!
                                                //             .isNotEmpty
                                                //         ? DecorationImage(
                                                //             image: NetworkImage(state
                                                //                 .userDetails!
                                                //                 .imagePath!),
                                                //             fit: BoxFit.cover,
                                                //           )
                                                //         : const DecorationImage(
                                                //             image: AssetImage(
                                                //                 'assets/images/profile_icon.png'),
                                                //             fit: BoxFit.cover,
                                                //           ),
                                                //   ),
                                                // ),

                                                child: state.userDetails!.role!
                                                            .id ==
                                                        1
                                                    ? Container(
                                                        width: 60,
                                                        height: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                  color: const Color
                                                                      .fromRGBO(
                                                                      112,
                                                                      112,
                                                                      112,
                                                                      1),
                                                                  width: 2.0,
                                                                ),
                                                                image: state
                                                                        .userDetails!
                                                                        .imagePath!
                                                                        .isNotEmpty
                                                                    ? DecorationImage(
                                                                        image: NetworkImage(state
                                                                            .userDetails!
                                                                            .imagePath!),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )
                                                                    : const DecorationImage(
                                                                        image: AssetImage(
                                                                            'assets/images/profile_icon.png'),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )),
                                                      )
                                                    : Container(
                                                        width: 60,
                                                        height: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                  color: const Color
                                                                      .fromRGBO(
                                                                      112,
                                                                      112,
                                                                      112,
                                                                      1),
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
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )
                                                                    : const DecorationImage(
                                                                        image: AssetImage(
                                                                            'assets/images/profile_icon.png'),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ))),
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    state.userDetails!.username!
                                                        .capitalizeOnlyFirstLater(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontFamily:
                                                          'NeueHaasGroteskTextPro',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    state.userDetails!.email!,
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 0.56),
                                                      fontSize: 10,
                                                      fontFamily:
                                                          'NeueHaasGroteskTextPro',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    state.userDetails!
                                                        .subscription!,
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 0.56),
                                                      fontFamily:
                                                          'NeueHaasGroteskTextPro',
                                                      fontSize: 10,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ))
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        // left: 0,
                                        right: 0,
                                        child: Center(
                                            child: GestureDetector(
                                          onTap: () {
                                            if (_scaffoldKey
                                                .currentState!.isDrawerOpen) {
                                              _scaffoldKey.currentState!
                                                  .openEndDrawer();
                                            }
                                            // QR.back();
                                          },
                                          child: const Icon(
                                            Icons.cancel_outlined,
                                            color: Colors.white,
                                          ),
                                        )),
                                      ),
                                    ],
                                  )),
                              ListTile(
                                leading: const Icon(CupertinoIcons.doc_text,
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    size: 22),
                                title: const Text('About us',
                                    style: TextStyle(
                                        color: Color.fromRGBO(35, 44, 58, 1),
                                        fontSize: 14,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w500)),
                                onTap: () {
                                  AboutUs? aboutUs = state.userDetails?.aboutus;
                                  if (aboutUs != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => HTMLView(
                                          name: aboutUs.name,
                                          content: aboutUs.content,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.emoji_events_outlined,
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    size: 22),
                                title: const Text('LM Club Rewards',
                                    style: TextStyle(
                                        color: Color.fromRGBO(35, 44, 58, 1),
                                        fontSize: 14,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w500)),
                                onTap: () {
                                  LMClubRewards? lmClubReward =
                                      state.userDetails?.lmClubRewards;
                                  if (lmClubReward != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => HTMLView(
                                          name: lmClubReward.name,
                                          content: lmClubReward.content,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              ListTile(
                                leading: const Icon(
                                    CupertinoIcons.checkmark_shield,
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    size: 22),
                                title: const Text(
                                    'Terms of use and privacy policy.',
                                    style: TextStyle(
                                        color: Color.fromRGBO(35, 44, 58, 1),
                                        fontSize: 14,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w500)),
                                onTap: () {
                                  TC? tc = state.userDetails?.tc;
                                  if (tc != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => WebView(),
                                      ),
                                    );
                                  }
                                },
                              ),
                              ListTile(
                                leading: const Icon(CupertinoIcons.delete,
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    size: 22),
                                title: const Text('Delete Account',
                                    style: TextStyle(
                                        color: Color.fromRGBO(35, 44, 58, 1),
                                        fontSize: 14,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w500)),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0)),
                                        title: const Text("Alert",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              color: Color.fromRGBO(
                                                  55, 74, 156, 1),
                                            )),
                                        content: const Text(
                                            "Are you sure you want to delete your account? This action is permanent and cannot be undone.",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              color:
                                                  Color.fromRGBO(35, 44, 58, 1),
                                            )),
                                        actions: [
                                          TextButton(
                                            child: const Text("Yes",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                )),
                                            onPressed: () {
                                              QR.back();
                                              _homeBloc.deleteAccount();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("Cancel",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
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
                            ],
                          ),
                        ),
                        const Divider(color: Colors.black, thickness: 0.7),
                        Container(
                            padding: const EdgeInsets.fromLTRB(50, 5, 5, 5),
                            // width: 200,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0)),
                                        title: const Text("Alert",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              color: Color.fromRGBO(
                                                  55, 74, 156, 1),
                                            )),
                                        content: const Text(
                                            "Are you sure you want to Sign out?",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              color:
                                                  Color.fromRGBO(35, 44, 58, 1),
                                            )),
                                        actions: [
                                          TextButton(
                                            child: const Text("Yes",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                )),
                                            onPressed: () {
                                              signOut();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("Cancel",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
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
                                child: const ListTile(
                                  leading: Icon(
                                    Icons.exit_to_app,
                                    color: Colors.black,
                                  ),
                                  title: Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                body: EasyRefresh(
                  controller: _controller,
                  header: const ClassicHeader(),
                  footer: const ClassicFooter(),
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 3));
                    if (!mounted) {
                      return;
                    }
                    setState(() {
                      _homeBloc.getUserDetails(globals.userId);
                      _homeBloc.getAllNotifications();
                    });
                    _controller.finishRefresh();
                    _controller.resetFooter();
                  },
                  child: SingleChildScrollView(
                      child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome  ${state.userDetails!.username.capitalizeOnlyFirstLater()} !',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(55, 74, 156, 1),
                                      fontSize: 18.0,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w900,
                                    ),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.userDetails!.role!.id == 1
                                        ? 'To The Worlds Membership Club!'
                                        : ' To  LM Broadcast',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(35, 44, 58, 1),
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              )),
                              //const SizedBox(height: 20),
                              state.userDetails!.role!.id == 1 &&
                                      state.refeeralCode!.referalCount! >= 10
                                  ? Stack(
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
                                            )),
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          right: 0,
                                          bottom: 10,
                                          child: Center(
                                            child: Text(
                                              getLevel(state
                                                  .refeeralCode!.referalCount!),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    35,
                                                    44,
                                                    58,
                                                    1), // Choose your desired text color
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Image.asset(
                                      "assets/images/club.png",
                                      width: 48,
                                      height: 48,
                                      alignment: Alignment.center,
                                    )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 19),
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.asset(
                              "assets/images/ban.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        state.userDetails!.role!.id == 1
                            ? Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Widgets',
                                      style: TextStyle(
                                        color: Color.fromRGBO(49, 52, 80, 1),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    // InkWell(
                                    //     onTap: () {},
                                    //     child: const Text(
                                    //       "See all",
                                    //       style: TextStyle(
                                    //         color: Color.fromRGBO(55, 74, 156, 1),
                                    //         fontSize: 13.0,
                                    //         fontFamily: 'NeueHaasGroteskTextPro',
                                    //         fontWeight: FontWeight.w500,
                                    //       ),
                                    //     ))
                                  ],
                                ),
                              )
                            : const SizedBox(height: 25),
                        //const SizedBox(height: 10.0),

                        // state.userDetails!.role!.id == 1
                        //     ?
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      state.userDetails?.role?.id == 1 ? 2 : 1,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 2),
                          itemCount: state.userDetails!.widgets!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                                width: double.infinity,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                              onTap: () {
                                                if (state
                                                        .userDetails!
                                                        .widgets![index]
                                                        .widgetName ==
                                                    'Beehive') {
                                                  popupDialog(
                                                    context,
                                                    state,
                                                    index,
                                                  );
                                                } else if (state
                                                        .userDetails!
                                                        .widgets![index]
                                                        .widgetName ==
                                                    'Broadcast') {
                                                  popupDialog(
                                                    context,
                                                    state,
                                                    index,
                                                  );
                                                } else if (state
                                                        .userDetails!
                                                        .widgets![index]
                                                        .widgetName ==
                                                    'Broadcast Business') {
                                                  popupDialog(
                                                    context,
                                                    state,
                                                    index,
                                                  );
                                                } else if (state
                                                        .userDetails!
                                                        .widgets![index]
                                                        .widgetName ==
                                                    'Refer & Earn') {
                                                  popupDialog(
                                                    context,
                                                    state,
                                                    index,
                                                  );
                                                }
                                              },
                                              child: state.userDetails?.role
                                                          ?.id ==
                                                      1
                                                  ? Container(
                                                      height: 90,
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          15, 15, 15, 16),
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                            .fromRGBO(
                                                            237, 249, 253, 1),
                                                        border: Border.all(
                                                          color: const Color
                                                              .fromRGBO(24, 125,
                                                              161, 0.2),
                                                          width: 0.7,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width: 32,
                                                            height: 32,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: state
                                                                      .userDetails!
                                                                      .widgets![
                                                                          index]
                                                                      .imagePath!
                                                                      .isNotEmpty
                                                                  ? DecorationImage(
                                                                      image: NetworkImage(state
                                                                          .userDetails!
                                                                          .widgets![
                                                                              index]
                                                                          .imagePath!),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    )
                                                                  : const DecorationImage(
                                                                      image:
                                                                          AssetImage(
                                                                        "assets/images/airdrop.png",
                                                                      ),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              state
                                                                  .userDetails!
                                                                  .widgets![
                                                                      index]
                                                                  .widgetName!,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 13.0,
                                                                fontFamily:
                                                                    'NeueHaasGroteskTextPro',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        35,
                                                                        44,
                                                                        58,
                                                                        1),
                                                              ),
                                                              overflow: TextOverflow
                                                                  .ellipsis, // This adds an ellipsis if the text overflows
                                                              maxLines:
                                                                  1, // This ensures the text is limited to one line
                                                            ),
                                                          )
                                                        ],
                                                      ))
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                            height: 140,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                70,
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    15,
                                                                    15,
                                                                    15,
                                                                    16),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color
                                                                  .fromRGBO(237,
                                                                  249, 253, 1),
                                                              border:
                                                                  Border.all(
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    24,
                                                                    125,
                                                                    161,
                                                                    0.2),
                                                                width: 0.7,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    width: 50,
                                                                    height: 50,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      image: state
                                                                              .userDetails!
                                                                              .widgets![index]
                                                                              .imagePath!
                                                                              .isNotEmpty
                                                                          ? DecorationImage(
                                                                              image: NetworkImage(state.userDetails!.widgets![index].imagePath!),
                                                                              fit: BoxFit.fill,
                                                                            )
                                                                          : const DecorationImage(
                                                                              image: AssetImage(
                                                                                "assets/images/airdrop.png",
                                                                              ),
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  state
                                                                      .userDetails!
                                                                      .widgets![
                                                                          index]
                                                                      .widgetName!,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontFamily:
                                                                        'NeueHaasGroteskTextPro',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            35,
                                                                            44,
                                                                            58,
                                                                            1),
                                                                  ),
                                                                ),
                                                                // const SizedBox(
                                                                //   width: 40,
                                                                // ),
                                                                Container(
                                                                  width: 30,
                                                                  height: 30,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color
                                                                        .fromRGBO(
                                                                        55,
                                                                        74,
                                                                        156,
                                                                        1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          51,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                      width: 1,
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .arrow_forward,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      ],
                                                    )))
                                    ]));
                          },
                        )
                      ],
                    ),
                  )),
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

  String _removeHtmlTags(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  void popupDialog(
    BuildContext context,
    HomeState state,
    int index,
  ) {
    bool termsAccepted = false;
    bool continueClicked = false;
    UserData? userDetails = state.userDetails;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String cleanedContent = _removeHtmlTags(
            state.userDetails!.widgets![index].content!.content);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 170),
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.transparent,
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 45),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Color(0xFFD0E7FA)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/pop_bg.png',
                            height: 100,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: state.userDetails!.widgets![index]
                                          .imagePath!.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(state.userDetails!
                                              .widgets![index].imagePath!),
                                          fit: BoxFit.fill,
                                        )
                                      : const DecorationImage(
                                          image: AssetImage(
                                              "assets/images/airdrop.png"),
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                state.userDetails!.widgets![index].widgetName
                                    .toString(),
                                style: const TextStyle(
                                  color: Color.fromRGBO(35, 44, 58, 1),
                                  fontSize: 22.0,
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text.rich(
                            TextSpan(
                              //   text: state.userDetails!.widgets![index].content!
                              // .content,
                              text: cleanedContent,
                              style: const TextStyle(
                                color: Color.fromRGBO(35, 44, 58, 1),
                                fontSize: 14.0,
                                fontFamily: 'NeueHaasGroteskTextPro',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
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
                                checkColor:
                                    const Color.fromARGB(255, 34, 32, 32),
                                fillColor: WidgetStateProperty.all<Color>(
                                    Colors.white),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    WidgetTermsAndConditions?
                                        termsAndConditions = userDetails
                                            ?.widgets?[index]
                                            .termsAndConditions;
                                    if (termsAndConditions != null) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => WebView(),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'I agree to the terms and conditions',
                                    style: TextStyle(
                                      color: Color.fromRGBO(78, 76, 117, 1),
                                      fontSize: 14.0,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          Color.fromRGBO(55, 74, 156, 1),
                                      decorationThickness: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Visibility(
                            visible: termsAccepted && !continueClicked,
                            child: GestureDetector(
                              onTap: termsAccepted
                                  ? () async {
                                      // Your logic here
                                      Navigator.of(context).pop();
                                      if (termsAccepted) {
                                        if (state.userDetails!.widgets![index]
                                                .widgetName ==
                                            'Beehive') {
                                          beehivePoup(context);
                                        } else if (state.userDetails!
                                                .widgets![index].widgetName ==
                                            'Broadcast') {
                                          broadCastPoup(context);
                                        } else if (state.userDetails!
                                                .widgets![index].widgetName ==
                                            'Refer & Earn') {
                                          QR.to(Routes.REFER_EARN);
                                        } else if (state.userDetails!
                                                .widgets![index].widgetName ==
                                            'Broadcast Business') {
                                          businessBroadCastPoup(context);
                                        }
                                        termsAccepted = false;
                                      }
                                    }
                                  : null,
                              child: Image.asset(
                                'assets/images/Animation.gif',
                                width: 100,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
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

  void beehivePoup(BuildContext context) {
    int selectedCardIndex = 0;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.transparent,
              content: SizedBox(
                width: MediaQuery.of(context).size.width - 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Color(0xFFD0E7FA)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),

                    // elevation: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          " Choose your preference and proceed",
                          style: TextStyle(
                            color: Color.fromRGBO(35, 44, 58, 1),
                            fontSize: 14.0,
                            fontFamily: 'NeueHaasGroteskTextPro',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCardIndex = 0;
                                });
                              },
                              child: CardItem(
                                isSelected: selectedCardIndex == 0,
                                innerCardColor: selectedCardIndex == 0
                                    ? const LinearGradient(
                                        colors: [
                                          Color.fromRGBO(55, 74, 156, 1),
                                          Color.fromRGBO(196, 154, 159, 1)
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      )
                                    : const Color.fromRGBO(255, 255, 255, 1),
                                icon: "assets/images/right-arrow.png",
                                imagePath: "assets/images/view-post.png",
                                text: 'View Posts',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCardIndex = 1;
                                });
                              },
                              child: CardItem(
                                isSelected: selectedCardIndex == 1,
                                innerCardColor: selectedCardIndex == 1
                                    ? const LinearGradient(
                                        colors: [
                                          Color.fromRGBO(55, 74, 156, 1),
                                          Color.fromRGBO(196, 154, 159, 1)
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      )
                                    : const Color.fromRGBO(255, 255, 255, 1),
                                icon: "assets/images/right-arrow.png",
                                imagePath: "assets/images/add-post.png",
                                text: 'Add Posts',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Container(
                                    height: 70,
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromRGBO(191, 215, 236, 1)),
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Center(
                                      child: Text(
                                        selectedCardIndex == 0
                                            ? "Discover the latest posts from the community and stay updated on exciting deals, events, and more!"
                                            : "Start sharing your insights and experiences now to connect with the community and earn rewards!",
                                        style: const TextStyle(
                                          color: Color.fromRGBO(35, 44, 58, 1),
                                          fontSize: 12.0,
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    top: -40,
                                    left: selectedCardIndex == 1 ? 150 : 0,
                                    right: selectedCardIndex == 0 ? 150 : 0,
                                    child: const Icon(
                                      Icons.arrow_drop_up_sharp,
                                      color: Color.fromRGBO(191, 215, 236, 1),
                                      size: 70,
                                    )),
                              ],
                            )),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Navigator.pop(context);
                                QR.back();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(
                                        Colors.transparent),
                                elevation: WidgetStateProperty.all<double>(0),
                                overlayColor: WidgetStateProperty.all<Color>(
                                    Colors.transparent),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(34.0),
                                  ),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: const Color.fromARGB(51, 0, 0, 0),
                                    width: 1,
                                  ),
                                ),
                                child: Container(
                                  // width: 154,
                                  height: 42,
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 2, 30, 2),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Close",
                                    style: TextStyle(
                                      color: Color.fromRGBO(35, 44, 58, 1),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                QR.back();
                                selectedCardIndex == 0
                                    ? QR.to(Routes.BEEHIVE)
                                    : QR.to(Routes.ADD_BEEHIVE);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(
                                        Colors.transparent),
                                elevation: WidgetStateProperty.all<double>(0),
                                overlayColor: WidgetStateProperty.all<Color>(
                                    Colors.transparent),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(34.0),
                                  ),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(55, 74, 156, 1),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: const Color.fromARGB(51, 0, 0, 0),
                                    width: 0.7,
                                  ),
                                ),
                                child: Container(
                                  // width: 154,
                                  height: 42,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 2, 20, 2),
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
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void broadCastPoup(BuildContext context) {
    int selectedCard = 0;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.transparent,
              content: SizedBox(
                width: MediaQuery.of(context).size.width - 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Color(0xFFD0E7FA)],
                        begin: Alignment.topRight,
                        end: Alignment.center,
                      ),
                    ),

                    // elevation: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCard = 0;
                                });
                              },
                              child: CardItem(
                                isSelected: selectedCard == 0,
                                innerCardColor: selectedCard == 0
                                    ? const LinearGradient(
                                        colors: [
                                          Color.fromRGBO(55, 74, 156, 1),
                                          Color.fromRGBO(196, 154, 159, 1)
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      )
                                    : const Color.fromRGBO(255, 255, 255, 1),
                                icon: "assets/images/right-arrow.png",
                                imagePath: "assets/images/view-post.png",
                                text: 'View / Share Ads',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Container(
                                    height: 70,
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromRGBO(191, 215, 236, 1)),
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: const Center(
                                      child: Text(
                                        "Explore and share compelling ads to your social media networks and earn exciting rewards!",
                                        style: TextStyle(
                                          color: Color.fromRGBO(35, 44, 58, 1),
                                          fontSize: 12.0,
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )),
                                const Positioned(
                                    top: -40,
                                    left: 0,
                                    right: 0,
                                    child: Icon(
                                      Icons.arrow_drop_up_sharp,
                                      color: Color.fromRGBO(191, 215, 236, 1),
                                      size: 70,
                                    )),
                              ],
                            )),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Navigator.pop(context);
                                QR.back();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(
                                        Colors.transparent),
                                elevation: WidgetStateProperty.all<double>(0),
                                overlayColor: WidgetStateProperty.all<Color>(
                                    Colors.transparent),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(34.0),
                                  ),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: const Color.fromARGB(51, 0, 0, 0),
                                    width: 1,
                                  ),
                                ),
                                child: Container(
                                  // width: 154,
                                  height: 42,
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 2, 30, 2),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Close",
                                    style: TextStyle(
                                      color: Color.fromRGBO(35, 44, 58, 1),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                QR.back();
                                QR.to(Routes.BROADCAST);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(
                                        Colors.transparent),
                                elevation: WidgetStateProperty.all<double>(0),
                                overlayColor: WidgetStateProperty.all<Color>(
                                    Colors.transparent),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(34.0),
                                  ),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(55, 74, 156, 1),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: const Color.fromARGB(51, 0, 0, 0),
                                    width: 0.7,
                                  ),
                                ),
                                child: Container(
                                  // width: 154,
                                  height: 42,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 2, 20, 2),
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
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void businessBroadCastPoup(BuildContext context) {
    int selectedCardIndex = 0;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.transparent,
              content: SizedBox(
                width: MediaQuery.of(context).size.width - 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Color(0xFFD0E7FA)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),

                    // elevation: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          " Choose your preference and proceed",
                          style: TextStyle(
                            color: Color.fromRGBO(35, 44, 58, 1),
                            fontSize: 14.0,
                            fontFamily: 'NeueHaasGroteskTextPro',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCardIndex = 0;
                                });
                              },
                              child: CardItem(
                                isSelected: selectedCardIndex == 0,
                                innerCardColor: selectedCardIndex == 0
                                    ? const LinearGradient(
                                        colors: [
                                          Color.fromRGBO(55, 74, 156, 1),
                                          Color.fromRGBO(196, 154, 159, 1)
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      )
                                    : const Color.fromRGBO(255, 255, 255, 1),
                                icon: "assets/images/right-arrow.png",
                                imagePath: "assets/images/view-post.png",
                                text: 'View Ad',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCardIndex = 1;
                                });
                              },
                              child: CardItem(
                                isSelected: selectedCardIndex == 1,
                                innerCardColor: selectedCardIndex == 1
                                    ? const LinearGradient(
                                        colors: [
                                          Color.fromRGBO(55, 74, 156, 1),
                                          Color.fromRGBO(196, 154, 159, 1)
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      )
                                    : const Color.fromRGBO(255, 255, 255, 1),
                                icon: "assets/images/right-arrow.png",
                                imagePath: "assets/images/video-broadCast.png",
                                text: 'Post Ad',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Container(
                                    height: 70,
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromRGBO(191, 215, 236, 1)),
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Center(
                                      child: Text(
                                        selectedCardIndex == 0
                                            ? "Browse your advertisements, exploring deals and content you've shared with the LM Club, and manage your drafts."
                                            : "Boost your business's visibility and connect with the community by posting an ad now!",
                                        style: const TextStyle(
                                          color: Color.fromRGBO(35, 44, 58, 1),
                                          fontSize: 12.0,
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    top: -40,
                                    left: selectedCardIndex == 1 ? 150 : 0,
                                    right: selectedCardIndex == 0 ? 150 : 0,
                                    child: const Icon(
                                      Icons.arrow_drop_up_sharp,
                                      color: Color.fromRGBO(191, 215, 236, 1),
                                      size: 70,
                                    )),
                              ],
                            )),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Navigator.pop(context);
                                QR.back();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(
                                        Colors.transparent),
                                elevation: WidgetStateProperty.all<double>(0),
                                overlayColor: WidgetStateProperty.all<Color>(
                                    Colors.transparent),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(34.0),
                                  ),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: const Color.fromARGB(51, 0, 0, 0),
                                    width: 1,
                                  ),
                                ),
                                child: Container(
                                  // width: 154,
                                  height: 42,
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 2, 30, 2),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Close",
                                    style: TextStyle(
                                      color: Color.fromRGBO(35, 44, 58, 1),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                QR.back();
                                selectedCardIndex == 0
                                    ? QR.to(Routes.MY_POSTS)
                                    : QR.to(Routes.BUSINESS_CREATE_POST);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(
                                        Colors.transparent),
                                elevation: WidgetStateProperty.all<double>(0),
                                overlayColor: WidgetStateProperty.all<Color>(
                                    Colors.transparent),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(34.0),
                                  ),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(55, 74, 156, 1),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: const Color.fromARGB(51, 0, 0, 0),
                                    width: 0.7,
                                  ),
                                ),
                                child: Container(
                                  // width: 154,
                                  height: 42,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 2, 20, 2),
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
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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

class CardItem extends StatelessWidget {
  final bool isSelected;
  final dynamic innerCardColor;
  final String icon;
  final String imagePath;
  final String text;

  const CardItem({
    Key? key,
    required this.isSelected,
    required this.innerCardColor,
    required this.icon,
    required this.imagePath,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 150,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: isSelected ? null : innerCardColor,
              gradient: isSelected ? innerCardColor : null,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: const Color.fromARGB(51, 0, 0, 0),
                width: 0.9,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: Offset(1, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  imagePath,
                  color: isSelected
                      ? const Color.fromRGBO(255, 255, 255, 1)
                      : const Color.fromRGBO(35, 44, 58, 1),
                  width: 45,
                  height: 45,
                ),
                const SizedBox(height: 3),
                Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isSelected
                          ? const Color.fromRGBO(255, 255, 255, 1)
                          : const Color.fromRGBO(35, 44, 58, 1),
                      fontSize: 12,
                      fontFamily: 'NeueHaasGroteskTextPro',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        if (isSelected)
          Visibility(
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  "assets/images/right-arrow.png",
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          )
      ],
    );
  }
}
