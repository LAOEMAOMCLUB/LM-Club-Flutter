// NotificationPage here we can display all notifications.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/models/auth/response_model/notifications_response.dart';
import 'package:lm_club/app/presentation/notification/bloc/notification_bloc.dart';
import 'package:lm_club/app/presentation/notification/bloc/notification_state.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:lm_club/utils/globals.dart' as globals;

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationBloc _notificationBloc = getIt.get<NotificationBloc>();
  bool isread = false;
  List<int> notificationIds = [];
  late int widgetId;
  List<AllNotifications> broadcastNotifications = [];
  List<AllNotifications> beehiveNotifications = [];
  List<AllNotifications> referEarnNotifications = [];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _notificationBloc..getAllNotifications(),
        child: BlocConsumer<NotificationBloc, NotificationState>(
            listener: (context, state) async {
          if (state.isMarkNotification!) {
            //_notificationBloc.getAllNotifications();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color.fromRGBO(55, 74, 156, 1),
                content: Center(
                  child: Text(
                    state.markAllAsRead!,
                    style: const TextStyle(
                      color: Color.fromRGBO(235, 237, 245, 1),
                      fontSize: 16,
                    ),
                  ),
                ),
                duration: const Duration(seconds: 2),
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
          } else if (state.readordelete) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Center(
                  child: Text(
                    state.isReadDelete,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
            _notificationBloc.getAllNotifications();
          }
        }, builder: (context, state) {
          broadcastNotifications = state.allNotifications!
              .where((item) => item.widget!.id == 4)
              .toList();
          beehiveNotifications = state.allNotifications!
              .where((item) => item.widget!.id == 3)
              .toList();
          referEarnNotifications = state.allNotifications!
              .where((item) => item.widget!.id == 12)
              .toList();
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
                    leading: notificationIds.isEmpty
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () {
                              QR.back();
                            },
                          )
                        : const SizedBox(),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        notificationIds.isEmpty
                            ? const Text(
                                'Notifications',
                                style: TextStyle(
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                  fontSize: 16,
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isread = true;
                                    notificationIds.clear();
                                    for (var notification
                                        in state.allNotifications!) {
                                      if (notification.widget!.id == 3) {
                                        notificationIds
                                            .remove(notification.id!);
                                      } else if (notification.widget!.id == 4) {
                                        notificationIds
                                            .remove(notification.id!);
                                      } else if (notification.widget!.id ==
                                          12) {
                                        notificationIds
                                            .remove(notification.id!);
                                      }
                                    }
                                    isread = false;
                                  });
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.close, size: 24),
                                    const SizedBox(width: 5),
                                    const Text(
                                      'Select ',
                                      style: TextStyle(
                                        color: Color.fromRGBO(238, 238, 238, 1),
                                        fontSize: 16,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      notificationIds.isNotEmpty
                                          ? ' ${notificationIds.length}'
                                          : '',
                                      style: const TextStyle(
                                        color: Color.fromRGBO(238, 238, 238, 1),
                                        fontSize: 16,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(width: 20),
                        isread == false
                            ? const SizedBox()
                            : notificationIds.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        setState(() {
                                          _notificationBloc.deleteNotification(
                                              notificationIds, widgetId);
                                          isread = false;
                                          notificationIds = [];
                                        });
                                      });
                                    },
                                    child: Image.asset(
                                      'assets/images/delete_box.png',
                                      width: 35,
                                      height: 35,
                                    ),
                                  )
                                : const SizedBox(),
                      ],
                    ),
                    actions: [
                      notificationIds.isEmpty
                          ? PopupMenuButton<String>(
                              offset: const Offset(-7, 40),
                              shape: const BeveledRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == "Select") {
                                  setState(() {
                                    isread = true;
                                  });
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem<String>(
                                    value: "Select",
                                    child: Text(
                                      "Select",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ];
                              },
                            )
                          : PopupMenuButton<String>(
                              offset: const Offset(-7, 40),
                              shape: const BeveledRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == "Mark") {
                                  setState(() {
                                    _notificationBloc.readNotification(
                                        notificationIds, widgetId);
                                    isread = false;
                                    notificationIds = [];
                                  });
                                } else if (value == "SelectAll") {
                                  setState(() {
                                    isread = true;
                                    notificationIds.clear();
                                    for (var notification
                                        in state.allNotifications!) {
                                      if (notification.widget!.id == 3 ||
                                          notification.widget!.id == 4 ||
                                          notification.widget!.id == 12) {
                                        notificationIds.add(notification.id!);
                                      // ignore: unrelated_type_equality_checks
                                      } else if (notification.widget!.id ==
                                          value) {
                                        notificationIds.add(notification.id!);
                                      }
                                    }
                                  });
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem<String>(
                                    value: "SelectAll",
                                    child: Text(
                                      "Select All",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: "Mark",
                                    child: Text(
                                      "Mark as Read",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                ];
                              },
                            ),
                    ],
                    centerTitle: false,
                    elevation: 0,
                  ),
                ),
              ),
              body: Column(
                children: [
                  Flexible(
                    child: DefaultTabController(
                        length: globals.role == '4' ? 1 : 3,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(children: [
                            globals.role == '4'
                                ? TabBar(
                                    tabs: [
                                      Tab(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Broadcast",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily:
                                                    'NeueHaasGroteskTextPro',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            state.countObjetcts != null &&
                                                    state.countObjetcts!
                                                            .getBroadcastUnreadCount !=
                                                        null &&
                                                    state.countObjetcts!
                                                            .getBroadcastUnreadCount! >
                                                        0
                                                ? Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        state.countObjetcts!
                                                            .getBroadcastUnreadCount
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                    ],

                                    labelColor: const Color.fromRGBO(0, 158,
                                        247, 1), // Selected tab text color
                                    unselectedLabelColor:
                                        const Color.fromRGBO(35, 44, 58, 1),
                                    indicator: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color.fromRGBO(0, 158, 247, 1),
                                          width: 3.0,
                                        ),
                                      ),
                                    ),
                                  )
                                : TabBar(
                                    tabs: [
                                      Tab(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Beehive",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily:
                                                    'NeueHaasGroteskTextPro',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            state.countObjetcts != null &&
                                                    state.countObjetcts!
                                                            .getBeehiveUnreadCount !=
                                                        null &&
                                                    state.countObjetcts!
                                                            .getBeehiveUnreadCount! >
                                                        0
                                                ? Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        state.countObjetcts!
                                                            .getBeehiveUnreadCount
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                      Tab(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Refer & Earn",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily:
                                                    'NeueHaasGroteskTextPro',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            state.countObjetcts != null &&
                                                    state.countObjetcts!
                                                            .getReferAndEarnUnreadCount !=
                                                        null &&
                                                    state.countObjetcts!
                                                            .getReferAndEarnUnreadCount! >
                                                        0
                                                ? Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        state.countObjetcts!
                                                            .getReferAndEarnUnreadCount
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                      Tab(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Broadcast",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily:
                                                    'NeueHaasGroteskTextPro',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            state.countObjetcts != null &&
                                                    state.countObjetcts!
                                                            .getBroadcastUnreadCount !=
                                                        null &&
                                                    state.countObjetcts!
                                                            .getBroadcastUnreadCount! >
                                                        0
                                                ? Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        state.countObjetcts!
                                                            .getBroadcastUnreadCount
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                    ],

                                    labelColor: const Color.fromRGBO(0, 158,
                                        247, 1), // Selected tab text color
                                    unselectedLabelColor:
                                        const Color.fromRGBO(35, 44, 58, 1),
                                    indicator: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color.fromRGBO(0, 158, 247, 1),
                                          width: 3.0,
                                        ),
                                      ),
                                    ),
                                  ),
                            Expanded(
                              child: globals.role == '4'
                                  ? TabBarView(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child:
                                                  broadcastNotifications
                                                          .isNotEmpty
                                                      ? ListView.builder(
                                                          itemCount:
                                                              broadcastNotifications
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final item =
                                                                broadcastNotifications[
                                                                    index];
                                                            final List<String>
                                                                words = item
                                                                    .message!
                                                                    .split(' ');
                                                            final String
                                                                firstWord =
                                                                words.isNotEmpty
                                                                    ? words
                                                                        .first
                                                                    : '';
                                                            final String
                                                                remainingText =
                                                                words.length > 1
                                                                    ? words
                                                                        .sublist(
                                                                            1)
                                                                        .join(
                                                                            ' ')
                                                                    : '';

                                                            final String
                                                                timeAgo =
                                                                timeago.format(
                                                              DateTime.parse(item
                                                                      .createdOn!)
                                                                  .toLocal(),
                                                              locale:
                                                                  'en_short',
                                                            );

                                                            DateTime
                                                                createdDate =
                                                                DateTime.parse(item
                                                                    .createdOn!);

                                                            bool isToday = createdDate
                                                                        .year ==
                                                                    DateTime.now()
                                                                        .year &&
                                                                createdDate
                                                                        .month ==
                                                                    DateTime.now()
                                                                        .month &&
                                                                createdDate
                                                                        .day ==
                                                                    DateTime.now()
                                                                        .day;

                                                            bool isYesterday = createdDate
                                                                        .year ==
                                                                    DateTime.now()
                                                                        .year &&
                                                                createdDate
                                                                        .month ==
                                                                    DateTime.now()
                                                                        .month &&
                                                                createdDate
                                                                        .day ==
                                                                    DateTime.now()
                                                                        .subtract(const Duration(
                                                                            days:
                                                                                1))
                                                                        .day;
                                                            int? ids =
                                                                broadcastNotifications[
                                                                        index]
                                                                    .id;
                                                            widgetId =
                                                                broadcastNotifications[
                                                                        index]
                                                                    .widget!
                                                                    .id!;

                                                            if (item.widget!
                                                                    .id ==
                                                                4) {
                                                              if (isToday) {
                                                                return Column(
                                                                    children: [
                                                                      Container(
                                                                          color: item.isRead! == false
                                                                              ? const Color.fromRGBO(231, 255, 234, 1)
                                                                              : Colors.transparent,
                                                                          child: GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _notificationBloc.viewNotification(item.id.toString());

                                                                              item.widget!.id == 4 ? QR.navigator.replace(Routes.NOTIFICATION, Routes.MY_POSTS) : null;
                                                                            },
                                                                            child:
                                                                                ListTile(
                                                                              leading: isread == false
                                                                                  ? Container(
                                                                                      width: 50,
                                                                                      height: 50,
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        border: Border.all(
                                                                                          color: const Color.fromRGBO(112, 112, 112, 1),
                                                                                          width: 2.0,
                                                                                        ),
                                                                                        image: item.actionBy!.imagePath!.isNotEmpty || item.actionBy!.imagePath != null
                                                                                            ? DecorationImage(
                                                                                                image: NetworkImage(item.actionBy!.imagePath!),
                                                                                                fit: BoxFit.cover,
                                                                                              )
                                                                                            : const DecorationImage(
                                                                                                image: AssetImage('assets/images/profile_icon.png'),
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                      ))
                                                                                  : Checkbox(
                                                                                      value: notificationIds.contains(ids),
                                                                                      onChanged: (value) {
                                                                                        setState(() {
                                                                                          if (value!) {
                                                                                            notificationIds.add(ids!);
                                                                                          } else {
                                                                                            notificationIds.remove(ids);
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                      activeColor: const Color.fromRGBO(140, 198, 36, 1),
                                                                                      checkColor: Colors.white,
                                                                                      visualDensity: const VisualDensity(
                                                                                        horizontal: 0,
                                                                                        vertical: -2,
                                                                                      ),
                                                                                    ),
                                                                              title: Row(
                                                                                children: [
                                                                                  // Text(
                                                                                  //   firstWord,
                                                                                  //   style:
                                                                                  //       const TextStyle(
                                                                                  //     color: Color.fromRGBO(
                                                                                  //         35,
                                                                                  //         44,
                                                                                  //         58,
                                                                                  //         1),
                                                                                  //     fontSize:
                                                                                  //         14,
                                                                                  //     fontFamily:
                                                                                  //         'NeueHaasGroteskTextPro',
                                                                                  //     fontWeight:
                                                                                  //         FontWeight.bold,
                                                                                  //   ),
                                                                                  // ),
                                                                                  // const SizedBox(
                                                                                  //     width:
                                                                                  //         5),
                                                                                  Flexible(
                                                                                    // flex:
                                                                                    //     1,
                                                                                    child: TextScroll(
                                                                                      "$firstWord $remainingText",
                                                                                      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                                                                      intervalSpaces: 10,
                                                                                      pauseBetween: const Duration(milliseconds: 5500),
                                                                                      mode: TextScrollMode.endless,
                                                                                      delayBefore: const Duration(milliseconds: 2000),
                                                                                      numberOfReps: 2,
                                                                                      style: const TextStyle(
                                                                                        color: Color.fromRGBO(35, 44, 58, 1),
                                                                                        fontSize: 14,
                                                                                        fontFamily: 'NeueHaasGroteskTextPro',
                                                                                        fontWeight: FontWeight.w400,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              subtitle: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    timeAgo,
                                                                                    style: const TextStyle(
                                                                                      color: Color.fromRGBO(116, 116, 116, 1),
                                                                                      fontSize: 13,
                                                                                      fontFamily: 'NeueHaasGroteskTextPro',
                                                                                      fontWeight: FontWeight.w400,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              trailing: !item.isRead!
                                                                                  ? Container(
                                                                                      width: 10,
                                                                                      height: 10,
                                                                                      decoration: const BoxDecoration(
                                                                                        color: Color.fromRGBO(0, 176, 80, 1), // Color of the dot
                                                                                        shape: BoxShape.circle,
                                                                                      ),
                                                                                    )
                                                                                  : null,
                                                                            ),
                                                                          ))
                                                                    ]);
                                                              } else if (isYesterday) {
                                                                return Column(
                                                                    children: [
                                                                      Container(
                                                                          color: item.isRead! == false
                                                                              ? const Color.fromRGBO(231, 255, 234, 1)
                                                                              : Colors.transparent,
                                                                          child: GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _notificationBloc.viewNotification(item.id.toString());

                                                                              item.widget!.id == 4 ? QR.navigator.replace(Routes.NOTIFICATION, Routes.MY_POSTS) : null;
                                                                            },
                                                                            child:
                                                                                ListTile(
                                                                              leading: isread == false
                                                                                  ? Container(
                                                                                      width: 50,
                                                                                      height: 50,
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        border: Border.all(
                                                                                          color: const Color.fromRGBO(112, 112, 112, 1),
                                                                                          width: 2.0,
                                                                                        ),
                                                                                        image: item.actionBy!.imagePath!.isNotEmpty || item.actionBy!.imagePath != null
                                                                                            ? DecorationImage(
                                                                                                image: NetworkImage(item.actionBy!.imagePath!),
                                                                                                fit: BoxFit.cover,
                                                                                              )
                                                                                            : const DecorationImage(
                                                                                                image: AssetImage('assets/images/profile_icon.png'),
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                      ))
                                                                                  : Checkbox(
                                                                                      value: notificationIds.contains(ids),
                                                                                      onChanged: (value) {
                                                                                        setState(() {
                                                                                          if (value!) {
                                                                                            notificationIds.add(ids!);
                                                                                          } else {
                                                                                            notificationIds.remove(ids);
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                      activeColor: const Color.fromRGBO(140, 198, 36, 1),
                                                                                      checkColor: Colors.white,
                                                                                      visualDensity: const VisualDensity(
                                                                                        horizontal: 0,
                                                                                        vertical: -2,
                                                                                      ),
                                                                                    ),
                                                                              title: Row(
                                                                                children: [
                                                                                  // Text(
                                                                                  //   firstWord,
                                                                                  //   style:
                                                                                  //       const TextStyle(
                                                                                  //     color: Color.fromRGBO(
                                                                                  //         35,
                                                                                  //         44,
                                                                                  //         58,
                                                                                  //         1),
                                                                                  //     fontSize:
                                                                                  //         14,
                                                                                  //     fontFamily:
                                                                                  //         'NeueHaasGroteskTextPro',
                                                                                  //     fontWeight:
                                                                                  //         FontWeight.bold,
                                                                                  //   ),
                                                                                  // ),
                                                                                  // const SizedBox(
                                                                                  //     width:
                                                                                  //         5),
                                                                                  Flexible(
                                                                                    // flex:
                                                                                    //     1,
                                                                                    child: TextScroll(
                                                                                      "$firstWord $remainingText",
                                                                                      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                                                                      intervalSpaces: 10,
                                                                                      pauseBetween: const Duration(milliseconds: 5500),
                                                                                      mode: TextScrollMode.endless,
                                                                                      delayBefore: const Duration(milliseconds: 2000),
                                                                                      numberOfReps: 2,
                                                                                      style: const TextStyle(
                                                                                        color: Color.fromRGBO(35, 44, 58, 1),
                                                                                        fontSize: 14,
                                                                                        fontFamily: 'NeueHaasGroteskTextPro',
                                                                                        fontWeight: FontWeight.w400,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              subtitle: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    timeAgo,
                                                                                    style: const TextStyle(
                                                                                      color: Color.fromRGBO(116, 116, 116, 1),
                                                                                      fontSize: 13,
                                                                                      fontFamily: 'NeueHaasGroteskTextPro',
                                                                                      fontWeight: FontWeight.w400,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              trailing: !item.isRead!
                                                                                  ? Container(
                                                                                      width: 10,
                                                                                      height: 10,
                                                                                      decoration: const BoxDecoration(
                                                                                        color: Color.fromRGBO(0, 176, 80, 1), // Color of the dot
                                                                                        shape: BoxShape.circle,
                                                                                      ),
                                                                                    )
                                                                                  : null,
                                                                            ),
                                                                          ))
                                                                    ]);
                                                              } else {
                                                                // Display the notification with the date
                                                                return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // ListTile for the date
                                                                    ListTile(
                                                                      title:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Text(
                                                                          DateFormat('MMMM d, yyyy')
                                                                              .format(createdDate),
                                                                          style:
                                                                              const TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                170,
                                                                                170,
                                                                                170,
                                                                                1),
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'NeueHaasGroteskTextPro',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // ListTile for the notification
                                                                    Column(
                                                                        children: [
                                                                          Container(
                                                                              color: item.isRead! == false ? const Color.fromRGBO(231, 255, 234, 1) : Colors.transparent,
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  _notificationBloc.viewNotification(item.id.toString());
                                                                                  item.widget!.id == 4 ? QR.navigator.replace(Routes.NOTIFICATION, Routes.MY_POSTS) : null;
                                                                                },
                                                                                child: ListTile(
                                                                                  leading: isread == false
                                                                                      ? Container(
                                                                                          width: 50,
                                                                                          height: 50,
                                                                                          decoration: BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            border: Border.all(
                                                                                              color: const Color.fromRGBO(112, 112, 112, 1),
                                                                                              width: 2.0,
                                                                                            ),
                                                                                            image: item.actionBy!.imagePath!.isNotEmpty || item.actionBy!.imagePath != null
                                                                                                ? DecorationImage(
                                                                                                    image: NetworkImage(item.actionBy!.imagePath!),
                                                                                                    fit: BoxFit.cover,
                                                                                                  )
                                                                                                : const DecorationImage(
                                                                                                    image: AssetImage('assets/images/profile_icon.png'),
                                                                                                    fit: BoxFit.cover,
                                                                                                  ),
                                                                                          ))
                                                                                      : Checkbox(
                                                                                          value: notificationIds.contains(ids),
                                                                                          onChanged: (value) {
                                                                                            setState(() {
                                                                                              if (value!) {
                                                                                                notificationIds.add(ids!);
                                                                                              } else {
                                                                                                notificationIds.remove(ids);
                                                                                              }
                                                                                            });
                                                                                          },
                                                                                          activeColor: const Color.fromRGBO(140, 198, 36, 1),
                                                                                          checkColor: Colors.white,
                                                                                          visualDensity: const VisualDensity(
                                                                                            horizontal: 0,
                                                                                            vertical: -2,
                                                                                          ),
                                                                                        ),
                                                                                  title: Row(
                                                                                    children: [
                                                                                      // Text(
                                                                                      //   firstWord,
                                                                                      //   style:
                                                                                      //       const TextStyle(
                                                                                      //     color: Color.fromRGBO(
                                                                                      //         35,
                                                                                      //         44,
                                                                                      //         58,
                                                                                      //         1),
                                                                                      //     fontSize:
                                                                                      //         14,
                                                                                      //     fontFamily:
                                                                                      //         'NeueHaasGroteskTextPro',
                                                                                      //     fontWeight:
                                                                                      //         FontWeight.bold,
                                                                                      //   ),
                                                                                      // ),
                                                                                      // const SizedBox(
                                                                                      //     width:
                                                                                      //         5),
                                                                                      Flexible(
                                                                                        // flex:
                                                                                        //     1,
                                                                                        child: TextScroll(
                                                                                          "$firstWord $remainingText",
                                                                                          velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                                                                          intervalSpaces: 10,
                                                                                          pauseBetween: const Duration(milliseconds: 5500),
                                                                                          mode: TextScrollMode.endless,
                                                                                          delayBefore: const Duration(milliseconds: 2000),
                                                                                          numberOfReps: 2,
                                                                                          style: const TextStyle(
                                                                                            color: Color.fromRGBO(35, 44, 58, 1),
                                                                                            fontSize: 14,
                                                                                            fontFamily: 'NeueHaasGroteskTextPro',
                                                                                            fontWeight: FontWeight.w400,
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  subtitle: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        timeAgo,
                                                                                        style: const TextStyle(
                                                                                          color: Color.fromRGBO(116, 116, 116, 1),
                                                                                          fontSize: 13,
                                                                                          fontFamily: 'NeueHaasGroteskTextPro',
                                                                                          fontWeight: FontWeight.w400,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  trailing: !item.isRead!
                                                                                      ? Container(
                                                                                          width: 10,
                                                                                          height: 10,
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Color.fromRGBO(0, 176, 80, 1), // Color of the dot
                                                                                            shape: BoxShape.circle,
                                                                                          ),
                                                                                        )
                                                                                      : null,
                                                                                ),
                                                                              ))
                                                                        ])
                                                                  ],
                                                                );
                                                              }
                                                            } else {
                                                              return const SizedBox(); //
                                                            }
                                                          },
                                                        )
                                                      : const Center(
                                                          child: Text(
                                                            'No Notifications Received Yet',
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      35,
                                                                      44,
                                                                      58,
                                                                      1),
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'NeueHaasGroteskTextPro',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : TabBarView(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child:
                                                  beehiveNotifications
                                                          .isNotEmpty
                                                      ? ListView.builder(
                                                          itemCount:
                                                              beehiveNotifications
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final item =
                                                                beehiveNotifications[
                                                                    index];
                                                            final List<String>
                                                                words = item
                                                                    .message!
                                                                    .split(' ');
                                                            final String
                                                                firstWord =
                                                                words.isNotEmpty
                                                                    ? words
                                                                        .first
                                                                    : '';
                                                            final String
                                                                remainingText =
                                                                words.length > 1
                                                                    ? words
                                                                        .sublist(
                                                                            1)
                                                                        .join(
                                                                            ' ')
                                                                    : '';

                                                            final String
                                                                timeAgo =
                                                                timeago.format(
                                                              DateTime.parse(item
                                                                      .createdOn!)
                                                                  .toLocal(),
                                                              locale:
                                                                  'en_short',
                                                            );

                                                            DateTime
                                                                createdDate =
                                                                DateTime.parse(item
                                                                    .createdOn!);

                                                            bool isToday = createdDate
                                                                        .year ==
                                                                    DateTime.now()
                                                                        .year &&
                                                                createdDate
                                                                        .month ==
                                                                    DateTime.now()
                                                                        .month &&
                                                                createdDate
                                                                        .day ==
                                                                    DateTime.now()
                                                                        .day;

                                                            bool isYesterday = createdDate
                                                                        .year ==
                                                                    DateTime.now()
                                                                        .year &&
                                                                createdDate
                                                                        .month ==
                                                                    DateTime.now()
                                                                        .month &&
                                                                createdDate
                                                                        .day ==
                                                                    DateTime.now()
                                                                        .subtract(const Duration(
                                                                            days:
                                                                                1))
                                                                        .day;
                                                            int? ids =
                                                                beehiveNotifications[
                                                                        index]
                                                                    .id;
                                                            widgetId =
                                                                beehiveNotifications[
                                                                        index]
                                                                    .widget!
                                                                    .id!;

                                                            if (item.widget!
                                                                    .id ==
                                                                3) {
                                                              if (isToday) {
                                                                return Column(
                                                                    children: [
                                                                      Container(
                                                                          color: item.isRead! == false
                                                                              ? const Color.fromRGBO(231, 255, 234, 1)
                                                                              : Colors.transparent,
                                                                          child: GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _notificationBloc.viewNotification(item.id.toString());
                                                                              item.widget!.id == 3 && beehiveNotifications[index].actionType != 'Beehive'
                                                                                  ? QR.navigator.replace(Routes.NOTIFICATION, Routes.BEEHIVE)
                                                                                  : beehiveNotifications[index].actionType == 'Beehive'
                                                                                      ? QR.navigator.replace(Routes.NOTIFICATION, Routes.REWARDS)
                                                                                      : null;
                                                                            },
                                                                            child:
                                                                                ListTile(
                                                                              leading: isread == false
                                                                                  ? Container(
                                                                                      width: 50,
                                                                                      height: 50,
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        border: Border.all(
                                                                                          color: const Color.fromRGBO(112, 112, 112, 1),
                                                                                          width: 2.0,
                                                                                        ),
                                                                                        image: item.actionBy!.imagePath!.isNotEmpty || item.actionBy!.imagePath != null
                                                                                            ? DecorationImage(
                                                                                                image: NetworkImage(item.actionBy!.imagePath!),
                                                                                                fit: BoxFit.cover,
                                                                                              )
                                                                                            : const DecorationImage(
                                                                                                image: AssetImage('assets/images/profile_icon.png'),
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                      ))
                                                                                  : Checkbox(
                                                                                      value: notificationIds.contains(ids),
                                                                                      onChanged: (value) {
                                                                                        setState(() {
                                                                                          if (value!) {
                                                                                            notificationIds.add(ids!);
                                                                                          } else {
                                                                                            notificationIds.remove(ids);
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                      activeColor: const Color.fromRGBO(140, 198, 36, 1),
                                                                                      checkColor: Colors.white,
                                                                                      visualDensity: const VisualDensity(
                                                                                        horizontal: 0,
                                                                                        vertical: -2,
                                                                                      ),
                                                                                    ),
                                                                              title: Row(
                                                                                children: [
                                                                                  // Text(
                                                                                  //   firstWord,
                                                                                  //   style:
                                                                                  //       const TextStyle(
                                                                                  //     color: Color.fromRGBO(
                                                                                  //         35,
                                                                                  //         44,
                                                                                  //         58,
                                                                                  //         1),
                                                                                  //     fontSize:
                                                                                  //         14,
                                                                                  //     fontFamily:
                                                                                  //         'NeueHaasGroteskTextPro',
                                                                                  //     fontWeight:
                                                                                  //         FontWeight.bold,
                                                                                  //   ),
                                                                                  // ),
                                                                                  // const SizedBox(
                                                                                  //     width:
                                                                                  //         5),
                                                                                  Flexible(
                                                                                    // flex:
                                                                                    //     1,
                                                                                    child: TextScroll(
                                                                                      "$firstWord $remainingText",
                                                                                      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                                                                      intervalSpaces: 10,
                                                                                      pauseBetween: const Duration(milliseconds: 5500),
                                                                                      mode: TextScrollMode.endless,
                                                                                      delayBefore: const Duration(milliseconds: 2000),
                                                                                      numberOfReps: 2,
                                                                                      style: const TextStyle(
                                                                                        color: Color.fromRGBO(35, 44, 58, 1),
                                                                                        fontSize: 14,
                                                                                        fontFamily: 'NeueHaasGroteskTextPro',
                                                                                        fontWeight: FontWeight.w400,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              subtitle: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    timeAgo,
                                                                                    style: const TextStyle(
                                                                                      color: Color.fromRGBO(116, 116, 116, 1),
                                                                                      fontSize: 13,
                                                                                      fontFamily: 'NeueHaasGroteskTextPro',
                                                                                      fontWeight: FontWeight.w400,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              trailing: !item.isRead!
                                                                                  ? Container(
                                                                                      width: 10,
                                                                                      height: 10,
                                                                                      decoration: const BoxDecoration(
                                                                                        color: Color.fromRGBO(0, 176, 80, 1), // Color of the dot
                                                                                        shape: BoxShape.circle,
                                                                                      ),
                                                                                    )
                                                                                  : null,
                                                                            ),
                                                                          ))
                                                                    ]);
                                                              } else if (isYesterday) {
                                                                return Column(
                                                                    children: [
                                                                      Container(
                                                                          color: item.isRead! == false
                                                                              ? const Color.fromRGBO(231, 255, 234, 1)
                                                                              : Colors.transparent,
                                                                          child: GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _notificationBloc.viewNotification(item.id.toString());
                                                                              item.widget!.id == 3 && beehiveNotifications[index].actionType != 'Beehive'
                                                                                  ? QR.navigator.replace(Routes.NOTIFICATION, Routes.BEEHIVE)
                                                                                  : beehiveNotifications[index].actionType == 'Beehive'
                                                                                      ? QR.navigator.replace(Routes.NOTIFICATION, Routes.REWARDS)
                                                                                      : null;
                                                                            },
                                                                            child:
                                                                                ListTile(
                                                                              leading: isread == false
                                                                                  ? Container(
                                                                                      width: 50,
                                                                                      height: 50,
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        border: Border.all(
                                                                                          color: const Color.fromRGBO(112, 112, 112, 1),
                                                                                          width: 2.0,
                                                                                        ),
                                                                                        image: item.actionBy!.imagePath!.isNotEmpty || item.actionBy!.imagePath != null
                                                                                            ? DecorationImage(
                                                                                                image: NetworkImage(item.actionBy!.imagePath!),
                                                                                                fit: BoxFit.cover,
                                                                                              )
                                                                                            : const DecorationImage(
                                                                                                image: AssetImage('assets/images/profile_icon.png'),
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                      ))
                                                                                  : Checkbox(
                                                                                      value: notificationIds.contains(ids),
                                                                                      onChanged: (value) {
                                                                                        setState(() {
                                                                                          if (value!) {
                                                                                            notificationIds.add(ids!);
                                                                                          } else {
                                                                                            notificationIds.remove(ids);
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                      activeColor: const Color.fromRGBO(140, 198, 36, 1),
                                                                                      checkColor: Colors.white,
                                                                                      visualDensity: const VisualDensity(
                                                                                        horizontal: 0,
                                                                                        vertical: -2,
                                                                                      ),
                                                                                    ),
                                                                              title: Row(
                                                                                children: [
                                                                                  // Text(
                                                                                  //   firstWord,
                                                                                  //   style:
                                                                                  //       const TextStyle(
                                                                                  //     color: Color.fromRGBO(
                                                                                  //         35,
                                                                                  //         44,
                                                                                  //         58,
                                                                                  //         1),
                                                                                  //     fontSize:
                                                                                  //         14,
                                                                                  //     fontFamily:
                                                                                  //         'NeueHaasGroteskTextPro',
                                                                                  //     fontWeight:
                                                                                  //         FontWeight.bold,
                                                                                  //   ),
                                                                                  // ),
                                                                                  // const SizedBox(
                                                                                  //     width:
                                                                                  //         5),
                                                                                  Flexible(
                                                                                    // flex:
                                                                                    //     1,
                                                                                    child: TextScroll(
                                                                                      "$firstWord $remainingText",
                                                                                      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                                                                      intervalSpaces: 10,
                                                                                      pauseBetween: const Duration(milliseconds: 5500),
                                                                                      mode: TextScrollMode.endless,
                                                                                      delayBefore: const Duration(milliseconds: 2000),
                                                                                      numberOfReps: 2,
                                                                                      style: const TextStyle(
                                                                                        color: Color.fromRGBO(35, 44, 58, 1),
                                                                                        fontSize: 14,
                                                                                        fontFamily: 'NeueHaasGroteskTextPro',
                                                                                        fontWeight: FontWeight.w400,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              subtitle: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    timeAgo,
                                                                                    style: const TextStyle(
                                                                                      color: Color.fromRGBO(116, 116, 116, 1),
                                                                                      fontSize: 13,
                                                                                      fontFamily: 'NeueHaasGroteskTextPro',
                                                                                      fontWeight: FontWeight.w400,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              trailing: !item.isRead!
                                                                                  ? Container(
                                                                                      width: 10,
                                                                                      height: 10,
                                                                                      decoration: const BoxDecoration(
                                                                                        color: Color.fromRGBO(0, 176, 80, 1), // Color of the dot
                                                                                        shape: BoxShape.circle,
                                                                                      ),
                                                                                    )
                                                                                  : null,
                                                                            ),
                                                                          ))
                                                                    ]);
                                                              } else {
                                                                // Display the notification with the date
                                                                return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // ListTile for the date
                                                                    ListTile(
                                                                      title:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Text(
                                                                          DateFormat('MMMM d, yyyy')
                                                                              .format(createdDate),
                                                                          style:
                                                                              const TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                170,
                                                                                170,
                                                                                170,
                                                                                1),
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'NeueHaasGroteskTextPro',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // ListTile for the notification
                                                                    Column(
                                                                        children: [
                                                                          Container(
                                                                              color: item.isRead! == false ? const Color.fromRGBO(231, 255, 234, 1) : Colors.transparent,
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  _notificationBloc.viewNotification(item.id.toString());
                                                                                  item.widget!.id == 3 && beehiveNotifications[index].actionType != 'Beehive'
                                                                                      ? QR.navigator.replace(Routes.NOTIFICATION, Routes.BEEHIVE)
                                                                                      : beehiveNotifications[index].actionType == 'Beehive'
                                                                                          ? QR.navigator.replace(Routes.NOTIFICATION, Routes.REWARDS)
                                                                                          : null;
                                                                                },
                                                                                child: ListTile(
                                                                                  leading: isread == false
                                                                                      ? Container(
                                                                                          width: 50,
                                                                                          height: 50,
                                                                                          decoration: BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            border: Border.all(
                                                                                              color: const Color.fromRGBO(112, 112, 112, 1),
                                                                                              width: 2.0,
                                                                                            ),
                                                                                            image: item.actionBy!.imagePath!.isNotEmpty || item.actionBy!.imagePath != null
                                                                                                ? DecorationImage(
                                                                                                    image: NetworkImage(item.actionBy!.imagePath!),
                                                                                                    fit: BoxFit.cover,
                                                                                                  )
                                                                                                : const DecorationImage(
                                                                                                    image: AssetImage('assets/images/profile_icon.png'),
                                                                                                    fit: BoxFit.cover,
                                                                                                  ),
                                                                                          ))
                                                                                      : Checkbox(
                                                                                          value: notificationIds.contains(ids),
                                                                                          onChanged: (value) {
                                                                                            setState(() {
                                                                                              if (value!) {
                                                                                                notificationIds.add(ids!);
                                                                                              } else {
                                                                                                notificationIds.remove(ids);
                                                                                              }
                                                                                            });
                                                                                          },
                                                                                          activeColor: const Color.fromRGBO(140, 198, 36, 1),
                                                                                          checkColor: Colors.white,
                                                                                          visualDensity: const VisualDensity(
                                                                                            horizontal: 0,
                                                                                            vertical: -2,
                                                                                          ),
                                                                                        ),
                                                                                  title: Row(
                                                                                    children: [
                                                                                      // Text(
                                                                                      //   firstWord,
                                                                                      //   style:
                                                                                      //       const TextStyle(
                                                                                      //     color: Color.fromRGBO(
                                                                                      //         35,
                                                                                      //         44,
                                                                                      //         58,
                                                                                      //         1),
                                                                                      //     fontSize:
                                                                                      //         14,
                                                                                      //     fontFamily:
                                                                                      //         'NeueHaasGroteskTextPro',
                                                                                      //     fontWeight:
                                                                                      //         FontWeight.bold,
                                                                                      //   ),
                                                                                      // ),
                                                                                      // const SizedBox(
                                                                                      //     width:
                                                                                      //         5),
                                                                                      Flexible(
                                                                                        // flex:
                                                                                        //     1,
                                                                                        child: TextScroll(
                                                                                          "$firstWord $remainingText",
                                                                                          velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                                                                          intervalSpaces: 10,
                                                                                          pauseBetween: const Duration(milliseconds: 5500),
                                                                                          mode: TextScrollMode.endless,
                                                                                          delayBefore: const Duration(milliseconds: 2000),
                                                                                          numberOfReps: 2,
                                                                                          style: const TextStyle(
                                                                                            color: Color.fromRGBO(35, 44, 58, 1),
                                                                                            fontSize: 14,
                                                                                            fontFamily: 'NeueHaasGroteskTextPro',
                                                                                            fontWeight: FontWeight.w400,
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  subtitle: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        timeAgo,
                                                                                        style: const TextStyle(
                                                                                          color: Color.fromRGBO(116, 116, 116, 1),
                                                                                          fontSize: 13,
                                                                                          fontFamily: 'NeueHaasGroteskTextPro',
                                                                                          fontWeight: FontWeight.w400,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  trailing: !item.isRead!
                                                                                      ? Container(
                                                                                          width: 10,
                                                                                          height: 10,
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Color.fromRGBO(0, 176, 80, 1), // Color of the dot
                                                                                            shape: BoxShape.circle,
                                                                                          ),
                                                                                        )
                                                                                      : null,
                                                                                ),
                                                                              ))
                                                                        ])
                                                                  ],
                                                                );
                                                              }
                                                            } else {
                                                              return const SizedBox();
                                                            }
                                                          },
                                                        )
                                                      : const Center(
                                                          child: Text(
                                                            'No Notifications Received Yet',
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      35,
                                                                      44,
                                                                      58,
                                                                      1),
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'NeueHaasGroteskTextPro',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child:
                                                  referEarnNotifications
                                                          .isNotEmpty
                                                      ? ListView.builder(
                                                          itemCount:
                                                              referEarnNotifications
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final item =
                                                                referEarnNotifications[
                                                                    index];
                                                            final List<String>
                                                                words = item
                                                                    .message!
                                                                    .split(' ');
                                                            final String
                                                                firstWord =
                                                                words.isNotEmpty
                                                                    ? words
                                                                        .first
                                                                    : '';
                                                            final String
                                                                remainingText =
                                                                words.length > 1
                                                                    ? words
                                                                        .sublist(
                                                                            1)
                                                                        .join(
                                                                            ' ')
                                                                    : '';

                                                            final String
                                                                timeAgo =
                                                                timeago.format(
                                                              DateTime.parse(item
                                                                      .createdOn!)
                                                                  .toLocal(),
                                                              locale:
                                                                  'en_short',
                                                            );

                                                            DateTime
                                                                createdDate =
                                                                DateTime.parse(item
                                                                    .createdOn!);

                                                            bool isToday = createdDate
                                                                        .year ==
                                                                    DateTime.now()
                                                                        .year &&
                                                                createdDate
                                                                        .month ==
                                                                    DateTime.now()
                                                                        .month &&
                                                                createdDate
                                                                        .day ==
                                                                    DateTime.now()
                                                                        .day;

                                                            bool isYesterday = createdDate
                                                                        .year ==
                                                                    DateTime.now()
                                                                        .year &&
                                                                createdDate
                                                                        .month ==
                                                                    DateTime.now()
                                                                        .month &&
                                                                createdDate
                                                                        .day ==
                                                                    DateTime.now()
                                                                        .subtract(const Duration(
                                                                            days:
                                                                                1))
                                                                        .day;
                                                            int? ids =
                                                                referEarnNotifications[
                                                                        index]
                                                                    .id;
                                                            widgetId =
                                                                referEarnNotifications[
                                                                        index]
                                                                    .widget!
                                                                    .id!;

                                                            if (item.widget!
                                                                    .id ==
                                                                12) {
                                                              if (isToday) {
                                                                return Column(
                                                                    children: [
                                                                      Container(
                                                                          color: item.isRead! == false
                                                                              ? const Color.fromRGBO(231, 255, 234, 1)
                                                                              : Colors.transparent,
                                                                          child: GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _notificationBloc.viewNotification(item.id.toString());
                                                                              item.widget!.id == 12 ? QR.navigator.replace(Routes.NOTIFICATION, Routes.REFER_EARN) : null;
                                                                            },
                                                                            child:
                                                                                ListTile(
                                                                              leading: isread == false
                                                                                  ? Container(
                                                                                      width: 50,
                                                                                      height: 50,
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        border: Border.all(
                                                                                          color: const Color.fromRGBO(112, 112, 112, 1),
                                                                                          width: 2.0,
                                                                                        ),
                                                                                        image: item.actionBy!.imagePath!.isNotEmpty || item.actionBy!.imagePath != null
                                                                                            ? DecorationImage(
                                                                                                image: NetworkImage(item.actionBy!.imagePath!),
                                                                                                fit: BoxFit.cover,
                                                                                              )
                                                                                            : const DecorationImage(
                                                                                                image: AssetImage('assets/images/profile_icon.png'),
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                      ))
                                                                                  : Checkbox(
                                                                                      value: notificationIds.contains(ids),
                                                                                      onChanged: (value) {
                                                                                        setState(() {
                                                                                          if (value!) {
                                                                                            notificationIds.add(ids!);
                                                                                          } else {
                                                                                            notificationIds.remove(ids);
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                      activeColor: const Color.fromRGBO(140, 198, 36, 1),
                                                                                      checkColor: Colors.white,
                                                                                      visualDensity: const VisualDensity(
                                                                                        horizontal: 0,
                                                                                        vertical: -2,
                                                                                      ),
                                                                                    ),
                                                                              title: Row(
                                                                                children: [
                                                                                  // Text(
                                                                                  //   firstWord,
                                                                                  //   style:
                                                                                  //       const TextStyle(
                                                                                  //     color: Color.fromRGBO(
                                                                                  //         35,
                                                                                  //         44,
                                                                                  //         58,
                                                                                  //         1),
                                                                                  //     fontSize:
                                                                                  //         14,
                                                                                  //     fontFamily:
                                                                                  //         'NeueHaasGroteskTextPro',
                                                                                  //     fontWeight:
                                                                                  //         FontWeight.bold,
                                                                                  //   ),
                                                                                  // ),
                                                                                  // const SizedBox(
                                                                                  //     width:
                                                                                  //         5),
                                                                                  Flexible(
                                                                                    // flex:
                                                                                    //     1,
                                                                                    child: TextScroll(
                                                                                      "$firstWord $remainingText",
                                                                                      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                                                                      intervalSpaces: 10,
                                                                                      pauseBetween: const Duration(milliseconds: 5500),
                                                                                      mode: TextScrollMode.endless,
                                                                                      delayBefore: const Duration(milliseconds: 2000),
                                                                                      numberOfReps: 2,
                                                                                      style: const TextStyle(
                                                                                        color: Color.fromRGBO(35, 44, 58, 1),
                                                                                        fontSize: 14,
                                                                                        fontFamily: 'NeueHaasGroteskTextPro',
                                                                                        fontWeight: FontWeight.w400,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              subtitle: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    timeAgo,
                                                                                    style: const TextStyle(
                                                                                      color: Color.fromRGBO(116, 116, 116, 1),
                                                                                      fontSize: 13,
                                                                                      fontFamily: 'NeueHaasGroteskTextPro',
                                                                                      fontWeight: FontWeight.w400,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              trailing: !item.isRead!
                                                                                  ? Container(
                                                                                      width: 10,
                                                                                      height: 10,
                                                                                      decoration: const BoxDecoration(
                                                                                        color: Color.fromRGBO(0, 176, 80, 1), // Color of the dot
                                                                                        shape: BoxShape.circle,
                                                                                      ),
                                                                                    )
                                                                                  : null,
                                                                            ),
                                                                          ))
                                                                    ]);
                                                              } else if (isYesterday) {
                                                                return Column(
                                                                    children: [
                                                                      Container(
                                                                          color: item.isRead! == false
                                                                              ? const Color.fromRGBO(231, 255, 234, 1)
                                                                              : Colors.transparent,
                                                                          child: GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _notificationBloc.viewNotification(item.id.toString());
                                                                              item.widget!.id == 12 ? QR.navigator.replace(Routes.NOTIFICATION, Routes.REFER_EARN) : null;
                                                                            },
                                                                            child:
                                                                                ListTile(
                                                                              leading: isread == false
                                                                                  ? Container(
                                                                                      width: 50,
                                                                                      height: 50,
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        border: Border.all(
                                                                                          color: const Color.fromRGBO(112, 112, 112, 1),
                                                                                          width: 2.0,
                                                                                        ),
                                                                                        image: item.actionBy!.imagePath!.isNotEmpty || item.actionBy!.imagePath != null
                                                                                            ? DecorationImage(
                                                                                                image: NetworkImage(item.actionBy!.imagePath!),
                                                                                                fit: BoxFit.cover,
                                                                                              )
                                                                                            : const DecorationImage(
                                                                                                image: AssetImage('assets/images/profile_icon.png'),
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                      ))
                                                                                  : Checkbox(
                                                                                      value: notificationIds.contains(ids),
                                                                                      onChanged: (value) {
                                                                                        setState(() {
                                                                                          if (value!) {
                                                                                            notificationIds.add(ids!);
                                                                                          } else {
                                                                                            notificationIds.remove(ids);
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                      activeColor: const Color.fromRGBO(140, 198, 36, 1),
                                                                                      checkColor: Colors.white,
                                                                                      visualDensity: const VisualDensity(
                                                                                        horizontal: 0,
                                                                                        vertical: -2,
                                                                                      ),
                                                                                    ),
                                                                              title: Row(
                                                                                children: [
                                                                                  // Text(
                                                                                  //   firstWord,
                                                                                  //   style:
                                                                                  //       const TextStyle(
                                                                                  //     color: Color.fromRGBO(
                                                                                  //         35,
                                                                                  //         44,
                                                                                  //         58,
                                                                                  //         1),
                                                                                  //     fontSize:
                                                                                  //         14,
                                                                                  //     fontFamily:
                                                                                  //         'NeueHaasGroteskTextPro',
                                                                                  //     fontWeight:
                                                                                  //         FontWeight.bold,
                                                                                  //   ),
                                                                                  // ),
                                                                                  // const SizedBox(
                                                                                  //     width:
                                                                                  //         5),
                                                                                  Flexible(
                                                                                    // flex:
                                                                                    //     1,
                                                                                    child: TextScroll(
                                                                                      "$firstWord $remainingText",
                                                                                      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                                                                      intervalSpaces: 10,
                                                                                      pauseBetween: const Duration(milliseconds: 5500),
                                                                                      mode: TextScrollMode.endless,
                                                                                      delayBefore: const Duration(milliseconds: 2000),
                                                                                      numberOfReps: 2,
                                                                                      style: const TextStyle(
                                                                                        color: Color.fromRGBO(35, 44, 58, 1),
                                                                                        fontSize: 14,
                                                                                        fontFamily: 'NeueHaasGroteskTextPro',
                                                                                        fontWeight: FontWeight.w400,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              subtitle: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    timeAgo,
                                                                                    style: const TextStyle(
                                                                                      color: Color.fromRGBO(116, 116, 116, 1),
                                                                                      fontSize: 13,
                                                                                      fontFamily: 'NeueHaasGroteskTextPro',
                                                                                      fontWeight: FontWeight.w400,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              trailing: !item.isRead!
                                                                                  ? Container(
                                                                                      width: 10,
                                                                                      height: 10,
                                                                                      decoration: const BoxDecoration(
                                                                                        color: Color.fromRGBO(0, 176, 80, 1), // Color of the dot
                                                                                        shape: BoxShape.circle,
                                                                                      ),
                                                                                    )
                                                                                  : null,
                                                                            ),
                                                                          ))
                                                                    ]);
                                                              } else {
                                                                // Display the notification with the date
                                                                return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // ListTile for the date
                                                                    ListTile(
                                                                      title:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Text(
                                                                          DateFormat('MMMM d, yyyy')
                                                                              .format(createdDate),
                                                                          style:
                                                                              const TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                170,
                                                                                170,
                                                                                170,
                                                                                1),
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'NeueHaasGroteskTextPro',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // ListTile for the notification
                                                                    Column(
                                                                        children: [
                                                                          Container(
                                                                              color: item.isRead! == false ? const Color.fromRGBO(231, 255, 234, 1) : Colors.transparent,
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  _notificationBloc.viewNotification(item.id.toString());
                                                                                  item.widget!.id == 12 ? QR.navigator.replace(Routes.NOTIFICATION, Routes.REFER_EARN) : null;
                                                                                },
                                                                                child: ListTile(
                                                                                  leading: isread == false
                                                                                      ? Container(
                                                                                          width: 50,
                                                                                          height: 50,
                                                                                          decoration: BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            border: Border.all(
                                                                                              color: const Color.fromRGBO(112, 112, 112, 1),
                                                                                              width: 2.0,
                                                                                            ),
                                                                                            image: item.actionBy!.imagePath!.isNotEmpty || item.actionBy!.imagePath != null
                                                                                                ? DecorationImage(
                                                                                                    image: NetworkImage(item.actionBy!.imagePath!),
                                                                                                    fit: BoxFit.cover,
                                                                                                  )
                                                                                                : const DecorationImage(
                                                                                                    image: AssetImage('assets/images/profile_icon.png'),
                                                                                                    fit: BoxFit.cover,
                                                                                                  ),
                                                                                          ))
                                                                                      : Checkbox(
                                                                                          value: notificationIds.contains(ids),
                                                                                          onChanged: (value) {
                                                                                            setState(() {
                                                                                              if (value!) {
                                                                                                notificationIds.add(ids!);
                                                                                              } else {
                                                                                                notificationIds.remove(ids);
                                                                                              }
                                                                                            });
                                                                                          },
                                                                                          activeColor: const Color.fromRGBO(140, 198, 36, 1),
                                                                                          checkColor: Colors.white,
                                                                                          visualDensity: const VisualDensity(
                                                                                            horizontal: 0,
                                                                                            vertical: -2,
                                                                                          ),
                                                                                        ),
                                                                                  title: Row(
                                                                                    children: [
                                                                                      // Text(
                                                                                      //   firstWord,
                                                                                      //   style:
                                                                                      //       const TextStyle(
                                                                                      //     color: Color.fromRGBO(
                                                                                      //         35,
                                                                                      //         44,
                                                                                      //         58,
                                                                                      //         1),
                                                                                      //     fontSize:
                                                                                      //         14,
                                                                                      //     fontFamily:
                                                                                      //         'NeueHaasGroteskTextPro',
                                                                                      //     fontWeight:
                                                                                      //         FontWeight.bold,
                                                                                      //   ),
                                                                                      // ),
                                                                                      // const SizedBox(
                                                                                      //     width:
                                                                                      //         5),
                                                                                      Flexible(
                                                                                        // flex:
                                                                                        //     1,
                                                                                        child: TextScroll(
                                                                                          "$firstWord $remainingText",
                                                                                          velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                                                                          intervalSpaces: 10,
                                                                                          pauseBetween: const Duration(milliseconds: 5500),
                                                                                          mode: TextScrollMode.endless,
                                                                                          delayBefore: const Duration(milliseconds: 2000),
                                                                                          numberOfReps: 2,
                                                                                          style: const TextStyle(
                                                                                            color: Color.fromRGBO(35, 44, 58, 1),
                                                                                            fontSize: 14,
                                                                                            fontFamily: 'NeueHaasGroteskTextPro',
                                                                                            fontWeight: FontWeight.w400,
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  subtitle: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        timeAgo,
                                                                                        style: const TextStyle(
                                                                                          color: Color.fromRGBO(116, 116, 116, 1),
                                                                                          fontSize: 13,
                                                                                          fontFamily: 'NeueHaasGroteskTextPro',
                                                                                          fontWeight: FontWeight.w400,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  trailing: !item.isRead!
                                                                                      ? Container(
                                                                                          width: 10,
                                                                                          height: 10,
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Color.fromRGBO(0, 176, 80, 1), // Color of the dot
                                                                                            shape: BoxShape.circle,
                                                                                          ),
                                                                                        )
                                                                                      : null,
                                                                                ),
                                                                              ))
                                                                        ])
                                                                  ],
                                                                );
                                                              }
                                                            } else {
                                                              return const SizedBox(); //
                                                            }
                                                          },
                                                        )
                                                      : const Center(
                                                          child: Text(
                                                            'No Notifications Received Yet',
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      35,
                                                                      44,
                                                                      58,
                                                                      1),
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'NeueHaasGroteskTextPro',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child:
                                                  broadcastNotifications
                                                          .isNotEmpty
                                                      ? ListView.builder(
                                                          itemCount:
                                                              broadcastNotifications
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final item =
                                                                broadcastNotifications[
                                                                    index];
                                                            final List<String>
                                                                words = item
                                                                    .message!
                                                                    .split(' ');
                                                            final String
                                                                firstWord =
                                                                words.isNotEmpty
                                                                    ? words
                                                                        .first
                                                                    : '';
                                                            final String
                                                                remainingText =
                                                                words.length > 1
                                                                    ? words
                                                                        .sublist(
                                                                            1)
                                                                        .join(
                                                                            ' ')
                                                                    : '';

                                                            final String
                                                                timeAgo =
                                                                timeago.format(
                                                              DateTime.parse(item
                                                                      .createdOn!)
                                                                  .toLocal(),
                                                              locale:
                                                                  'en_short',
                                                            );

                                                            DateTime
                                                                createdDate =
                                                                DateTime.parse(item
                                                                    .createdOn!);

                                                            bool isToday = createdDate
                                                                        .year ==
                                                                    DateTime.now()
                                                                        .year &&
                                                                createdDate
                                                                        .month ==
                                                                    DateTime.now()
                                                                        .month &&
                                                                createdDate
                                                                        .day ==
                                                                    DateTime.now()
                                                                        .day;

                                                            bool isYesterday = createdDate
                                                                        .year ==
                                                                    DateTime.now()
                                                                        .year &&
                                                                createdDate
                                                                        .month ==
                                                                    DateTime.now()
                                                                        .month &&
                                                                createdDate
                                                                        .day ==
                                                                    DateTime.now()
                                                                        .subtract(const Duration(
                                                                            days:
                                                                                1))
                                                                        .day;
                                                            int? ids =
                                                                broadcastNotifications[
                                                                        index]
                                                                    .id;
                                                            widgetId =
                                                                broadcastNotifications[
                                                                        index]
                                                                    .widget!
                                                                    .id!;

                                                            if (item.widget!
                                                                    .id ==
                                                                4) {
                                                              if (isToday) {
                                                                return Column(
                                                                    children: [
                                                                      Container(
                                                                          color: item.isRead! == false
                                                                              ? const Color.fromRGBO(231, 255, 234, 1)
                                                                              : Colors.transparent,
                                                                          child: GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _notificationBloc.viewNotification(item.id.toString());
                                                                              item.widget!.id == 4 && broadcastNotifications[index].actionType != 'Share'
                                                                                  ? QR.navigator.replace(Routes.NOTIFICATION, Routes.BROADCAST)
                                                                                  : broadcastNotifications[index].actionType == 'Share'
                                                                                      ? QR.navigator.replace(Routes.NOTIFICATION, Routes.REWARDS)
                                                                                      : null;
                                                                            },
                                                                            child:
                                                                                ListTile(
                                                                              leading: isread == false
                                                                                  ? Container(
                                                                                      width: 50,
                                                                                      height: 50,
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        border: Border.all(
                                                                                          color: const Color.fromRGBO(112, 112, 112, 1),
                                                                                          width: 2.0,
                                                                                        ),
                                                                                        image: item.actionBy!.imagePath!.isNotEmpty || item.actionBy!.imagePath != null
                                                                                            ? DecorationImage(
                                                                                                image: NetworkImage(item.actionBy!.imagePath!),
                                                                                                fit: BoxFit.cover,
                                                                                              )
                                                                                            : const DecorationImage(
                                                                                                image: AssetImage('assets/images/profile_icon.png'),
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                      ))
                                                                                  : Checkbox(
                                                                                      value: notificationIds.contains(ids),
                                                                                      onChanged: (value) {
                                                                                        setState(() {
                                                                                          if (value!) {
                                                                                            notificationIds.add(ids!);
                                                                                          } else {
                                                                                            notificationIds.remove(ids);
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                      activeColor: const Color.fromRGBO(140, 198, 36, 1),
                                                                                      checkColor: Colors.white,
                                                                                      visualDensity: const VisualDensity(
                                                                                        horizontal: 0,
                                                                                        vertical: -2,
                                                                                      ),
                                                                                    ),
                                                                              title: Row(
                                                                                children: [
                                                                                  // Text(
                                                                                  //   firstWord,
                                                                                  //   style:
                                                                                  //       const TextStyle(
                                                                                  //     color: Color.fromRGBO(
                                                                                  //         35,
                                                                                  //         44,
                                                                                  //         58,
                                                                                  //         1),
                                                                                  //     fontSize:
                                                                                  //         14,
                                                                                  //     fontFamily:
                                                                                  //         'NeueHaasGroteskTextPro',
                                                                                  //     fontWeight:
                                                                                  //         FontWeight.bold,
                                                                                  //   ),
                                                                                  // ),
                                                                                  // const SizedBox(
                                                                                  //     width:
                                                                                  //         5),
                                                                                  Flexible(
                                                                                    // flex:
                                                                                    //     1,
                                                                                    child: TextScroll(
                                                                                      "$firstWord $remainingText",
                                                                                      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                                                                      intervalSpaces: 10,
                                                                                      pauseBetween: const Duration(milliseconds: 5500),
                                                                                      mode: TextScrollMode.endless,
                                                                                      delayBefore: const Duration(milliseconds: 2000),
                                                                                      numberOfReps: 2,
                                                                                      style: const TextStyle(
                                                                                        color: Color.fromRGBO(35, 44, 58, 1),
                                                                                        fontSize: 14,
                                                                                        fontFamily: 'NeueHaasGroteskTextPro',
                                                                                        fontWeight: FontWeight.w400,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              subtitle: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    timeAgo,
                                                                                    style: const TextStyle(
                                                                                      color: Color.fromRGBO(116, 116, 116, 1),
                                                                                      fontSize: 13,
                                                                                      fontFamily: 'NeueHaasGroteskTextPro',
                                                                                      fontWeight: FontWeight.w400,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              trailing: !item.isRead!
                                                                                  ? Container(
                                                                                      width: 10,
                                                                                      height: 10,
                                                                                      decoration: const BoxDecoration(
                                                                                        color: Color.fromRGBO(0, 176, 80, 1), // Color of the dot
                                                                                        shape: BoxShape.circle,
                                                                                      ),
                                                                                    )
                                                                                  : null,
                                                                            ),
                                                                          ))
                                                                    ]);
                                                              } else if (isYesterday) {
                                                                return Column(
                                                                    children: [
                                                                      Container(
                                                                          color: item.isRead! == false
                                                                              ? const Color.fromRGBO(231, 255, 234, 1)
                                                                              : Colors.transparent,
                                                                          child: GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _notificationBloc.viewNotification(item.id.toString());

                                                                              item.widget!.id == 4 && broadcastNotifications[index].actionType != 'Share'
                                                                                  ? QR.navigator.replace(Routes.NOTIFICATION, Routes.BROADCAST)
                                                                                  : broadcastNotifications[index].actionType == 'Share'
                                                                                      ? QR.navigator.replace(Routes.NOTIFICATION, Routes.REWARDS)
                                                                                      : null;
                                                                            },
                                                                            child:
                                                                                ListTile(
                                                                              leading: isread == false
                                                                                  ? Container(
                                                                                      width: 50,
                                                                                      height: 50,
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        border: Border.all(
                                                                                          color: const Color.fromRGBO(112, 112, 112, 1),
                                                                                          width: 2.0,
                                                                                        ),
                                                                                        image: item.actionBy!.imagePath!.isNotEmpty || item.actionBy!.imagePath != null
                                                                                            ? DecorationImage(
                                                                                                image: NetworkImage(item.actionBy!.imagePath!),
                                                                                                fit: BoxFit.cover,
                                                                                              )
                                                                                            : const DecorationImage(
                                                                                                image: AssetImage('assets/images/profile_icon.png'),
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                      ))
                                                                                  : Checkbox(
                                                                                      value: notificationIds.contains(ids),
                                                                                      onChanged: (value) {
                                                                                        setState(() {
                                                                                          if (value!) {
                                                                                            notificationIds.add(ids!);
                                                                                          } else {
                                                                                            notificationIds.remove(ids);
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                      activeColor: const Color.fromRGBO(140, 198, 36, 1),
                                                                                      checkColor: Colors.white,
                                                                                      visualDensity: const VisualDensity(
                                                                                        horizontal: 0,
                                                                                        vertical: -2,
                                                                                      ),
                                                                                    ),
                                                                              title: Row(
                                                                                children: [
                                                                                  // Text(
                                                                                  //   firstWord,
                                                                                  //   style:
                                                                                  //       const TextStyle(
                                                                                  //     color: Color.fromRGBO(
                                                                                  //         35,
                                                                                  //         44,
                                                                                  //         58,
                                                                                  //         1),
                                                                                  //     fontSize:
                                                                                  //         14,
                                                                                  //     fontFamily:
                                                                                  //         'NeueHaasGroteskTextPro',
                                                                                  //     fontWeight:
                                                                                  //         FontWeight.bold,
                                                                                  //   ),
                                                                                  // ),
                                                                                  // const SizedBox(
                                                                                  //     width:
                                                                                  //         5),
                                                                                  Flexible(
                                                                                    // flex:
                                                                                    //     1,
                                                                                    child: TextScroll(
                                                                                      "$firstWord $remainingText",
                                                                                      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                                                                      intervalSpaces: 10,
                                                                                      pauseBetween: const Duration(milliseconds: 5500),
                                                                                      mode: TextScrollMode.endless,
                                                                                      delayBefore: const Duration(milliseconds: 2000),
                                                                                      numberOfReps: 2,
                                                                                      style: const TextStyle(
                                                                                        color: Color.fromRGBO(35, 44, 58, 1),
                                                                                        fontSize: 14,
                                                                                        fontFamily: 'NeueHaasGroteskTextPro',
                                                                                        fontWeight: FontWeight.w400,
                                                                                      ),
                                                                                    ),

                                                                                    //     Text(
                                                                                    //   remainingText,
                                                                                    //   overflow:
                                                                                    //       TextOverflow.ellipsis,
                                                                                    //   maxLines:
                                                                                    //       1,
                                                                                    //   style:
                                                                                    //       const TextStyle(
                                                                                    //     color: Color.fromRGBO(35, 44, 58, 1),
                                                                                    //     fontSize: 14,
                                                                                    //     fontFamily: 'NeueHaasGroteskTextPro',
                                                                                    //     fontWeight: FontWeight.w400,
                                                                                    //   ),
                                                                                    // ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              subtitle: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    timeAgo,
                                                                                    style: const TextStyle(
                                                                                      color: Color.fromRGBO(116, 116, 116, 1),
                                                                                      fontSize: 13,
                                                                                      fontFamily: 'NeueHaasGroteskTextPro',
                                                                                      fontWeight: FontWeight.w400,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              trailing: !item.isRead!
                                                                                  ? Container(
                                                                                      width: 10,
                                                                                      height: 10,
                                                                                      decoration: const BoxDecoration(
                                                                                        color: Color.fromRGBO(0, 176, 80, 1), // Color of the dot
                                                                                        shape: BoxShape.circle,
                                                                                      ),
                                                                                    )
                                                                                  : null,
                                                                            ),
                                                                          ))
                                                                    ]);
                                                              } else {
                                                                // Display the notification with the date
                                                                return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // ListTile for the date
                                                                    ListTile(
                                                                      title:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Text(
                                                                          DateFormat('MMMM d, yyyy')
                                                                              .format(createdDate),
                                                                          style:
                                                                              const TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                170,
                                                                                170,
                                                                                170,
                                                                                1),
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'NeueHaasGroteskTextPro',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // ListTile for the notification
                                                                    Column(
                                                                        children: [
                                                                          Container(
                                                                              color: item.isRead! == false ? const Color.fromRGBO(231, 255, 234, 1) : Colors.transparent,
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  _notificationBloc.viewNotification(item.id.toString());
                                                                                  item.widget!.id == 4 && broadcastNotifications[index].actionType != 'Share'
                                                                                      ? QR.navigator.replace(Routes.NOTIFICATION, Routes.BROADCAST)
                                                                                      : broadcastNotifications[index].actionType == 'Share'
                                                                                          ? QR.navigator.replace(Routes.NOTIFICATION, Routes.REWARDS)
                                                                                          : null;
                                                                                },
                                                                                child: ListTile(
                                                                                  leading: isread == false
                                                                                      ? Container(
                                                                                          width: 50,
                                                                                          height: 50,
                                                                                          decoration: BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            border: Border.all(
                                                                                              color: const Color.fromRGBO(112, 112, 112, 1),
                                                                                              width: 2.0,
                                                                                            ),
                                                                                            image: item.actionBy!.imagePath!.isNotEmpty || item.actionBy!.imagePath != null
                                                                                                ? DecorationImage(
                                                                                                    image: NetworkImage(item.actionBy!.imagePath!),
                                                                                                    fit: BoxFit.cover,
                                                                                                  )
                                                                                                : const DecorationImage(
                                                                                                    image: AssetImage('assets/images/profile_icon.png'),
                                                                                                    fit: BoxFit.cover,
                                                                                                  ),
                                                                                          ))
                                                                                      : Checkbox(
                                                                                          value: notificationIds.contains(ids),
                                                                                          onChanged: (value) {
                                                                                            setState(() {
                                                                                              if (value!) {
                                                                                                notificationIds.add(ids!);
                                                                                              } else {
                                                                                                notificationIds.remove(ids);
                                                                                              }
                                                                                            });
                                                                                          },
                                                                                          activeColor: const Color.fromRGBO(140, 198, 36, 1),
                                                                                          checkColor: Colors.white,
                                                                                          visualDensity: const VisualDensity(
                                                                                            horizontal: 0,
                                                                                            vertical: -2,
                                                                                          ),
                                                                                        ),
                                                                                  title: Row(
                                                                                    children: [
                                                                                      // Text(
                                                                                      //   firstWord,
                                                                                      //   style:
                                                                                      //       const TextStyle(
                                                                                      //     color: Color.fromRGBO(
                                                                                      //         35,
                                                                                      //         44,
                                                                                      //         58,
                                                                                      //         1),
                                                                                      //     fontSize:
                                                                                      //         14,
                                                                                      //     fontFamily:
                                                                                      //         'NeueHaasGroteskTextPro',
                                                                                      //     fontWeight:
                                                                                      //         FontWeight.bold,
                                                                                      //   ),
                                                                                      // ),
                                                                                      // const SizedBox(
                                                                                      //     width:
                                                                                      //         5),
                                                                                      Flexible(
                                                                                        // flex:
                                                                                        //     1,
                                                                                        child: TextScroll(
                                                                                          "$firstWord $remainingText",
                                                                                          velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                                                                          intervalSpaces: 10,
                                                                                          pauseBetween: const Duration(milliseconds: 5500),
                                                                                          mode: TextScrollMode.endless,
                                                                                          delayBefore: const Duration(milliseconds: 2000),
                                                                                          numberOfReps: 2,
                                                                                          style: const TextStyle(
                                                                                            color: Color.fromRGBO(35, 44, 58, 1),
                                                                                            fontSize: 14,
                                                                                            fontFamily: 'NeueHaasGroteskTextPro',
                                                                                            fontWeight: FontWeight.w400,
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                      //     Text(
                                                                                      //   remainingText,
                                                                                      //   overflow:
                                                                                      //       TextOverflow.ellipsis,
                                                                                      //   maxLines:
                                                                                      //       1,
                                                                                      //   style:
                                                                                      //       const TextStyle(
                                                                                      //     color: Color.fromRGBO(35, 44, 58, 1),
                                                                                      //     fontSize: 14,
                                                                                      //     fontFamily: 'NeueHaasGroteskTextPro',
                                                                                      //     fontWeight: FontWeight.w400,
                                                                                      //   ),
                                                                                      // ),
                                                                                      // ),
                                                                                    ],
                                                                                  ),
                                                                                  subtitle: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        timeAgo,
                                                                                        style: const TextStyle(
                                                                                          color: Color.fromRGBO(116, 116, 116, 1),
                                                                                          fontSize: 13,
                                                                                          fontFamily: 'NeueHaasGroteskTextPro',
                                                                                          fontWeight: FontWeight.w400,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  trailing: !item.isRead!
                                                                                      ? Container(
                                                                                          width: 10,
                                                                                          height: 10,
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Color.fromRGBO(0, 176, 80, 1), // Color of the dot
                                                                                            shape: BoxShape.circle,
                                                                                          ),
                                                                                        )
                                                                                      : null,
                                                                                ),
                                                                              ))
                                                                        ])
                                                                  ],
                                                                );
                                                              }
                                                            } else {
                                                              return const SizedBox();
                                                            }
                                                          },
                                                        )
                                                      : const Center(
                                                          child: Text(
                                                            'No Notifications Received  Yet',
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      35,
                                                                      44,
                                                                      58,
                                                                      1),
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'NeueHaasGroteskTextPro',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ),
                          ]),
                        )),
                  )
                ],
              ),
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
}
