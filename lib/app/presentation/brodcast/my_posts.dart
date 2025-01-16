// MyBroadCastPost here we can saw our posts(only Bussiness User can post).

import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/models/auth/response_model/broadcast_response.dart';
import 'package:lm_club/app/presentation/brodcast/bloc/broadcast_bloc.dart';
import 'package:lm_club/app/presentation/brodcast/bloc/broadcast_state.dart';
import 'package:lm_club/app/presentation/business_module/business-broadcast/pages/video_player.dart';
import 'package:lm_club/utils/string_extention.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lm_club/utils/globals.dart' as globals;
import 'package:qlevar_router/qlevar_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import '../../../routes/app_routes.dart';

class MyPostDuration {
  final String id;
  final String value;
  final String text;

  MyPostDuration({
    required this.id,
    required this.value,
    required this.text,
  });
}

class MyPosts extends StatefulWidget {
  final String id;
  const MyPosts({Key? key, required this.id}) : super(key: key);

  @override
  State<MyPosts> createState() => _BrodcastState();
}

class _BrodcastState extends State<MyPosts> {
  final BroadcastBloc _broadcastBloc = getIt.get<BroadcastBloc>();
  late EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _broadcastBloc.fetchMyBroadcasts(selectedMyPostDuration);
    _controller = EasyRefreshController(controlFinishRefresh: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int page = 1;
  String selectedMyPostDuration = '';
  List<String> duration = ['Today', 'This Week', 'This Month', 'Last Month'];

  List<MyPostDuration> myDurationList = [
    MyPostDuration(
      id: '1',
      value: "today",
      text: "Today",
    ),
    MyPostDuration(
      id: '2',
      value: "this_week",
      text: "This Week",
    ),
    MyPostDuration(
      id: '3',
      value: "this_month",
      text: "This Month",
    ),
    MyPostDuration(
      id: '4',
      value: "last_month",
      text: "Last Month",
    ),
  ];

  String getFileNameFromUrl(String url) {
    Uri uri = Uri.parse(url);

    List<String> pathSegments = uri.pathSegments;

    if (pathSegments.isNotEmpty) {
      return pathSegments.last;
    } else {
      return uri.toString();
    }
  }

  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            _broadcastBloc..fetchMyBroadcasts(selectedMyPostDuration),
        child: BlocConsumer<BroadcastBloc, BroadcastState>(
            listener: (context, state) {
          if (state.isSuccesful!) {
            QR.to(Routes.POST_SUCCESS);
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const PostSuccess()));
            _broadcastBloc.fetchMyBroadcasts(selectedMyPostDuration);
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(SnackBar(content: Text(state.error!)));
          } else if (state.error!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor:
                    Colors.red, // Change background color of SnackBar
                content: Center(
                  child: Text(
                    state.error!,
                    style: const TextStyle(
                      color:
                          Colors.white, // Change text color of SnackBar content
                      fontSize: 16, // Change font size of SnackBar content
                      // Add other text styles as needed
                    ),
                  ),
                ),
                duration:
                    const Duration(seconds: 3), // Adjust duration as needed
              ),
            );
          }
        }, builder: (context, state) {
          final List<BroadcastDetails> myBroadcastsPosts = state
              .broadcastDetails
              .where((detail) => detail.isDrafted == false)
              .toList();
          return Stack(children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'My Broadcasts',
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
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const Brodcast()));
                  },
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              CupertinoIcons.plus_app_fill,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: () {
                              QR.to(Routes.BUSINESS_CREATE_POST);
                              setState(() {
                                selectedMyPostDuration = '';
                              });
                              _broadcastBloc.fetchMyBroadcasts(
                                selectedMyPostDuration,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                      onTap: () {
                        _showBottomSheet1(context, state);
                      },
                      child: Image.asset(
                        'assets/images/filter-mypost.png',
                        height: 30,
                        // width: 30,
                      )),
                  GestureDetector(
                      onTap: () {
                        _showBottomSheet(context);
                      },
                      child: Image.asset(
                        'assets/images/Menu.png',
                        height: 30,
                        // width: 30,
                      ))
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
              body: myBroadcastsPosts.isNotEmpty
                  ? EasyRefresh(
                      controller: _controller,
                      onRefresh: () async {
                        await Future.delayed(const Duration(seconds: 3));
                        if (!mounted) {
                          return;
                        }
                        setState(() {
                          _broadcastBloc
                              .fetchMyBroadcasts(selectedMyPostDuration);
                        });
                        _controller.finishRefresh();
                        _controller.resetFooter();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child:
                            // ListView.separated(
                            //   itemCount: state.broadcastDetails.length,
                            //   separatorBuilder:
                            //       (BuildContext context, int index) =>
                            //           const Divider(),
                            //   itemBuilder: (BuildContext context, int index) {
                            ListView.builder(
                          itemCount: myBroadcastsPosts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return
                                // state.broadcastDetails[index].isDrafted ==
                                //         false
                                //     ?

                                Column(children: [
                              Container(
                                //height: 370,
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 12),
                                decoration: BoxDecoration(
                                  // gradient: const LinearGradient(
                                  //   begin: Alignment.topLeft,
                                  //   end: Alignment.bottomRight,
                                  //   colors: [
                                  //     Color.fromRGBO(
                                  //         147, 196, 113, 0.12),
                                  //     Color.fromRGBO(75, 116, 48, 0.12),
                                  //   ],
                                  // ),
                                  color: const Color.fromRGBO(240, 240, 240, 1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(214, 216, 224, 1),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          14, 0, 14, 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
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
                                                    image: myBroadcastsPosts[
                                                                index]
                                                            .userId!
                                                            .imagePath!
                                                            .isNotEmpty
                                                        ? DecorationImage(
                                                            image: NetworkImage(
                                                                myBroadcastsPosts[
                                                                        index]
                                                                    .userId!
                                                                    .imagePath!),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : const DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/profile_icon.png'),
                                                            fit: BoxFit.cover,
                                                          )),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.57,
                                                child: Text(
                                                  // '@username',
                                                  myBroadcastsPosts[index]
                                                      .userId!
                                                      .username!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        35, 44, 58, 1),
                                                    fontSize: 12,
                                                    fontFamily:
                                                        "NeueHaasGroteskTextPro",
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Flexible(
                                            child: Text(
                                              myBroadcastsPosts[index]
                                                  .status!
                                                  .key!,
                                              style: TextStyle(
                                                color: myBroadcastsPosts[index]
                                                            .status!
                                                            .key ==
                                                        'APPROVED BY ADMIN'
                                                    ? Colors.green
                                                    : myBroadcastsPosts[index]
                                                                .status!
                                                                .key ==
                                                            'PENDING BY ADMIN'
                                                        ? const Color.fromRGBO(
                                                            35, 44, 58, 1)
                                                        : myBroadcastsPosts[
                                                                        index]
                                                                    .status!
                                                                    .key ==
                                                                'REJECTED BY ADMIN'
                                                            ? Colors.red
                                                            : Colors.grey,
                                                fontSize: 8,
                                                fontFamily:
                                                    "NeueHaasGroteskTextPro",
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          // InkWell(
                                          //   onTap: () {},
                                          //   child: Transform.rotate(
                                          //     angle: -math.pi / 2,
                                          //     child: const Icon(
                                          //       CupertinoIcons.ellipsis,
                                          //       color: Color.fromRGBO(
                                          //           214, 216, 224, 1),
                                          //       size: 20,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _dialogBuilder(context, state, index);
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.fromLTRB(
                                            14, 0, 14, 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            (myBroadcastsPosts[index]
                                                    .images!
                                                    .isNotEmpty)
                                                ? (myBroadcastsPosts[index]
                                                            .images!
                                                            .length ==
                                                        1
                                                    ? !myBroadcastsPosts[index]
                                                            .images![0]
                                                            .type
                                                            .isVideo
                                                        ? Image.network(
                                                            myBroadcastsPosts[
                                                                    index]
                                                                .images![0]
                                                                .path!,
                                                            width:
                                                                double.infinity,
                                                            height: 208,
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          )
                                                        : VideoPlayerWidget(
                                                            videoPath:
                                                                myBroadcastsPosts[
                                                                        index]
                                                                    .images![0]
                                                                    .path!,
                                                          )
                                                    : SizedBox(
                                                        width: double.infinity,
                                                        height: 208,
                                                        child: slider
                                                            .CarouselSlider(
                                                          options: slider
                                                              .CarouselOptions(
                                                            height:
                                                                200, // Adjust height as needed
                                                            enlargeCenterPage:
                                                                true,
                                                            autoPlay: true,
                                                            enableInfiniteScroll:
                                                                true,
                                                            aspectRatio: 0.5,
                                                            viewportFraction: 1,
                                                          ),
                                                          items:
                                                              myBroadcastsPosts[
                                                                      index]
                                                                  .images!
                                                                  .map(
                                                                      (imageUrl) {
                                                            return Image
                                                                .network(
                                                              imageUrl.path!,
                                                              width: double
                                                                  .infinity,
                                                              height: 208,
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                            );
                                                          }).toList(),
                                                        )))
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 15, 20, 3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          13, 0, 13, 0),
                                                  child: Text(
                                                    myBroadcastsPosts[index]
                                                        .title!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          35, 44, 58, 1),
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
                                          ),
                                          globals.role == '1'
                                              ? Row(
                                                  children: [
                                                    myBroadcastsPosts[index]
                                                                .status!
                                                                .key ==
                                                            "APPROVED BY ADMIN"
                                                        ? GestureDetector(
                                                            onTap: () async {
                                                              // List<ImagesList> images =
                                                              //     state
                                                              //         .broadcastDetails[
                                                              //             index]
                                                              //         .images!;
                                                              // List<String>
                                                              //     localFilePaths = [];

                                                              // await Future.wait(images
                                                              //     .map(
                                                              //         (imageURL) async {
                                                              //   if (imageURL != null &&
                                                              //       imageURL.path !=
                                                              //           null) {
                                                              //     String fileName =
                                                              //         getFileNameFromUrl(
                                                              //             imageURL
                                                              //                 .path!);

                                                              //     final response =
                                                              //         await http.get(Uri
                                                              //             .parse(imageURL
                                                              //                 .path!));

                                                              //     if (response
                                                              //             .statusCode ==
                                                              //         200) {
                                                              //       final tempDir =
                                                              //           await getTemporaryDirectory();
                                                              //       final filePath =
                                                              //           '${tempDir.path}/$fileName';

                                                              //       await File(filePath)
                                                              //           .writeAsBytes(
                                                              //               response
                                                              //                   .bodyBytes);
                                                              //       localFilePaths
                                                              //           .add(filePath);
                                                              //     } else {
                                                              //       print(
                                                              //           'Failed to download image. Status code: ${response.statusCode}');
                                                              //     }
                                                              //   }
                                                              // }));

                                                              // // Combine title, description, and image paths for sharing
                                                              // String title = state
                                                              //     .broadcastDetails[
                                                              //         index]
                                                              //     .title!;
                                                              // String description = state
                                                              //     .broadcastDetails[
                                                              //         index]
                                                              //     .description!;
                                                              // String content =
                                                              //     'Title: $title\n\nDescription: $description';
                                                              // // ignore: deprecated_member_use
                                                              // await Share.shareFiles(
                                                              //     localFilePaths,
                                                              //     text: content);

                                                              shareToSocialApps(
                                                                state,
                                                                index,
                                                                myBroadcastsPosts[
                                                                        index]
                                                                    .id!,
                                                              );
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  'assets/images/share.png',
                                                                  width: 21,
                                                                  height: 21,
                                                                ),
                                                                const SizedBox(
                                                                    width: 3),
                                                                const Text(
                                                                  'Share',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'NeueHaasGroteskTextPro',
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            35,
                                                                            44,
                                                                            58,
                                                                            1),
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 20),
                                                              ],
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                    myBroadcastsPosts[index]
                                                                    .isEdited ==
                                                                false &&
                                                            myBroadcastsPosts[
                                                                        index]
                                                                    .status!
                                                                    .id ==
                                                                2
                                                        ? ElevatedButton.icon(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromRGBO(
                                                                      55,
                                                                      74,
                                                                      156,
                                                                      1),
                                                              minimumSize:
                                                                  const Size(
                                                                      30, 20),
                                                            ),
                                                            onPressed: () {
                                                              QR.toName(
                                                                  Routes
                                                                      .BUSINESS_EDIT_POST
                                                                      .name,
                                                                  params: {
                                                                    'broadcastId':
                                                                        myBroadcastsPosts[index]
                                                                            .id!,
                                                                  });
                                                            },
                                                            icon: Image.asset(
                                                              'assets/images/edit.png',
                                                              width: 8,
                                                              height: 8,
                                                            ),
                                                            label: const Text(
                                                              'Edit',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'NeueHaasGroteskTextPro',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   padding: const EdgeInsets.fromLTRB(
                                    //       20, 15, 10, 5),
                                    //   child: Text(
                                    //     state.broadcastDetails[index]
                                    //         .description!,
                                    //     //state.broadcastDetails[index].description,
                                    //     style: const TextStyle(
                                    //       color: Color.fromRGBO(
                                    //           35, 44, 58, 1),
                                    //       fontSize: 11,
                                    //       fontFamily:
                                    //           "NeueHaasGroteskTextPro",
                                    //       fontWeight: FontWeight.normal,
                                    //     ),
                                    //     maxLines: 2,
                                    //     overflow: TextOverflow.ellipsis,
                                    //   ),
                                    // ),
                                    // state.broadcastDetails[index]
                                    //             .expiresAt !=
                                    //         null
                                    //     ? Container(
                                    //         padding:
                                    //             const EdgeInsets.fromLTRB(
                                    //                 20, 5, 13, 0),
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //               'assets/images/lCalendar.png',
                                    //               width: 17,
                                    //               height: 17,
                                    //               color: Colors.black,
                                    //             ),
                                    //             const SizedBox(width: 1),
                                    //             const Text(
                                    //               "Expires on",
                                    //               overflow: TextOverflow
                                    //                   .ellipsis,
                                    //               style: TextStyle(
                                    //                 color: Color.fromRGBO(
                                    //                     35, 44, 58, 1),
                                    //                 fontSize: 12,
                                    //                 fontFamily:
                                    //                     "NeueHaasGroteskTextPro",
                                    //                 fontWeight:
                                    //                     FontWeight.w500,
                                    //               ),
                                    //               maxLines: 1,
                                    //             ),
                                    //             const SizedBox(width: 3),
                                    //             Text(
                                    //               DateFormat('MM/dd/yyyy')
                                    //                   .format(state
                                    //                       .broadcastDetails[
                                    //                           index]
                                    //                       .expiresAt!),
                                    //               style: const TextStyle(
                                    //                 color: Color.fromRGBO(
                                    //                     35, 44, 58, 1),
                                    //                 fontSize: 12,
                                    //                 fontFamily:
                                    //                     "NeueHaasGroteskTextPro",
                                    //                 fontWeight:
                                    //                     FontWeight.w500,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       )
                                    //     : const SizedBox()

                                    ExpandableContainer(
                                      description: myBroadcastsPosts[index]
                                              .description!
                                              .isNotEmpty
                                          ? myBroadcastsPosts[index]
                                              .description!
                                          : ' ',
                                      expiresAt:
                                          myBroadcastsPosts[index].expiresAt,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              )
                            ]);
                            // : const SizedBox();
                          },
                        ),
                      ),
                    )
                  : !state.isLoading
                      ? const SizedBox(
                          child: Center(
                          child: Text(
                            'No Posts Available',
                            style: TextStyle(
                              color: Color.fromRGBO(35, 44, 58, 1),
                              fontSize: 16,
                              fontFamily: "NeueHaasGroteskTextPro",
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ))
                      : const SizedBox(),
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
              child: (state.broadcastDetails[index].images!.isNotEmpty)
                  ? (state.broadcastDetails[index].images!.length == 1
                      ? !state.broadcastDetails[index].images![0].type.isVideo
                          ? Image.network(
                              state.broadcastDetails[index].images![0].path!,
                              width: double.infinity,
                              height: 310,
                              fit: BoxFit.fill,
                            )
                          : VideoPlayerWidget(
                              videoPath: state
                                  .broadcastDetails[index].images![0].path!,
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
                            items: state.broadcastDetails[index].images!
                                .map((imageUrl) {
                              return Image.network(
                                imageUrl.path!,
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
                  title: const Text('My Broadcasts',
                      style: TextStyle(
                          color: Color.fromRGBO(35, 44, 58, 1),
                          fontSize: 14,
                          fontFamily: 'NeueHaasGroteskTextPro',
                          fontWeight: FontWeight.w500)),
                  onTap: () {
                    QR.back();
                    // QR.to(Routes.MY_POSTS);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const Brodcast()));
                  },
                ),
                ListTile(
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
                    setState(() {
                      selectedMyPostDuration = '';
                    });
                    _broadcastBloc.fetchMyBroadcasts(
                      selectedMyPostDuration,
                    );
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             MyDrafts(id: globals.userId)));
                  },
                )
              ]))
            ]),
          ),
        );
      },
    );
  }

  void shareToSocialApps(
    BroadcastState state,
    int index,
    int postId,
  ) async {
    List<ImagesList> images = state.broadcastDetails[index].images!;
    List<XFile> localFiles = [];

    await Future.wait(images.map((imageURL) async {
      if (imageURL.path != null) {
        String fileName = getFileNameFromUrl(imageURL.path!);
        final response = await http.get(Uri.parse(imageURL.path!));

        if (response.statusCode == 200) {
          final tempDir = await getTemporaryDirectory();
          final filePath = '${tempDir.path}/$fileName';

          await File(filePath).writeAsBytes(response.bodyBytes);
          localFiles.add(XFile(filePath));
        } else {
          if (kDebugMode) {
            print(
                'Failed to download image. Status code: ${response.statusCode}');
          }
        }
      }
    }));

    String title = state.broadcastDetails[index].title!;
    String description = state.broadcastDetails[index].description!;
    String content = 'Title: $title\n\nDescription: $description';
    // String modeofShare = '';
    bool shareAttempted = false; // Flag to track if sharing was attempted

    if (localFiles.isNotEmpty) {
      final result =
          await Share.shareXFiles(localFiles, text: content, subject: title);

      // Set flag indicating sharing was attempted
      shareAttempted = true;

      // Use a timeout to check if the share was declined
      Future.delayed(const Duration(seconds: 2), () {
        if (!shareAttempted) {
          // Share was declined
          if (kDebugMode) {
            print('Share was declined');
          }
        }
      });

      String typeOfShareUrl = result.raw;
      String typeOfShare = getNextWordAfterCom(typeOfShareUrl);

      if (result.status == ShareResultStatus.success) {
        // Share was successful, hit the API
        String modeofShare = '';
        if (typeOfShare == 'whatsapp') {
          modeofShare = 'Whatsapp Share';
        } else if (typeOfShare == 'instagram') {
          modeofShare = 'Instagram Share';
        } else if (typeOfShare == 'facebook') {
          modeofShare = 'Facebook Share';
        } else if (typeOfShare == 'twitter') {
          modeofShare = 'X Share';
        }
        _broadcastBloc.sharePost(postId, modeofShare);
      } else {
        // Share was canceled or failed, do not hit the API
        if (kDebugMode) {
          print('Share was canceled or failed');
        }
      }

      if (kDebugMode) {
        print('Share Result ---1${result.raw}');
        print('Share Result ---11${result.status}');
      }
    } else {
      try {
        final shResult = await Share.shareWithResult(
          content,
          subject: title,
        );
        String typeOfShareUrl = shResult.raw;
        String typeOfShare = getNextWordAfterCom(typeOfShareUrl);

        if (shResult.status == ShareResultStatus.success) {
          // Share was successful, hit the API
          String modeofShare = '';
          if (typeOfShare == 'whatsapp') {
            modeofShare = 'Whatsapp Share';
          } else if (typeOfShare == 'instagram') {
            modeofShare = 'Instagram Share';
          } else if (typeOfShare == 'facebook') {
            modeofShare = 'Facebook Share';
          } else if (typeOfShare == 'twitter') {
            modeofShare = 'X Share';
          }
          _broadcastBloc.sharePost(postId, modeofShare);
        } else {
          // Share was canceled or failed, do not hit the API
          if (kDebugMode) {
            print('Share was canceled or failed');
          }
        }

        if (kDebugMode) {
          print('Share Result ---2${shResult.raw}');
          print('Share Result ---22${shResult.status}');
        }
      } catch (e) {
        // Share failed, do not hit the API
        if (kDebugMode) {
          print('Share Result ---3$e');
        }
      }
    }

    // if (!shareSuccessful) {
    //   // Share was canceled or failed, do not hit the API
    //   if (kDebugMode) {
    //     print('Share was canceled or failed');
    //   }
    // }
  }

  String getNextWordAfterCom(String input) {
    RegExp regex = RegExp(r'com\.(\w+)');
    Match? match = regex.firstMatch(input);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    } else {
      return "";
    }
  }

  void _showBottomSheet1(BuildContext context, BroadcastState state) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return DefaultTabController(
            length: 1,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              QR.back();
                              setState(() {
                                selectedMyPostDuration = '';
                              });
                              _broadcastBloc.fetchMyBroadcasts(
                                selectedMyPostDuration,
                              );
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  CupertinoIcons.clear_circled,
                                  color: Colors.black,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Clear All',
                                  style: TextStyle(
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color.fromRGBO(72, 70, 70, 1),
                      height: 2,
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
                      child: Column(
                        children: [
                          Container(
                            color: const Color.fromRGBO(240, 240, 240, 1),
                            child: TabBar(
                              indicatorColor: Colors.white,
                              unselectedLabelColor: const Color(0XFF51566c),
                              indicatorPadding: const EdgeInsets.all(0),
                              indicatorWeight: 0,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                color: const Color.fromRGBO(35, 44, 58, 1),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelPadding: const EdgeInsets.all(0),
                              labelColor:
                                  const Color.fromRGBO(255, 255, 255, 1),
                              tabs: const [
                                Tab(
                                  child: Text(
                                    "Sort by",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 9),
                        child: TabBarView(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: myDurationList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        title: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedMyPostDuration =
                                                  myDurationList[index].value;
                                            });

                                            _broadcastBloc.selectDurationDates(
                                                selectedMyPostDuration);
                                          },
                                          child: Text(
                                            myDurationList[index].text,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              color:
                                                  Color.fromRGBO(35, 44, 58, 1),
                                            ),
                                          ),
                                        ),
                                        trailing: Theme(
                                          data: ThemeData(
                                            unselectedWidgetColor: Colors.grey,
                                          ),
                                          child: Checkbox(
                                            value: selectedMyPostDuration ==
                                                myDurationList[index].value,
                                            onChanged: (value) {
                                              setState(() {
                                                if (value!) {
                                                  selectedMyPostDuration =
                                                      myDurationList[index]
                                                          .value;
                                                } else {
                                                  selectedMyPostDuration = '';
                                                }

                                                _broadcastBloc
                                                    .selectDurationDates(
                                                        selectedMyPostDuration);
                                              });
                                            },
                                            activeColor: const Color.fromRGBO(
                                                140, 198, 36, 1),
                                            checkColor: Colors.white,
                                            visualDensity: const VisualDensity(
                                              horizontal: 0,
                                              vertical: -2,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color.fromRGBO(72, 70, 70, 1),
                      height: 2,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              QR.back();
                              setState(() {
                                selectedMyPostDuration = '';
                              });
                              _broadcastBloc.fetchMyBroadcasts(
                                selectedMyPostDuration,
                              );
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  color: Color.fromRGBO(116, 116, 116, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              QR.back();
                              _broadcastBloc
                                  .fetchMyBroadcasts(selectedMyPostDuration);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(35, 44, 59, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              elevation: 3,
                            ),
                            child: const SizedBox(
                              width: 80,
                              height: 42,
                              child: Center(
                                child: Text(
                                  'Apply Filters',
                                  style: TextStyle(
                                    fontFamily: "NeueHaasGroteskTextPro",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

class ExpandableContainer extends StatefulWidget {
  final String? description;
  final DateTime? expiresAt;
  // final String beehiveCategoryDetails;

  const ExpandableContainer(
      {Key? key, required this.description, required this.expiresAt
      //required this.beehiveCategoryDetails,
      })
      : super(key: key);

  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  bool isDescriptionExpanded = false;
  final int maxLines = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 13, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.description ?? '',
                maxLines: isDescriptionExpanded ? null : maxLines,
                // overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color.fromRGBO(35, 44, 58, 1),
                  fontSize: 10,
                  fontFamily: "NeueHaasGroteskTextPro",
                  fontWeight: FontWeight.normal,
                ),
              ),
              if (!isDescriptionExpanded &&
                  widget.description!.length > maxLines)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDescriptionExpanded = true;
                    });
                  },
                  child: const Text(
                    'More...',
                    style: TextStyle(
                      color: Color.fromRGBO(35, 44, 58, 1),
                      fontSize: 10,
                      fontFamily: "NeueHaasGroteskTextPro",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (isDescriptionExpanded)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDescriptionExpanded = false;
                    });
                  },
                  child: const Text(
                    'Less...',
                    style: TextStyle(
                      color: Color.fromRGBO(35, 44, 58, 1),
                      fontSize: 10,
                      fontFamily: "NeueHaasGroteskTextPro",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (isDescriptionExpanded) ...[
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 13, 0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/lCalendar.png',
                  width: 17,
                  height: 17,
                  color: Colors.black,
                ),
                const SizedBox(width: 1),
                const Text(
                  "Expires on",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color.fromRGBO(35, 44, 58, 1),
                    fontSize: 12,
                    fontFamily: "NeueHaasGroteskTextPro",
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(width: 3),
                Text(
                  DateFormat('MM/dd/yyyy').format(widget.expiresAt!),
                  style: const TextStyle(
                    color: Color.fromRGBO(35, 44, 58, 1),
                    fontSize: 12,
                    fontFamily: "NeueHaasGroteskTextPro",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ],
      ],
    );
  }
}
