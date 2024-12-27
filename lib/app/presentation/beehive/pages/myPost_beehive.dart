// MyBeehivePost we can see only our post

import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:intl/intl.dart';
import 'package:lm_club/app/models/auth/response_model/categories_response.dart';
import 'package:lm_club/app/presentation/beehive/bloc/beehive_bloc.dart';
import 'package:lm_club/app/presentation/beehive/bloc/beehive_state.dart';
import 'package:lm_club/app/presentation/business_module/business-broadcast/pages/video_player.dart';
import 'package:lm_club/utils/string_extention.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDuration {
  final String id;
  final String value;
  final String text;

  MyDuration({
    required this.id,
    required this.value,
    required this.text,
  });
}

class MyPostsBeehive extends StatefulWidget {
  const MyPostsBeehive({Key? key}) : super(key: key);

  @override
  State<MyPostsBeehive> createState() => _MyPostsBeehive();
}

List<MyDuration> myDurationList = [
  MyDuration(
    id: '1',
    value: "today",
    text: "Today",
  ),
  MyDuration(
    id: '2',
    value: "this_week",
    text: "This Week",
  ),
  MyDuration(
    id: '3',
    value: "this_month",
    text: "This Month",
  ),
];

bool isTapped = false;
bool isChecked = true;
String? formattedDate;
List<int> selectedCategoryIds = [];
List<String> selectedPostCategory = [];
String selectedPostDuration = '';

