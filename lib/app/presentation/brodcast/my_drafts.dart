// myDraftPage here we can save and post broadCast later as a businessUser.

import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/models/auth/response_model/broadcast_response.dart';
import 'package:lm_club/app/presentation/brodcast/bloc/broadcast_bloc.dart';
import 'package:lm_club/app/presentation/brodcast/bloc/broadcast_state.dart';
import 'package:lm_club/app/presentation/business_module/business-broadcast/pages/video_player.dart';
import 'package:lm_club/utils/string_extention.dart';
import 'dart:math' as math;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lm_club/utils/globals.dart' as globals;
import 'package:qlevar_router/qlevar_router.dart';
import '../../../routes/app_routes.dart';

class MyDrafts extends StatefulWidget {
  final String id;
  const MyDrafts({Key? key, required this.id}) : super(key: key);

  @override
  State<MyDrafts> createState() => _BrodcastState();
}

class _BrodcastState extends State<MyDrafts> {
  final BroadcastBloc _broadcastBloc = getIt.get<BroadcastBloc>();
  late EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _broadcastBloc.fetchMyBroadcasts('');
    _controller = EasyRefreshController(controlFinishRefresh: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int page = 1;

  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _broadcastBloc..fetchMyBroadcasts(''),
        child: BlocConsumer<BroadcastBloc, BroadcastState>(
            listener: (context, state) {
          if (state.isSuccesful!) {
            QR.to(Routes.POST_SUCCESS);
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const PostSuccess()));
            _broadcastBloc.fetchMyBroadcasts('');
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(SnackBar(content: Text(state.error!)));
          } else if (state.isDraftSuccesful!) {
            _broadcastBloc.fetchMyBroadcasts('');
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
          final List<BroadcastDetails> draftedBroadcasts = state
              .broadcastDetails
              .where((detail) => detail.isDrafted!)
              .toList();
          return Stack(children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'My Drafts',
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
                  // IconButton(
                  //   icon: const Icon(
                  //     CupertinoIcons.plus_app_fill,
                  //     color: Colors.white,
                  //     size: 22,
                  //   ),
                  //   onPressed: () {
                  //     _navigateAndDisplaySelection(context);
                  //   },
                  // ),
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
              body: draftedBroadcasts.isNotEmpty
                  ? EasyRefresh(
                      controller: _controller,
                      onRefresh: () async {
                        await Future.delayed(const Duration(seconds: 3));
                        if (!mounted) {
                          return;
                        }
                        setState(() {
                          _broadcastBloc.fetchMyBroadcasts('');
                        });
                        _controller.finishRefresh();
                        _controller.resetFooter();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child:
                            // ListView.separated(
                            //   itemCount: state.broadcastDetails.length,
                            //   separatorBuilder: (BuildContext context, int index) =>
                            //       const Divider(),
                            //   itemBuilder: (BuildContext context, int index) {
                            ListView.builder(
                          itemCount: draftedBroadcasts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return

                                // state.broadcastDetails[index].isDrafted ==
                                //         true
                                //     ?
                                Column(children: [
                              Container(
                                //height: 370,
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 12),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(240, 240, 240, 1),
                                  // gradient: const LinearGradient(
                                  //   begin: Alignment.topLeft,
                                  //   end: Alignment.bottomRight,
                                  //   colors: [
                                  //     Color.fromRGBO(147, 196, 113, 0.12),
                                  //     Color.fromRGBO(75, 116, 48, 0.12),
                                  //   ],
                                  // ),
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
                                                    image: draftedBroadcasts[
                                                                index]
                                                            .userId!
                                                            .imagePath!
                                                            .isNotEmpty
                                                        ? DecorationImage(
                                                            image: NetworkImage(
                                                                draftedBroadcasts[
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
                                                  draftedBroadcasts[index]
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
                                    // Container(
                                    //   width: double.infinity,
                                    //   padding: const EdgeInsets.fromLTRB(
                                    //       14, 0, 14, 0),
                                    //   child: Column(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceAround,
                                    //     children: [
                                    //       (state.broadcastDetails[index]
                                    //               .images!.isNotEmpty)
                                    //           ? (state
                                    //                       .broadcastDetails[
                                    //                           index]
                                    //                       .images!
                                    //                       .length ==
                                    //                   1
                                    //               ? Image.network(
                                    //                   state
                                    //                       .broadcastDetails[
                                    //                           index]
                                    //                       .images![0]
                                    //                       .path!,
                                    //                   width:
                                    //                       double.infinity,
                                    //                   height: 208,
                                    //                   fit: BoxFit.cover,
                                    //                 )
                                    //               : SizedBox(
                                    //                   width:
                                    //                       double.infinity,
                                    //                   height: 208,
                                    //                   child: CarouselSlider(
                                    //                     options:
                                    //                         CarouselOptions(
                                    //                       height:
                                    //                           200, // Adjust height as needed
                                    //                       enlargeCenterPage:
                                    //                           true,
                                    //                       autoPlay: true,
                                    //                       enableInfiniteScroll:
                                    //                           true,
                                    //                       aspectRatio: 0.5,
                                    //                       viewportFraction:
                                    //                           1,
                                    //                     ),
                                    //                     items: state
                                    //                         .broadcastDetails[
                                    //                             index]
                                    //                         .images!
                                    //                         .map(
                                    //                             (imageUrl) {
                                    //                       return Image
                                    //                           .network(
                                    //                         imageUrl.path!,
                                    //                         width: double
                                    //                             .infinity,
                                    //                         height: 208,
                                    //                         fit: BoxFit
                                    //                             .cover,
                                    //                       );
                                    //                     }).toList(),
                                    //                   )))
                                    //           : const SizedBox(),
                                    //       // Image.network(
                                    //       //   state.broadcastDetails[index].image,
                                    //       //   width: double.infinity,
                                    //       //   height: 208,
                                    //       //   fit: BoxFit.cover,
                                    //       // ),
                                    //       // Container(
                                    //       //   width: double.infinity,
                                    //       //   height: 38,
                                    //       //   padding: const EdgeInsets.all(12),
                                    //       //   decoration: const BoxDecoration(
                                    //       //     color: Color.fromRGBO(
                                    //       //         0, 176, 80, 1),
                                    //       //   ),
                                    //       //   child: GestureDetector(
                                    //       //     onTap: () {},
                                    //       //     child: const Text(
                                    //       //       "Learn More ..",
                                    //       //       style: TextStyle(
                                    //       //         color: Color.fromRGBO(
                                    //       //             238, 238, 238, 1),
                                    //       //         fontSize: 12,
                                    //       //         fontFamily:
                                    //       //             "NeueHaasGroteskTextPro",
                                    //       //         fontWeight: FontWeight.w500,
                                    //       //       ),
                                    //       //     ),
                                    //       //   ),
                                    //       // ),
                                    //     ],
                                    //   ),
                                    // ),

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
                                            (draftedBroadcasts[index]
                                                    .images!
                                                    .isNotEmpty)
                                                ? (draftedBroadcasts[index]
                                                            .images!
                                                            .length ==
                                                        1
                                                    ? !draftedBroadcasts[index]
                                                            .images![0]
                                                            .type
                                                            .isVideo
                                                        ? Image.network(
                                                            draftedBroadcasts[
                                                                    index]
                                                                .images![0]
                                                                .path!,
                                                            width:
                                                                double.infinity,
                                                            height: 208,
                                                            fit: BoxFit.fill,
                                                          )
                                                        : VideoPlayerWidget(
                                                            videoPath:
                                                                draftedBroadcasts[
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
                                                              draftedBroadcasts[
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
                                                              fit: BoxFit.fill,
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
                                          13, 15, 13, 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                13, 0, 13, 0),
                                            child: Text(
                                              draftedBroadcasts[index].title!,
                                              overflow: TextOverflow.ellipsis,
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
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      55, 74, 156, 1),
                                              minimumSize: const Size(30, 20),
                                            ),
                                            onPressed: () {
                                              QR.toName(
                                                  Routes
                                                      .BUSINESS_EDIT_POST.name,
                                                  params: {
                                                    'broadcastId':
                                                        draftedBroadcasts[index]
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
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   padding: const EdgeInsets.fromLTRB(
                                    //       13, 0, 13, 7),
                                    //   child: const Text(
                                    //     "218 likes",
                                    //     style: TextStyle(
                                    //       color: Color.fromRGBO(
                                    //           238, 238, 238, 1),
                                    //       fontSize: 10,
                                    //       fontFamily:
                                    //           "NeueHaasGroteskTextPro",
                                    //       fontWeight: FontWeight.normal,
                                    //     ),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   padding: const EdgeInsets.fromLTRB(
                                    //       13, 0, 13, 0),
                                    //   child: Text(
                                    //     state
                                    //         .broadcastDetails[index].title!,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     style: const TextStyle(
                                    //       color:
                                    //           Color.fromRGBO(35, 44, 58, 1),
                                    //       fontSize: 12,
                                    //       fontFamily:
                                    //           "NeueHaasGroteskTextPro",
                                    //       fontWeight: FontWeight.w900,
                                    //     ),
                                    //     maxLines: 1,
                                    //   ),
                                    // ),
                                    const SizedBox(
                                      height: 6,
                                    ),

                                    ExpandableContainer(
                                      description: draftedBroadcasts[index]
                                              .description!
                                              .isNotEmpty
                                          ? draftedBroadcasts[index]
                                              .description!
                                          : ' ',
                                      expiresAt:
                                          draftedBroadcasts[index].expiresAt,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              )
                            ]);
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
                  title: const Text('My BroadCasts',
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
                    //         builder: (context) => const Brodcast()));
                  },
                ),
                // globals.role == '4'
                //     ? ListTile(
                //         leading: Image.asset(
                //           'assets/images/post-icon.png',
                //         ),
                //         minLeadingWidth: 2.0,
                //         title: const Text('My Posts',
                //             style: TextStyle(
                //                 color: Color.fromRGBO(35, 44, 58, 1),
                //                 fontSize: 14,
                //                 fontFamily: 'NeueHaasGroteskTextPro',
                //                 fontWeight: FontWeight.w500)),
                //         onTap: () {
                //           QR.back();
                //           QR.to(Routes.MY_POSTS);
                //           // Navigator.push(
                //           //     context,
                //           //     MaterialPageRoute(
                //           //         builder: (context) =>
                //           //             MyPosts(id: globals.userId)));
                //         },
                //       )
                //     : const SizedBox(),
                globals.role == '1'
                    ? ListTile(
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
                      )
                    : const SizedBox(),
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
                          // QR.to(Routes.MY_DRAFTS);
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
