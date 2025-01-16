// SaveBeehivePost Savedposts will be saved here


import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/models/auth/response_model/categories_response.dart';
import 'package:lm_club/app/presentation/beehive/bloc/beehive_bloc.dart';
import 'package:lm_club/app/presentation/beehive/bloc/beehive_state.dart';
import 'package:lm_club/app/presentation/business_module/business-broadcast/pages/video_player.dart';
import 'package:lm_club/utils/string_extention.dart';

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

class SavePost extends StatefulWidget {
  const SavePost({Key? key}) : super(key: key);

  @override
  State<SavePost> createState() => _SavePostState();
}

bool isSaved = false;
bool isChecked = true;

class _SavePostState extends State<SavePost> {
  late EasyRefreshController _controller;
  @override
  void initState() {
    super.initState();
    _beehiveBloc
      ..mySavedPosts(selectedCategoryIdsAsString, '', selectedDuration)
      ..getBeehiveCategories();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      // controlFinishLoad: true,
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
  List<String> duration = ['Today', 'This Week', 'This Month'];

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
    // Add more objects as needed
  ];

  // Now you can use myObjectList as a list of MyObject objects

  List<int> selectedCategoryIds = [];
  List<String> selectedCategoryIdsAsString = [];
  String selectedUserId = '';
  String selectedDuration = '';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _beehiveBloc
        ..mySavedPosts(selectedCategoryIdsAsString, '', selectedDuration)
        ..getBeehiveCategories(),
      child:
          BlocConsumer<BeehiveBloc, BeehiveState>(listener: (context, state) {
        if (state.isSaveOrLike!) {
          _beehiveBloc.mySavedPosts(selectedCategoryIdsAsString,
              state.userId ?? "", selectedDuration);
        }
      }, builder: (context, state) {
        return Stack(children: [
          MaterialApp(
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
                        'SavedPost',
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
                          // Navigator.pop(context);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const Beehive(),
                          //   ),
                          // );
                        },
                      ),
                      // actions: [
                      //   IconButton(
                      //     icon: const Icon(
                      //       CupertinoIcons.plus_app_fill,
                      //       color: Colors.white,
                      //       size: 22,
                      //     ),
                      //     onPressed: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => const AddBeehive()));
                      //       // _navigateAndDisplaySelection(context);
                      //     },
                      //   ),
                      //   IconButton(
                      //     icon: const Icon(CupertinoIcons.bars,
                      //         color: Colors.white, size: 22),
                      //     onPressed: () {
                      //       _showBottomSheet1(context);
                      //     },
                      //   ),
                      // ],
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
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0, bottom: 0.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    34.0), // Adjust the radius as needed
                                border: Border.all(
                                  color: const Color.fromRGBO(112, 112, 112, 1),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 4.0, top: 4.0),
                                child: SearchField(
                                  suggestionState: Suggestion.expand,
                                  suggestionAction: SuggestionAction.unfocus,
                                  controller: _beehiveBloc.searchController,
                                  suggestions: state.savedbeehivePosts
                                      .fold<List<SearchFieldListItem>>(
                                    [], // Initial value is an empty list
                                    (List<SearchFieldListItem> list, states) {
                                      // Convert userName to lowercase and trim whitespace
                                      String userName = states
                                          .beehivePost!.user!.userName!
                                          .toLowerCase()
                                          .trim();
                                      // Check if the userName is already present in the list
                                      bool alreadyExists = list.any((item) =>
                                          item.item.toLowerCase().trim() ==
                                          userName);
                                      // If it doesn't exist, add it to the list
                                      if (!alreadyExists) {
                                        list.add(SearchFieldListItem(
                                          userName,
                                          item: userName,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 19),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    userName
                                                        .capitalizeOnlyFirstLater(),
                                                    style: const TextStyle(
                                                      fontFamily: 'Söhne',
                                                      fontSize: 14,
                                                      color: Color.fromRGBO(
                                                          35, 44, 58, 1),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                                      }
                                      return list;
                                    },
                                  ),
                                  textInputAction: TextInputAction.search,
                                  maxSuggestionsInViewPort: 4,
                                  itemHeight: 40,
                                  searchStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromRGBO(35, 44, 58, 1),
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  searchInputDecoration: InputDecoration(
                                    prefix: const SizedBox(width: 10),
                                    suffixIcon: state.userId!.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _beehiveBloc.searchController
                                                    .clear();
                                                _beehiveBloc.mySavedPosts(
                                                    selectedCategoryIdsAsString,
                                                    '',
                                                    selectedDuration);
                                                _beehiveBloc.setUserId('');
                                              });
                                            },
                                            child: const Icon(
                                              Icons.clear,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.search,
                                            size: 20,
                                            color: Color.fromRGBO(
                                                112, 112, 112, 1),
                                          ),
                                    hintText: 'Search By Users',
                                    hintStyle: const TextStyle(
                                      color: Color.fromRGBO(112, 112, 112, 1),
                                      fontSize: 14,
                                    ),
                                    labelStyle: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(112, 112, 112, 1),
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
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
                                  ),
                                  onSearchTextChanged: (x) {
                                    // _beehiveBloc.setUserId('');
                                    // _beehiveBloc.mySavedPosts(
                                    //     selectedCategoryIdsAsString,
                                    //     '',
                                    //     selectedDuration);
                                    // return null;

                                    String selectedUserId = x.toString();
                                    // Now you can use the selected user ID as needed
                                    _beehiveBloc.setUserId(selectedUserId);
                                    _beehiveBloc.mySavedPosts(
                                        selectedCategoryIdsAsString,
                                        selectedUserId,
                                        selectedDuration);
                                    return null;
                                  },
                                  onSuggestionTap: (x) {
                                    // Fetch the user ID from the selected item
                                    String selectedUserId = x.item.toString();
                                    // Now you can use the selected user ID as needed
                                    _beehiveBloc.setUserId(selectedUserId);
                                    _beehiveBloc.mySavedPosts(
                                        selectedCategoryIdsAsString,
                                        selectedUserId,
                                        selectedDuration);

                                    // Unfocus the SearchField to allow further input
                                    FocusScope.of(context).unfocus();
                                  },
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  onSubmit: (submittedText) {
                                    if (submittedText.isEmpty) {
                                      _beehiveBloc.mySavedPosts(
                                        selectedCategoryIdsAsString,
                                        state.userId ?? '',
                                        selectedDuration,
                                      );
                                    } else {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                  context,
                                  state.beehiveCategories!
                                      .where((i) => i.isActive ?? false)
                                      .toList(),
                                  state);
                            },
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.fromLTRB(17, 8, 17, 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(34),
                                border: Border.all(
                                  color: const Color.fromRGBO(112, 112, 112, 1),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.filter_list,
                                    size: 16,
                                    color: Color.fromRGBO(170, 170, 170, 1),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Filter',
                                    style: TextStyle(
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      color: Color.fromRGBO(170, 170, 170, 1),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: state.savedbeehivePosts.isEmpty
                          ? const Center(
                              child: Text('Data Not Found'),
                            )
                          : EasyRefresh(
                              controller: _controller,
                              onRefresh: () async {
                                await Future.delayed(
                                    const Duration(seconds: 3));
                                if (!mounted) {
                                  return;
                                }
                                setState(() {
                                  _beehiveBloc.mySavedPosts(
                                      selectedCategoryIdsAsString,
                                      '',
                                      selectedDuration);
                                });
                                _controller.finishRefresh();
                                _controller.resetFooter();
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: ListView.builder(
                                      itemCount: state.savedbeehivePosts.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        bool? liked = state
                                            .savedbeehivePosts[index].liked;

                                        bool? saved = state
                                            .savedbeehivePosts[index].isSaved;
                                        return Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
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
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: const Color
                                                                            .fromRGBO(
                                                                            112,
                                                                            112,
                                                                            112,
                                                                            1),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      image: state
                                                                              .savedbeehivePosts[index]
                                                                              .beehivePost!
                                                                              .user!
                                                                              .imagePath!
                                                                              .isNotEmpty
                                                                          ? DecorationImage(
                                                                              image: NetworkImage(state.savedbeehivePosts[index].beehivePost!.user!.imagePath!),
                                                                              fit: BoxFit.cover,
                                                                            )
                                                                          : const DecorationImage(
                                                                              image: AssetImage('assets/images/profile_icon.png'),
                                                                              fit: BoxFit.cover,
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
                                                                    .savedbeehivePosts[
                                                                        index]
                                                                    .beehivePost!
                                                                    .user!
                                                                    .userName!,
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
                                                            )
                                                          ],
                                                        ),
                                                        InkWell(
                                                          onTap: () {},
                                                          child:
                                                              Transform.rotate(
                                                            angle: -math.pi / 2,
                                                            child: const Icon(
                                                              CupertinoIcons
                                                                  .ellipsis,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      214,
                                                                      216,
                                                                      224,
                                                                      1),
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _dialogBuilder(context,
                                                          state, index);
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          14, 0, 14, 0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          // (state
                                                          //         .savedbeehivePosts[
                                                          //             index]
                                                          //         .media!
                                                          //         .isNotEmpty)
                                                          //     ? (state
                                                          //                 .savedbeehivePosts[
                                                          //                     index]
                                                          //                 .media!
                                                          //                 .length ==
                                                          //             1
                                                          //         ? Image.network(
                                                          //             state
                                                          //                 .savedbeehivePosts[
                                                          //                     index]
                                                          //                 .media![0]
                                                          //                 .mediaPath,
                                                          //             width: double
                                                          //                 .infinity,
                                                          //             height: 208,
                                                          //             fit: BoxFit
                                                          //                 .contain,
                                                          //           )
                                                          //         : SizedBox(
                                                          //             width: double
                                                          //                 .infinity,
                                                          //             height: 208,
                                                          //             child:
                                                          //                 CarouselSlider(
                                                          //               options:
                                                          //                   CarouselOptions(
                                                          //                 height:
                                                          //                     200, // Adjust height as needed
                                                          //                 enlargeCenterPage:
                                                          //                     true,
                                                          //                 autoPlay:
                                                          //                     true,
                                                          //                 enableInfiniteScroll:
                                                          //                     true,
                                                          //                 aspectRatio:
                                                          //                     0.5,
                                                          //                 viewportFraction:
                                                          //                     1,
                                                          //               ),
                                                          //               items: state
                                                          //                   .savedbeehivePosts[
                                                          //                       index]
                                                          //                   .media!
                                                          //                   .map(
                                                          //                       (imageUrl) {
                                                          //                 return Image
                                                          //                     .network(
                                                          //                   imageUrl
                                                          //                       .mediaPath,
                                                          //                   width: double
                                                          //                       .infinity,
                                                          //                   height:
                                                          //                       208,
                                                          //                   fit: BoxFit
                                                          //                       .contain,
                                                          //                 );
                                                          //               }).toList(),
                                                          //             )))
                                                          //     : const SizedBox(),

                                                          (state
                                                                  .savedbeehivePosts[
                                                                      index]
                                                                  .media!
                                                                  .isNotEmpty)
                                                              ? (state
                                                                          .savedbeehivePosts[
                                                                              index]
                                                                          .media!
                                                                          .length ==
                                                                      1
                                                                  ? state
                                                                          .savedbeehivePosts[
                                                                              index]
                                                                          .media![
                                                                              0]
                                                                          .mediaType
                                                                          .isVideo
                                                                      ? VideoPlayerWidget(
                                                                          videoPath: state
                                                                              .savedbeehivePosts[index]
                                                                              .media![0]
                                                                              .mediaPath,
                                                                        )
                                                                      : Image
                                                                          .network(
                                                                          state
                                                                              .savedbeehivePosts[index]
                                                                              .media![0]
                                                                              .mediaPath,
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              208,
                                                                          fit: BoxFit
                                                                              .fitWidth,
                                                                          filterQuality:
                                                                              FilterQuality.high,
                                                                        )
                                                                  : SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          208,
                                                                      child: slider
                                                                          .CarouselSlider(
                                                                        options:
                                                                            slider.CarouselOptions(
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
                                                                            .savedbeehivePosts[index]
                                                                            .media!
                                                                            .map((media) {
                                                                          return media.mediaType.isVideo
                                                                              ? VideoPlayerWidget(
                                                                                  videoPath: media.mediaPath,
                                                                                )
                                                                              : Image.network(
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
                                                  Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        13, 15, 13, 5),
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
                                                            GestureDetector(
                                                              onTap: () {
                                                                String postId = state
                                                                    .savedbeehivePosts[
                                                                        index]
                                                                    .beehivePost!
                                                                    .id
                                                                    .toString();
                                                                String selectedLikeUserId = state
                                                                    .savedbeehivePosts[
                                                                        index]
                                                                    .beehivePost!
                                                                    .user!
                                                                    .userName
                                                                    .toString();

                                                                setState(() {
                                                                  liked =
                                                                      !liked!;
                                                                });
                                                                _beehiveBloc
                                                                    .likePosts(
                                                                        postId,
                                                                        liked!,
                                                                        selectedLikeUserId);
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Stack(
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .favorite_border,
                                                                        size:
                                                                            20,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            222,
                                                                            78,
                                                                            78),
                                                                      ),
                                                                      Positioned
                                                                          .fill(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .favorite,
                                                                          size:
                                                                              20,
                                                                          color: liked!
                                                                              ? Colors.red
                                                                              : Colors.transparent,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 2),
                                                                  Text(
                                                                    state.savedbeehivePosts[index]
                                                                            .likesCount ??
                                                                        '',
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              35,
                                                                              44,
                                                                              58,
                                                                              1),
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          "NeueHaasGroteskTextPro",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 2),
                                                                  Text(
                                                                    int.parse(state.savedbeehivePosts[index].likesCount!) >
                                                                            1
                                                                        ? 'Likes'
                                                                        : 'Like',
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              35,
                                                                              44,
                                                                              58,
                                                                              1),
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          "NeueHaasGroteskTextPro",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            String postId = state
                                                                .savedbeehivePosts[
                                                                    index]
                                                                .beehivePost!
                                                                .id
                                                                .toString();

                                                            saved = !saved!;
                                                            _beehiveBloc
                                                                .savePost(
                                                                    postId,
                                                                    saved);
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              saved!
                                                                  ? Image.asset(
                                                                      'assets/images/greenSaved.png',
                                                                      width: 15,
                                                                      height:
                                                                          15,
                                                                    )
                                                                  : Image.asset(
                                                                      'assets/images/tag.png',
                                                                      width: 13,
                                                                      height:
                                                                          13,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                              const SizedBox(
                                                                  width: 2),
                                                              Text(
                                                                saved
                                                                    ? 'Saved'
                                                                    : 'Save',
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
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(
                                                    color: Color.fromRGBO(
                                                        214, 216, 224, 1),
                                                    height: 1,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 15, 20, 3),
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
                                                                      13,
                                                                      0,
                                                                      13,
                                                                      0),
                                                              child: Text(
                                                                state
                                                                    .savedbeehivePosts[
                                                                        index]
                                                                    .beehivePost!
                                                                    .title!
                                                                    .capitalizeOnlyFirstLater(),
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
                                                                maxLines: 2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  ExpandableContainer(
                                                    description: state
                                                            .savedbeehivePosts[
                                                                index]
                                                            .beehivePost!
                                                            .description!
                                                            .isNotEmpty
                                                        ? state
                                                            .savedbeehivePosts[
                                                                index]
                                                            .beehivePost!
                                                            .description
                                                        : ' ',
                                                    couponCode: state
                                                        .savedbeehivePosts[
                                                            index]
                                                        .beehivePost!
                                                        .couponCode,
                                                    validUpto: state
                                                        .savedbeehivePosts[
                                                            index]
                                                        .beehivePost!
                                                        .validUpto,
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            )
                                          ],
                                        );
                                      })),
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
              child: (state.savedbeehivePosts[index].media!.isNotEmpty)
                  ? (state.savedbeehivePosts[index].media!.length == 1
                      ? state.savedbeehivePosts[index].media![0].mediaType
                              .isVideo
                          ? VideoPlayerWidget(
                              videoPath: state
                                  .savedbeehivePosts[index].media![0].mediaPath,
                            )
                          : Image.network(
                              state
                                  .savedbeehivePosts[index].media![0].mediaPath,
                              width: double.infinity,
                              height: 310,
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
                            items: state.savedbeehivePosts[index].media!
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

  void _showBottomSheet(BuildContext context, List<BeehiveCategory> categories,
      BeehiveState state) {
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
                                selectedDuration = '';
                                selectedCategoryIdsAsString.clear();
                                // selectedUserId = '';
                              });
                              _beehiveBloc.mySavedPosts(
                                selectedCategoryIdsAsString,
                                state.userId ?? '',
                                selectedDuration,
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
                                              selectedDuration =
                                                  myDurationList[index].value;
                                            });
                                            _beehiveBloc.selectDurationDates(
                                                selectedDuration);
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
                                            value: selectedDuration ==
                                                myDurationList[index].value,
                                            onChanged: (value) {
                                              setState(() {
                                                if (value!) {
                                                  selectedDuration =
                                                      myDurationList[index]
                                                          .value;
                                                } else {
                                                  selectedDuration = '';
                                                }
                                                _beehiveBloc
                                                    .selectDurationDates(
                                                        selectedDuration);
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
                    // const Divider(
                    //   color: Color.fromRGBO(72, 70, 70, 1),
                    //   height: 2,
                    // ),
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
                                selectedCategoryIds.clear();
                                selectedDuration = '';
                                selectedCategoryIdsAsString.clear();
                                selectedUserId = '';
                              });
                              _beehiveBloc.mySavedPosts(
                                selectedCategoryIdsAsString,
                                state.userId ?? '',
                                selectedDuration,
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
                              selectedCategoryIdsAsString = selectedCategoryIds
                                  .map((int value) => value.toString())
                                  .toList();

                              _beehiveBloc.mySavedPosts(
                                selectedCategoryIdsAsString,
                                state.userId ?? '',
                                selectedDuration,
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

  const ExpandableContainer({
    Key? key,
    required this.description,
    required this.couponCode,
    required this.validUpto,
  }) : super(key: key);

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
          widget.validUpto != null
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
        ],
      ],
    );
  }
}
