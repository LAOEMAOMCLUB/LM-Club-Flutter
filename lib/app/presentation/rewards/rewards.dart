// rewardsPage here we can see earned point for (Beehive,BroadCast and refer & earn).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/presentation/dashboard/dashboard.dart';
import 'package:lm_club/app/presentation/rewards/bloc/rewards_bloc.dart';
import 'package:lm_club/app/presentation/rewards/bloc/rewards_state.dart';
import 'package:lm_club/utils/globals.dart' as globals;
import 'package:intl/intl.dart';

class Rewards extends StatefulWidget {
  const Rewards({Key? key}) : super(key: key);

  @override
  State<Rewards> createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  final RewardsBloc _rewardsBloc = getIt.get<RewardsBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _rewardsBloc..getUserPoints(),
        child: BlocConsumer<RewardsBloc, RewardsState>(
            listener: (context, state) {},
            builder: (context, state) {
              String beehiveSumData = state.pointsData?.beehiveSum ?? '';
              double? beehiveSum;

              if (beehiveSumData.contains(".")) {
                beehiveSum = double.tryParse(beehiveSumData.trim());
              } else {
                beehiveSum = int.tryParse(beehiveSumData.trim())?.toDouble();
              }

              beehiveSum ??= 0.0;

              String broadcastSumData = state.pointsData?.broadcastSum ?? '';
              double? broadcastSum;

              if (broadcastSumData.contains(".")) {
                broadcastSum = double.tryParse(broadcastSumData.trim());
              } else {
                broadcastSum =
                    int.tryParse(broadcastSumData.trim())?.toDouble();
              }

              broadcastSum ??= 0.0;

              int referalSum = state.pointsData?.referalSum ?? 0;
              double totalSum = beehiveSum + referalSum + broadcastSum;
              return Scaffold(
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
                          color: Color.fromRGBO(208, 231, 250, 1),
                          blurRadius: 25.0,
                          spreadRadius: 25.0,
                        ),
                      ],
                    ),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Dashboard(),
                            ),
                          );
                        },
                      ),
                      title: const Text(
                        'Rewards',
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
                body: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(208, 231, 250, 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/images/coin.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 3.5,
                                    ),
                                    Text(
                                      totalSum.toString(),
                                      style: const TextStyle(
                                        color: Color.fromRGBO(55, 74, 156, 1),
                                        fontSize: 28,
                                        fontFamily: 'NeueHaasGroteskTextPro',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  "Total Reward Points",
                                  style: TextStyle(
                                    color: Color.fromRGBO(55, 74, 156, 1),
                                    fontSize: 12,
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            "assets/images/rewards_bg.png",
                            height: 84,
                          )
                        ],
                      ),
                    ),
                    globals.role == '4'
                        ? Expanded(
                            child: DefaultTabController(
                                length: 1,
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Column(children: [
                                    const TabBar(
                                      tabs: [
                                        Tab(
                                            child: Text(
                                          "Broadcast",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(55, 74, 156, 1),
                                            fontSize: 10,
                                            fontFamily:
                                                'NeueHaasGroteskTextPro',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )),
                                      ],
                                      indicator: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color:
                                                Color.fromRGBO(55, 74, 156, 1),
                                            width: 3.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center, // Center vertically
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center, // Center horizontal
                                              children: [
                                                Expanded(
                                                    child: Center(
                                                  child:
                                                      state.broadcastPoints!
                                                              .isEmpty
                                                          ? const Center(
                                                              child: Text(
                                                                  'Data Not Found'), // Display message if list is empty
                                                            )
                                                          : ListView.builder(
                                                              itemCount: state
                                                                  .broadcastPoints!
                                                                  .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                String dateString = state
                                                                    .broadcastPoints![
                                                                        index]
                                                                    .transactionDate!;
                                                                DateTime date =
                                                                    DateTime.parse(
                                                                        dateString);

                                                                String
                                                                    formattedDate =
                                                                    DateFormat(
                                                                            'dd MMM')
                                                                        .format(
                                                                            date);

                                                                double points =
                                                                    double.parse(state
                                                                        .broadcastPoints![
                                                                            index]
                                                                        .points!);
                                                                int formattedPoints =
                                                                    points
                                                                        .toInt();
                                                                return Container(
                                                                  width: double
                                                                      .infinity,
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          5),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          12.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color
                                                                        .fromRGBO(
                                                                        240,
                                                                        240,
                                                                        240,
                                                                        1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                          padding: const EdgeInsets
                                                                              .fromLTRB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Image.asset(
                                                                                "assets/images/coin.png",
                                                                                width: 20,
                                                                                height: 20,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    formattedPoints.toString(),
                                                                                    style: const TextStyle(
                                                                                      color: Color.fromRGBO(35, 44, 58, 1),
                                                                                      fontSize: 16.0,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontFamily: 'NeueHaasGroteskTextPro',
                                                                                    ),
                                                                                    textAlign: TextAlign.left,
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 2,
                                                                                  ),
                                                                                  state.broadcastPoints![index].broadcastPostTracking!.isCreated == true || state.broadcastPoints![index].broadcastPostTracking!.isShared == true
                                                                                      ? Text(
                                                                                          state.broadcastPoints![index].message!,
                                                                                          style: const TextStyle(
                                                                                            color: Color.fromRGBO(113, 113, 113, 1),
                                                                                            fontSize: 8,
                                                                                            fontFamily: 'NeueHaasGroteskTextPro',
                                                                                          ),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          maxLines: 1,
                                                                                        )
                                                                                      : const SizedBox()
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          )),
                                                                      Text(
                                                                        formattedDate,
                                                                        style:
                                                                            const TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              113,
                                                                              113,
                                                                              113,
                                                                              1),
                                                                          fontSize:
                                                                              8,
                                                                          fontFamily:
                                                                              'NeueHaasGroteskTextPro',
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                                )),
                          )
                        : Expanded(
                            child: DefaultTabController(
                                length: 3,
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Column(children: [
                                    const TabBar(
                                      tabs: [
                                        Tab(
                                            child: Text(
                                          "Beehive",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(55, 74, 156, 1),
                                            fontSize: 10,
                                            fontFamily:
                                                'NeueHaasGroteskTextPro',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )),
                                        Tab(
                                            child: Text(
                                          "Refer & Earn",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(55, 74, 156, 1),
                                            fontSize: 10,
                                            fontFamily:
                                                'NeueHaasGroteskTextPro',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )),
                                        Tab(
                                            child: Text(
                                          "Broadcast",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(55, 74, 156, 1),
                                            fontSize: 10,
                                            fontFamily:
                                                'NeueHaasGroteskTextPro',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )),
                                      ],
                                      indicator: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color:
                                                Color.fromRGBO(55, 74, 156, 1),
                                            width: 3.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center, // Center vertically
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center, // Center horizontal
                                              children: [
                                                Expanded(
                                                    child: Center(
                                                  child: state.beehivePoints!
                                                          .isEmpty
                                                      ? const Center(
                                                          child: Text(
                                                              'Data Not Found'), // Display message if list is empty
                                                        )
                                                      : ListView.builder(
                                                          itemCount: state
                                                              .beehivePoints!
                                                              .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            String dateString = state
                                                                .beehivePoints![
                                                                    index]
                                                                .transactionDate!;
                                                            DateTime date =
                                                                DateTime.parse(
                                                                    dateString);

                                                            String
                                                                formattedDate =
                                                                DateFormat(
                                                                        'dd MMM')
                                                                    .format(
                                                                        date);

                                                            return Container(
                                                              width: double
                                                                  .infinity,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          5),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      12.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    240,
                                                                    240,
                                                                    240,
                                                                    1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Image
                                                                              .asset(
                                                                            "assets/images/coin.png",
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                state.beehivePoints![index].points.toString(),
                                                                                style: const TextStyle(
                                                                                  color: Color.fromRGBO(35, 44, 58, 1),
                                                                                  fontSize: 16.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontFamily: 'NeueHaasGroteskTextPro',
                                                                                ),
                                                                                textAlign: TextAlign.left,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              state.beehivePoints![index].beehivePostTracking!.isCreated == true || state.beehivePoints![index].beehivePostTracking!.isLiked == true
                                                                                  ? Text(
                                                                                      state.beehivePoints![index].message!,
                                                                                      style: const TextStyle(
                                                                                        color: Color.fromRGBO(113, 113, 113, 1),
                                                                                        fontSize: 8,
                                                                                        fontFamily: 'NeueHaasGroteskTextPro',
                                                                                      ),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      maxLines: 1,
                                                                                    )
                                                                                  : const SizedBox()
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      )),
                                                                  Text(
                                                                    formattedDate,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color.fromRGBO(
                                                                          113,
                                                                          113,
                                                                          113,
                                                                          1),
                                                                      fontSize:
                                                                          8,
                                                                      fontFamily:
                                                                          'NeueHaasGroteskTextPro',
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ), // Display message if list is empty
                                                ))
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center, // Center vertically
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center, // Center horizontal
                                              children: [
                                                Expanded(
                                                    child: Center(
                                                  child: state
                                                          .userPoints!.isEmpty
                                                      ? const Center(
                                                          child: Text(
                                                              'Data Not Found'), // Display message if list is empty
                                                        )
                                                      : ListView.builder(
                                                          itemCount: state
                                                              .userPoints!
                                                              .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            String dateString = state
                                                                .userPoints![
                                                                    index]
                                                                .transactionDate!;
                                                            DateTime date =
                                                                DateTime.parse(
                                                                    dateString);

                                                            String
                                                                formattedDate =
                                                                DateFormat(
                                                                        'dd MMM')
                                                                    .format(
                                                                        date);

                                                            double points =
                                                                double.parse(state
                                                                    .userPoints![
                                                                        index]
                                                                    .points!);
                                                            int formattedPoints =
                                                                points.toInt();
                                                            return Container(
                                                              width: double
                                                                  .infinity,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          5),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      12.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    240,
                                                                    240,
                                                                    240,
                                                                    1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Image
                                                                              .asset(
                                                                            "assets/images/coin.png",
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                formattedPoints.toString(),
                                                                                style: const TextStyle(
                                                                                  color: Color.fromRGBO(35, 44, 58, 1),
                                                                                  fontSize: 16.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontFamily: 'NeueHaasGroteskTextPro',
                                                                                ),
                                                                                textAlign: TextAlign.left,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              state.userPoints![index].userReferral!.userData!.id!.toString() == globals.userId
                                                                                  ? const Text(
                                                                                      'Received points for Successful Referral',
                                                                                      style: TextStyle(
                                                                                        color: Color.fromRGBO(113, 113, 113, 1),
                                                                                        fontSize: 8,
                                                                                        fontFamily: 'NeueHaasGroteskTextPro',
                                                                                      ),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      maxLines: 1,
                                                                                    )
                                                                                  : const Text(
                                                                                      'Received points for Joining via Referral',
                                                                                      style: TextStyle(
                                                                                        color: Color.fromRGBO(113, 113, 113, 1),
                                                                                        fontSize: 8,
                                                                                        fontFamily: 'NeueHaasGroteskTextPro',
                                                                                      ),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      maxLines: 1,
                                                                                    ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      )),
                                                                  Text(
                                                                    formattedDate,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color.fromRGBO(
                                                                          113,
                                                                          113,
                                                                          113,
                                                                          1),
                                                                      fontSize:
                                                                          8,
                                                                      fontFamily:
                                                                          'NeueHaasGroteskTextPro',
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ), // Display message if list is empty
                                                ))
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center, // Center vertically
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center, // Center horizontal
                                              children: [
                                                Expanded(
                                                    child: Center(
                                                  child: state.broadcastPoints!
                                                          .isEmpty
                                                      ? const Center(
                                                          child: Text(
                                                              'Data Not Found'), // Display message if list is empty
                                                        )
                                                      : ListView.builder(
                                                          itemCount: state
                                                              .broadcastPoints!
                                                              .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            String dateString = state
                                                                .broadcastPoints![
                                                                    index]
                                                                .transactionDate!;
                                                            DateTime date =
                                                                DateTime.parse(
                                                                    dateString);

                                                            String
                                                                formattedDate =
                                                                DateFormat(
                                                                        'dd MMM')
                                                                    .format(
                                                                        date);

                                                            double points =
                                                                double.parse(state
                                                                    .broadcastPoints![
                                                                        index]
                                                                    .points!);
                                                            int formattedPoints =
                                                                points.toInt();
                                                            return Container(
                                                              width: double
                                                                  .infinity,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          5),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      12.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    240,
                                                                    240,
                                                                    240,
                                                                    1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Image
                                                                              .asset(
                                                                            "assets/images/coin.png",
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                formattedPoints.toString(),
                                                                                style: const TextStyle(
                                                                                  color: Color.fromRGBO(35, 44, 58, 1),
                                                                                  fontSize: 16.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontFamily: 'NeueHaasGroteskTextPro',
                                                                                ),
                                                                                textAlign: TextAlign.left,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              state.broadcastPoints![index].broadcastPostTracking!.isCreated == true || state.broadcastPoints![index].broadcastPostTracking!.isShared == true
                                                                                  ? Text(
                                                                                      state.broadcastPoints![index].message!,
                                                                                      style: const TextStyle(
                                                                                        color: Color.fromRGBO(113, 113, 113, 1),
                                                                                        fontSize: 8,
                                                                                        fontFamily: 'NeueHaasGroteskTextPro',
                                                                                      ),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      maxLines: 1,
                                                                                    )
                                                                                  : const SizedBox()
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      )),
                                                                  Text(
                                                                    formattedDate,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color.fromRGBO(
                                                                          113,
                                                                          113,
                                                                          113,
                                                                          1),
                                                                      fontSize:
                                                                          8,
                                                                      fontFamily:
                                                                          'NeueHaasGroteskTextPro',
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ), // Display message if list is empty
                                                ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                )),
                          )
                  ],
                ),
              );
            }));
  }
}
