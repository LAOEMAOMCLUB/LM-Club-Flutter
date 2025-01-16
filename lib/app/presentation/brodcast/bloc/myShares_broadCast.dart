import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/presentation/brodcast/bloc/broadcast_bloc.dart';
import 'package:lm_club/app/presentation/brodcast/bloc/broadcast_state.dart';
import 'package:lm_club/app/presentation/brodcast/post_success.dart';
import 'package:lm_club/app/presentation/business_module/business-broadcast/pages/video_player.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:lm_club/utils/globals.dart' as globals;
import 'package:lm_club/utils/string_extention.dart';

class MySharesBroadCast extends StatefulWidget {
  const MySharesBroadCast({Key? key}) : super(key: key);

  @override
  State<MySharesBroadCast> createState() => _BrodcastState();
}

class _BrodcastState extends State<MySharesBroadCast> {
  final BroadcastBloc _broadcastBloc = getIt.get<BroadcastBloc>();

  late EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _broadcastBloc.myShares();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getFileNameFromUrl(String url) {
    Uri uri = Uri.parse(url);

    // Using pathSegments to get the last segment of the path, which should be the file name
    List<String> pathSegments = uri.pathSegments;

    if (pathSegments.isNotEmpty) {
      return pathSegments.last;
    } else {
      // If pathSegments is empty, use the whole URL as the file name
      return uri.toString();
    }
  }

  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _broadcastBloc..myShares(),
        child: BlocConsumer<BroadcastBloc, BroadcastState>(
            listener: (context, state) {
          if (state.isSuccesful!) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PostSuccess()));
            _broadcastBloc.myShares();
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
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'My Shares',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'NeueHaasGroteskTextPro',
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      QR.back();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const Brodcast(),
                      //   ),
                      // );
                    },
                  ),
                  actions: [
                    GestureDetector(
                        onTap: () {
                          _showBottomSheet(context);
                        },
                        child: Image.asset(
                          'assets/images/Menu.png',
                          height: 30,
                          // width: 30,
                        ))
                    // IconButton(
                    //   icon: const Icon(CupertinoIcons.bars,
                    //       color: Colors.white, size: 22),
                    //   onPressed: () {
                    //     _showBottomSheet(context);
                    //   },
                    // ),
                  ],
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromRGBO(12, 57, 131, 1),
                          Color.fromRGBO(0, 176, 80, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                  ),
                ),
                body: EasyRefresh(
                  controller: _controller,
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 3));
                    if (!mounted) {
                      return;
                    }
                    setState(() {
                      _broadcastBloc.myShares();
                    });
                    _controller.finishRefresh();
                    _controller.resetFooter();
                  },
                  child: Column(children: [
                    Flexible(
                        child: state.myShareBroadCast.isEmpty
                            ? const Center(
                                child: Text('Data Not Found'),
                              )
                            : Container(
                                padding: const EdgeInsets.all(20),
                                child: ListView.builder(
                                  itemCount: state.myShareBroadCast.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 12),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              240, 240, 240, 1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: const Color.fromRGBO(
                                                214, 216, 224, 1),
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      14, 0, 14, 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 33,
                                                        height: 33,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1),
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
                                                                        .myShareBroadCast[
                                                                            index]
                                                                        .broadcastPost!
                                                                        .user!
                                                                        .imagePath!
                                                                        .isNotEmpty
                                                                    ? DecorationImage(
                                                                        image: NetworkImage(state
                                                                            .myShareBroadCast[index]
                                                                            .broadcastPost!
                                                                            .user!
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
                                                      ),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.57,
                                                        child: Text(
                                                          state
                                                              .myShareBroadCast[
                                                                  index]
                                                              .broadcastPost!
                                                              .user!
                                                              .userName!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    35,
                                                                    44,
                                                                    58,
                                                                    1),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                "NeueHaasGroteskTextPro",
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          ),
                                                          maxLines: 1,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Transform.rotate(
                                                      angle: -math.pi / 2,
                                                      child: const Icon(
                                                        CupertinoIcons.ellipsis,
                                                        color: Color.fromRGBO(
                                                            214, 216, 224, 1),
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _dialogBuilder(
                                                    context, state, index);
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        14, 0, 14, 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    (state
                                                            .myShareBroadCast[
                                                                index]
                                                            .media!
                                                            .isNotEmpty)
                                                        ? (state
                                                                    .myShareBroadCast[
                                                                        index]
                                                                    .media!
                                                                    .length ==
                                                                1
                                                            ? !state
                                                                    .myShareBroadCast[
                                                                        index]
                                                                    .media![0]
                                                                    .mediaType
                                                                    .isVideo
                                                                ? Image.network(
                                                                    state
                                                                        .myShareBroadCast[
                                                                            index]
                                                                        .media![
                                                                            0]
                                                                        .mediaPath!,
                                                                    width: double
                                                                        .infinity,
                                                                    height: 208,
                                                                    fit: BoxFit
                                                                        .fitWidth,
                                                                  )
                                                                : VideoPlayerWidget(
                                                                    videoPath: state
                                                                        .myShareBroadCast[
                                                                            index]
                                                                        .media![
                                                                            0]
                                                                        .mediaPath!,
                                                                  )
                                                            : SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                height: 208,
                                                                child: slider
                                                                    .CarouselSlider(
                                                                  options: slider
                                                                      .CarouselOptions(
                                                                    height:
                                                                        200, // Adjust height as needed
                                                                    enlargeCenterPage:
                                                                        true,
                                                                    autoPlay:
                                                                        true,
                                                                    enableInfiniteScroll:
                                                                        true,
                                                                    aspectRatio:
                                                                        0.5,
                                                                    viewportFraction:
                                                                        1,
                                                                  ),
                                                                  items: state
                                                                      .myShareBroadCast[
                                                                          index]
                                                                      .media!
                                                                      .map(
                                                                          (imageUrl) {
                                                                    return Image
                                                                        .network(
                                                                      imageUrl
                                                                          .mediaPath!,
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          208,
                                                                      fit: BoxFit
                                                                          .fitWidth,
                                                                    );
                                                                  }).toList(),
                                                                )))
                                                        : const SizedBox(),

                                                    // (state.myShareBroadCast[index]
                                                    //         .media!.isEmpty)
                                                    //     ? const SizedBox()
                                                    //     : Image.network(
                                                    //         state
                                                    //             .myShareBroadCast[
                                                    //                 index]
                                                    //             .media![0]
                                                    //             .mediaPath!,
                                                    //         width: double.infinity,
                                                    //         height: 208,
                                                    //         fit: BoxFit.cover,
                                                    //       )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 15, 20, 3),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                13, 0, 13, 0),
                                                        child: Text(
                                                          state
                                                              .myShareBroadCast[
                                                                  index]
                                                              .broadcastPost!
                                                              .title!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    35,
                                                                    44,
                                                                    58,
                                                                    1),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                "NeueHaasGroteskTextPro",
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          ),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  state
                                                          .myShareBroadCast[
                                                              index]
                                                          .modeOfShare!
                                                          .isNotEmpty
                                                      ? Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(7),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  state
                                                                      .myShareBroadCast[
                                                                          index]
                                                                      .modeOfShare!,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            116,
                                                                            116,
                                                                            116,
                                                                            1),
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        "NeueHaasGroteskTextPro",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              // Uncomment and add the following widgets if necessary, ensuring they have enough space.
                                                              // Image.asset(
                                                              //   'assets/images/dollar.png',
                                                              //   width: 21,
                                                              //   height: 21,
                                                              // ),
                                                              // const SizedBox(width: 5),
                                                              // Flexible(
                                                              //   child: Text(
                                                              //     state.myShareBroadCast[index].points!,
                                                              //     overflow: TextOverflow.ellipsis,
                                                              //     style: const TextStyle(
                                                              //       color: Color.fromRGBO(35, 44, 58, 1),
                                                              //       fontSize: 14,
                                                              //       fontFamily: "NeueHaasGroteskTextPro",
                                                              //       fontWeight: FontWeight.w700,
                                                              //     ),
                                                              //     maxLines: 1,
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 15, 10, 5),
                                              child: Text(
                                                state
                                                        .myShareBroadCast[index]
                                                        .broadcastPost!
                                                        .description!
                                                        .isNotEmpty
                                                    ? state
                                                        .myShareBroadCast[index]
                                                        .broadcastPost!
                                                        .description!
                                                    : ' ',
                                                //state.myShareBroadCast[index].description,
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                  fontSize: 11,
                                                  fontFamily:
                                                      "NeueHaasGroteskTextPro",
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      )
                                    ]);
                                  },
                                ))),
                  ]),
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

  Future<void> _dialogBuilder(
      BuildContext context, BroadcastState state, index) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: SizedBox(
            width: 310,
            height: 310,
            child: SizedBox(
              width: double.infinity,
              // padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
              child: (state.myShareBroadCast[index].media!.isNotEmpty)
                  ? (state.myShareBroadCast[index].media!.length == 1
                      ? !state.myShareBroadCast[index].media![0].mediaType
                              .isVideo
                          ? Image.network(
                              state
                                  .myShareBroadCast[index].media![0].mediaPath!,
                              width: double.infinity,
                              height: 310,
                              fit: BoxFit.fill,
                            )
                          : VideoPlayerWidget(
                              videoPath: state
                                  .myShareBroadCast[index].media![0].mediaPath!,
                            )
                      : SizedBox(
                          width: double.infinity,
                          height: 310,
                          child: slider.CarouselSlider(
                            options: slider.CarouselOptions(
                              height: 310, // Adjust height as needed
                              enlargeCenterPage: true,
                              autoPlay: true,
                              enableInfiniteScroll: true,
                              aspectRatio: 0.5,
                              viewportFraction: 1,
                            ),
                            items: state.myShareBroadCast[index].media!
                                .map((imageUrl) {
                              return Image.network(
                                imageUrl.mediaPath!,
                                width: double.infinity,
                                height: 310,
                                fit: BoxFit.fill,
                              );
                            }).toList(),
                          )))
                  : const SizedBox(),
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // const Text(
                    //   'LM - Brodcast',
                    //   style: TextStyle(
                    //     color: Color.fromRGBO(55, 74, 156, 1),
                    //     fontSize: 14,
                    //     fontFamily: 'NeueHaasGroteskTextPro',
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        QR.back();
                      },
                      child: const Row(
                        children: [
                          Icon(
                            CupertinoIcons.clear_circled,
                            color: Color.fromRGBO(116, 116, 116, 1),
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Close',
                            style: TextStyle(
                              fontFamily: 'NeueHaasGroteskTextPro',
                              color: Color.fromRGBO(116, 116, 116, 1),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Color.fromRGBO(221, 221, 221, 1),
                height: 1,
              ),
              const SizedBox(height: 10),
              SizedBox(
                  // height: 170,
                  child: ListView(shrinkWrap: true, children: [
                ListTile(
                  leading: Image.asset(
                    'assets/images/home-icon.png',
                  ),
                  minLeadingWidth: 2.0,
                  title: const Text('Feed',
                      style: TextStyle(
                          color: Color.fromRGBO(35, 44, 58, 1),
                          fontSize: 14,
                          fontFamily: 'NeueHaasGroteskTextPro',
                          fontWeight: FontWeight.w500)),
                  onTap: () {
                    QR.back();
                    QR.to(Routes.BROADCAST);
                  },
                ),
                globals.role == '4'
                    ? ListTile(
                        leading: Image.asset(
                          'assets/images/post-icon.png',
                        ),
                        minLeadingWidth: 2.0,
                        title: const Text('My Posts',
                            style: TextStyle(
                                color: Color.fromRGBO(35, 44, 58, 1),
                                fontSize: 14,
                                fontFamily: 'NeueHaasGroteskTextPro',
                                fontWeight: FontWeight.w500)),
                        onTap: () {
                          QR.back();
                          QR.to(Routes.MY_POSTS);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             MyPosts(id: globals.userId)));
                        },
                      )
                    : const SizedBox(),
                ListTile(
                  leading: Image.asset(
                    'assets/images/share-icon.png',
                  ),
                  minLeadingWidth: 2.0,
                  title: const Text('My Shares',
                      style: TextStyle(
                          color: Color.fromRGBO(35, 44, 58, 1),
                          fontSize: 14,
                          fontFamily: 'NeueHaasGroteskTextPro',
                          fontWeight: FontWeight.w500)),
                  onTap: () {
                    QR.back();
                    QR.to(Routes.MY_SHARES_BROADCAST);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const MySharesBroadCast()));
                  },
                ),
                // globals.role == '4'
                //     ? ListTile(
                //         leading: Image.asset(
                //           'assets/images/saved.png',
                //         ),
                //         title: const Text('Saved',
                //             style: TextStyle(
                //                 color: Color.fromRGBO(35, 44, 58, 1),
                //                 fontSize: 14,
                //                 fontFamily: 'NeueHaasGroteskTextPro',
                //                 fontWeight: FontWeight.w500)),
                //         onTap: () {},
                //       )
                //     : const SizedBox(),
                globals.role == '4'
                    ? ListTile(
                        leading: Image.asset(
                          'assets/images/draft-icon.png',
                        ),
                        minLeadingWidth: 2.0,
                        title: const Text('Drafts',
                            style: TextStyle(
                                color: Color.fromRGBO(35, 44, 58, 1),
                                fontSize: 14,
                                fontFamily: 'NeueHaasGroteskTextPro',
                                fontWeight: FontWeight.w500)),
                        onTap: () {
                          QR.back();
                          QR.to(Routes.MY_DRAFTS);
                          // Navigator.pop(context);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             MyDrafts(id: globals.userId)));
                        },
                      )
                    : const SizedBox()
              ]))
            ]),
          ),
        );
      },
    );
  }
}