class _MyPostsBeehive extends State<MyPostsBeehive> {
  late EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _beehiveBloc
      ..myPostsBeehive(selectedPostCategory, selectedPostDuration)
      ..getBeehiveCategories();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int page = 3;
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();
  Future<bool> removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  final BeehiveBloc _beehiveBloc = getIt.get<BeehiveBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _beehiveBloc
        ..myPostsBeehive(selectedPostCategory, selectedPostDuration)
        ..getBeehiveCategories(),
      child: BlocConsumer<BeehiveBloc, BeehiveState>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
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
                        elevation: 0,
                        title: const Text(
                          'MyPosts',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'NeueHaasGroteskTextPro',
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        leading: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            QR.back();
                          },
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                context,
                                state.beehiveCategories!
                                    .where((i) => i.isActive ?? false)
                                    .toList(),
                              );
                            },
                            child: Container(
                              // height: 36,
                              padding: const EdgeInsets.fromLTRB(17, 8, 17, 8),

                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.filter_list,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Filter',
                                    style: TextStyle(
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                    ),
                  ),
                  body: state.mypostbeehiveDetails.isEmpty
                      ? const Center(
                          child: Text('No Posts are available'),
                        )
                      : EasyRefresh(
                          controller: _controller,
                          onRefresh: () async {
                            await Future.delayed(const Duration(seconds: 3));
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              _beehiveBloc
                                ..myPostsBeehive(
                                    selectedPostCategory, selectedPostDuration)
                                ..getBeehiveCategories();
                            });
                            _controller.finishRefresh();
                            _controller.resetFooter();
                          },
                          child: Column(
                            children: [
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: ListView.builder(
                                    itemCount:
                                        state.mypostbeehiveDetails.length,
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
                                                          MainAxisAlignment
                                                              .start,
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
                                                                  border: Border
                                                                      .all(
                                                                    color: const Color
                                                                        .fromRGBO(
                                                                        112,
                                                                        112,
                                                                        112,
                                                                        1),
                                                                    width: 2.0,
                                                                  ),
                                                                  image: state
                                                                          .mypostbeehiveDetails[
                                                                              index]
                                                                          .user!
                                                                          .imagePath!
                                                                          .isNotEmpty
                                                                      ? DecorationImage(
                                                                          image: NetworkImage(state
                                                                              .mypostbeehiveDetails[index]
                                                                              .user!
                                                                              .imagePath!),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )
                                                                      : const DecorationImage(
                                                                          image:
                                                                              AssetImage('assets/images/profile_icon.png'),
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
                                                                0.27,
                                                            child: Text(
                                                              state
                                                                  .mypostbeehiveDetails[
                                                                      index]
                                                                  .user!
                                                                  .userName,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        35,
                                                                        44,
                                                                        58,
                                                                        1),
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    "NeueHaasGroteskTextPro",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              ),
                                                              maxLines: 1,
                                                            ))
                                                      ],
                                                    ),
                                                    Flexible(
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            if (state
                                                                .mypostbeehiveDetails[
                                                                    index]
                                                                .expired!)
                                                              const Text(
                                                                'POST EXPIRED',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 8,
                                                                  fontFamily:
                                                                      "NeueHaasGroteskTextPro",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            // const SizedBox(
                                                            //     width: 10),
                                                            Text(
                                                              state
                                                                  .mypostbeehiveDetails[
                                                                      index]
                                                                  .status!
                                                                  .key,
                                                              style: TextStyle(
                                                                color: state
                                                                            .mypostbeehiveDetails[
                                                                                index]
                                                                            .status!
                                                                            .key ==
                                                                        'APPROVED BY ADMIN'
                                                                    ? Colors
                                                                        .green
                                                                    : state.mypostbeehiveDetails[index].status!.key ==
                                                                            'PENDING BY ADMIN'
                                                                        ? const Color
                                                                            .fromRGBO(
                                                                            35,
                                                                            44,
                                                                            58,
                                                                            1)
                                                                        : state.mypostbeehiveDetails[index].status!.key ==
                                                                                'REJECTED BY ADMIN'
                                                                            ? Colors.red
                                                                            : Colors.grey,
                                                                fontSize: 8,
                                                                fontFamily:
                                                                    "NeueHaasGroteskTextPro",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            )
                                                          ]),
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
                                                              .mypostbeehiveDetails[
                                                                  index]
                                                              .media!
                                                              .isNotEmpty)
                                                          ? (state
                                                                      .mypostbeehiveDetails[
                                                                          index]
                                                                      .media!
                                                                      .length ==
                                                                  1
                                                              ? state
                                                                      .mypostbeehiveDetails[
                                                                          index]
                                                                      .media![0]
                                                                      .mediaType
                                                                      .isVideo
                                                                  ? VideoPlayerWidget(
                                                                      videoPath: state
                                                                          .mypostbeehiveDetails[
                                                                              index]
                                                                          .media![
                                                                              0]
                                                                          .mediaPath,
                                                                    )
                                                                  : Image
                                                                      .network(
                                                                      state
                                                                          .mypostbeehiveDetails[
                                                                              index]
                                                                          .media![
                                                                              0]
                                                                          .mediaPath,
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          208,
                                                                      fit: BoxFit
                                                                          .fitWidth,
                                                                      filterQuality:
                                                                          FilterQuality
                                                                              .high,
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
                                                                        .mypostbeehiveDetails[
                                                                            index]
                                                                        .media!
                                                                        .map(
                                                                            (media) {
                                                                      return media
                                                                              .mediaType
                                                                              .isVideo
                                                                          ? VideoPlayerWidget(
                                                                              videoPath: media.mediaPath,
                                                                            )
                                                                          : Image
                                                                              .network(
                                                                              media.mediaPath,
                                                                              width: double.infinity,
                                                                              height: 208,
                                                                              fit: BoxFit.fitWidth,
                                                                              filterQuality: FilterQuality.high,
                                                                            );
                                                                    }).toList(),
                                                                  ),
                                                                ))
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Divider(
                                                color: Color.fromRGBO(
                                                    214, 216, 224, 1),
                                                height: 1,
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
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              70,
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  13, 0, 13, 0),
                                                          child: Text(
                                                            state
                                                                .mypostbeehiveDetails[
                                                                    index]
                                                                .title!,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      35,
                                                                      44,
                                                                      58,
                                                                      1),
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  "NeueHaasGroteskTextPro",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ExpandableContainer(
                                                description: state
                                                        .mypostbeehiveDetails[
                                                            index]
                                                        .description!
                                                        .isNotEmpty
                                                    ? state
                                                        .mypostbeehiveDetails[
                                                            index]
                                                        .description!
                                                    : ' ',
                                                couponCode: state
                                                    .mypostbeehiveDetails[index]
                                                    .couponCode!,
                                                validUpto: state
                                                    .mypostbeehiveDetails[index]
                                                    .validUpto,
                                                validFrom: state
                                                    .mypostbeehiveDetails[index]
                                                    .validFrom,
                                                startTime: state
                                                    .mypostbeehiveDetails[index]
                                                    .startTime,
                                                endTime: state
                                                    .mypostbeehiveDetails[index]
                                                    .endTime,
                                                beehiveCategoryDetails: state
                                                    .mypostbeehiveDetails[index]
                                                    .beehiveCategory!
                                                    .categoryName,
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
                              ),
                            ],
                          ),
                        ),
                ));
          }),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, BeehiveState state, index) {
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
              child: (state.mypostbeehiveDetails[index].media!.isNotEmpty)
                  ? (state.mypostbeehiveDetails[index].media!.length == 1
                      ? state.mypostbeehiveDetails[index].media![0].mediaType
                              .isVideo
                          ? VideoPlayerWidget(
                              videoPath: state.mypostbeehiveDetails[index]
                                  .media![0].mediaPath,
                            )
                          : Image.network(
                              state.mypostbeehiveDetails[index].media![0]
                                  .mediaPath,
                              width: double.infinity,
                              height: 208,
                              fit: BoxFit.fill,
                              filterQuality: FilterQuality.high,
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
                            items: state.mypostbeehiveDetails[index].media!
                                .map((media) {
                              return media.mediaType.isVideo
                                  ? VideoPlayerWidget(
                                      videoPath: media.mediaPath,
                                    )
                                  : Image.network(
                                      media.mediaPath,
                                      width: double.infinity,
                                      height: 310,
                                      fit: BoxFit.fill,
                                      filterQuality: FilterQuality.high,
                                    );
                            }).toList(),
                          ),
                        ))
                  : const SizedBox(),
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(
      BuildContext context, List<BeehiveCategory> categories) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return DefaultTabController(
            length: 2,
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
                                selectedCategoryIds.clear();
                                selectedPostDuration = '';
                                selectedPostCategory.clear();
                              });
                              _beehiveBloc.myPostsBeehive(
                                selectedPostCategory,
                                selectedPostDuration,
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
                                    "Categories",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
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
                                    itemCount: categories.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      int catId = categories[index].id;
                                      return ListTile(
                                        title: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (selectedCategoryIds
                                                  .contains(catId)) {
                                                selectedCategoryIds
                                                    .remove(catId);
                                              } else {
                                                selectedCategoryIds.add(catId);
                                              }
                                            });
                                            _beehiveBloc.getCategoryIdSelection(
                                                catId.toString());
                                          },
                                          child: Text(
                                            categories[index].category,
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
                                            value: selectedCategoryIds
                                                .contains(catId),
                                            onChanged: (value) {
                                              setState(() {
                                                if (value!) {
                                                  selectedCategoryIds
                                                      .add(catId);
                                                } else {
                                                  selectedCategoryIds
                                                      .remove(catId);
                                                }
                                              });
                                              _beehiveBloc
                                                  .getCategoryIdSelection(
                                                      catId.toString());
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
                                const Divider(
                                  color: Color.fromRGBO(72, 70, 70, 1),
                                  height: 2,
                                ),
                              ],
                            ),
                            // Content for Tab 2
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
                                              selectedPostDuration =
                                                  myDurationList[index].value;
                                            });

                                            _beehiveBloc.selectDurationDates(
                                                selectedPostDuration);
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
                                            value: selectedPostDuration ==
                                                myDurationList[index].value,
                                            onChanged: (value) {
                                              setState(() {
                                                if (value!) {
                                                  selectedPostDuration =
                                                      myDurationList[index]
                                                          .value;
                                                } else {
                                                  selectedPostDuration = '';
                                                }

                                                _beehiveBloc
                                                    .selectDurationDates(
                                                        selectedPostDuration);
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
                                selectedPostDuration = '';
                                selectedPostCategory.clear();
                              });
                              _beehiveBloc.myPostsBeehive(
                                selectedPostCategory,
                                selectedPostDuration,
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
                              selectedPostCategory = selectedCategoryIds
                                  .map((int value) => value.toString())
                                  .toList();
                              _beehiveBloc.myPostsBeehive(
                                selectedPostCategory,
                                selectedPostDuration,
                              );
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

class ClickableListTile extends StatelessWidget {
  final String title;
  final Image icon;
  final VoidCallback onTap;

  const ClickableListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(240, 240, 240, 1),
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13.0,
                  fontFamily: 'NeueHaasGroteskTextPro',
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              color: Colors.black,
              width: 0.5,
              height: 30.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 16.0),
              child: icon,
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandableContainer extends StatefulWidget {
  final String? description;
  final String? couponCode;
  final DateTime? validUpto;
  final DateTime? validFrom;
  final String? startTime;
  final String? endTime;
  final String beehiveCategoryDetails;
  const ExpandableContainer({
    Key? key,
    required this.description,
    required this.couponCode,
    required this.validUpto,
    required this.validFrom,
    required this.endTime,
    required this.startTime,
    required this.beehiveCategoryDetails,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  bool isDescriptionExpanded = false;
  final int maxLines = 2;

  @override
  Widget build(BuildContext context) {
    String? formattedStartTime;
    String? formattedEndTime;

    final validFromText = widget.validFrom != null
        ? DateFormat('dd MMM yyyy').format(widget.validFrom!)
        : '';
    final validUptoText = widget.validUpto != null
        ? DateFormat('dd MMM yyyy').format(widget.validUpto!)
        : '';

    String? startTimeString = widget.startTime;
    if (startTimeString != null && startTimeString.isNotEmpty) {
      DateTime time = DateFormat('HH:mm:ss').parse(startTimeString);
      formattedStartTime = DateFormat('h:mm a').format(time);
    }

    String? endTimeString = widget.endTime;
    if (endTimeString != null && endTimeString.isNotEmpty) {
      DateTime endTime = DateFormat('HH:mm:ss').parse(endTimeString);
      formattedEndTime = DateFormat('h:mm a').format(endTime);
    }

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
          widget.couponCode?.isNotEmpty ?? false
              ? Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 13, 0),
                  child: Row(
                    children: [
                      const Text(
                        "Code :",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color.fromRGBO(35, 44, 58, 1),
                          fontSize: 12,
                          fontFamily: "NeueHaasGroteskTextPro",
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        widget.couponCode!,
                        style: const TextStyle(
                          color: Color.fromRGBO(35, 44, 58, 1),
                          fontSize: 12,
                          fontFamily: "NeueHaasGroteskTextPro",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 3),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: widget.couponCode!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Text copied to clipboard'),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/images/copy.png',
                          width: 17,
                          height: 17,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: 5),
          widget.validUpto != null &&
                  widget.beehiveCategoryDetails == 'Coupons/Deals'
              ? Container(
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
                        DateFormat('MM/dd/yyyy').format(widget.validUpto!),
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
              : const SizedBox(),
          widget.validUpto != null && widget.beehiveCategoryDetails == 'Events'
              ? Column(
                  children: [
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
                          const SizedBox(width: 3),
                          Text(
                            '$validFromText - $validUptoText',
                            style: const TextStyle(
                              color: Color.fromRGBO(35, 44, 58, 1),
                              fontSize: 12,
                              fontFamily: "NeueHaasGroteskTextPro",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 13, 0),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/clock.png',
                            width: 17,
                            height: 17,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '$formattedStartTime - $formattedEndTime ET',
                            style: const TextStyle(
                              color: Color.fromRGBO(35, 44, 58, 1),
                              fontSize: 12,
                              fontFamily: "NeueHaasGroteskTextPro",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ],
    );
  }
}
