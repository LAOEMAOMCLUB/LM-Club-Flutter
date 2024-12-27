// ChooseplanPage here we can any chooseplan

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/models/auth/response_model/choose_plan_response.dart';
import 'package:lm_club/app/presentation/choose_plan/bloc/choose_plan_bloc.dart';
import 'package:lm_club/app/presentation/choose_plan/bloc/choose_plane_state.dart';
import 'package:lm_club/constants/color_constants.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ChoosePlan extends StatefulWidget {
  final String? subscriptionPlan;
  const ChoosePlan({Key? key, this.subscriptionPlan}) : super(key: key);

  @override
  State<ChoosePlan> createState() => _ChoosePlanState();
}

class _ChoosePlanState extends State<ChoosePlan> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final ChoosePlanBloc choosePlanBloc = getIt.get<ChoosePlanBloc>();
    final String subscriptionPlan =
        QR.params.asMap["subscriptionPlan"]?.value as String;
    List<ChoosePlanModal> filteredPlans;
    return BlocProvider(
      create: (context) => choosePlanBloc..getAllPlans(),
      child: BlocConsumer<ChoosePlanBloc, ChoosePlanState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (subscriptionPlan == 'FREE') {
              filteredPlans = state.choosePlan
                  .where((plan) => plan.plan != 'FREE')
                  .toList();
            } else {
              filteredPlans = state.choosePlan;
            }

            return Stack(children: [
              Scaffold(
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
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            QR.back();
                          },
                        ),
                        title: const Column(
                          children: [
                            Text(
                              'Create your account and Sign Up!',
                              style: TextStyle(
                                color: Color.fromRGBO(238, 238, 238, 1),
                                fontSize: 16,
                                fontFamily: 'NeueHaasGroteskTextPro',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text('Choose a level that’s best for you!',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 14.0,
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  fontWeight: FontWeight.normal,
                                )),
                          ],
                        ),
                        centerTitle: false,
                        elevation: 0,
                      ),
                    ),
                  ),
                  body: Container(
                      width: screenWidth,
                      color: const Color.fromRGBO(238, 238, 238, 1),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 20, top: 20),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: filteredPlans.length,
                                    itemBuilder: (context, index) {
                                      String colorToHex(Color color) {
                                        return '#${color.value.toRadixString(16).padLeft(8, '0')}';
                                      }

                                      Color backgroundColor =
                                          getColorForIndex(index % 10);
                                      String colorValue =
                                          colorToHex(backgroundColor);

                                      Color borderColor =
                                          getColorForIndex(index % 10);

                                      Color dividerColor =
                                          getDividerColorForIndex(index % 10);
                                      return filteredPlans[index].isActive ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.fromLTRB(
                                                  14, 14, 14, 14),
                                              decoration: BoxDecoration(
                                                  //  color: backgroundColor,
                                                  color: filteredPlans[index]
                                                              .plan ==
                                                          'Bronze'
                                                      ? ColorCons.bronze
                                                      : filteredPlans[index]
                                                                  .plan ==
                                                              'Silver'
                                                          ? ColorCons.silver
                                                          : filteredPlans[index]
                                                                      .plan ==
                                                                  'Gold'
                                                              ? ColorCons.gold
                                                              : filteredPlans[index]
                                                                          .plan ==
                                                                      'Platinum'
                                                                  ? ColorCons
                                                                      .platinum
                                                                  : backgroundColor,
                                                  border: Border.all(
                                                    width: 1,
                                                    // color: borderColor
                                                    color: state.choosePlan[index].plan ==
                                                            'Bronze'
                                                        ? const Color.fromRGBO(
                                                            204, 101, 0, 1)
                                                        : filteredPlans[index]
                                                                    .plan ==
                                                                'Silver'
                                                            ? const Color.fromRGBO(
                                                                112, 209, 242, 1)
                                                            : filteredPlans[index]
                                                                        .plan ==
                                                                    'Gold'
                                                                ? const Color.fromRGBO(
                                                                    192,
                                                                    174,
                                                                    3,
                                                                    1)
                                                                : filteredPlans[index]
                                                                            .plan ==
                                                                        'Platinum'
                                                                    ? const Color
                                                                        .fromRGBO(
                                                                        32,
                                                                        197,
                                                                        142,
                                                                        1)
                                                                    : borderColor,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin: const EdgeInsets.only(
                                                  left: 10, bottom: 15),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                200,
                                                            child: Text(
                                                              state
                                                                  .choosePlan[
                                                                      index]
                                                                  .plan!,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                color: ColorCons
                                                                    .buttonBG,
                                                                fontSize: 18.0,
                                                                fontFamily:
                                                                    'NeueHaasGroteskTextPro',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 6),
                                                          ...state
                                                              .choosePlan[index]
                                                              .widgets!
                                                              .map((item) =>
                                                                  SizedBox(
                                                                    width: 250,
                                                                    child: Text(
                                                                      item.name!,
                                                                      maxLines:
                                                                          1,
                                                                      style:
                                                                          TextStyle(
                                                                        color: ColorCons
                                                                            .buttonBG,
                                                                        fontSize:
                                                                            12.0,
                                                                        fontFamily:
                                                                            'NeueHaasGroteskTextPro',
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  )),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.18,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.18,
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
                                                                        .choosePlan[
                                                                            index]
                                                                        .imagePath!
                                                                        .isNotEmpty
                                                                    ? DecorationImage(
                                                                        image: NetworkImage(state
                                                                            .choosePlan[index]
                                                                            .imagePath!),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )
                                                                    : const DecorationImage(
                                                                        image: AssetImage(
                                                                            'assets/images/bronze.png'),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Divider(
                                                    //  color: dividerColor,
                                                    color: state
                                                                .choosePlan[
                                                                    index]
                                                                .plan ==
                                                            'Bronze'
                                                        ? ColorCons
                                                            .bronzeDivider
                                                        : state
                                                                    .choosePlan[
                                                                        index]
                                                                    .plan ==
                                                                'Silver'
                                                            ? ColorCons
                                                                .silverDivider
                                                            : state
                                                                        .choosePlan[
                                                                            index]
                                                                        .plan ==
                                                                    'Gold'
                                                                ? ColorCons
                                                                    .goldDivider
                                                                : filteredPlans[index]
                                                                            .plan ==
                                                                        'Platinum'
                                                                    ? ColorCons
                                                                        .platinumDivider
                                                                    : dividerColor,
                                                    height: 1,
                                                  ),
                                                  const SizedBox(height: 7),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: filteredPlans[
                                                                          index]
                                                                      .plan !=
                                                                  'FREE'
                                                              ? Text(
                                                                  "Registration / Renewal   \$${filteredPlans[index].registrationAmount!}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: ColorCons
                                                                        .buttonBG,
                                                                    fontSize:
                                                                        10.0,
                                                                    fontFamily:
                                                                        'NeueHaasGroteskTextPro',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                )
                                                              : const SizedBox(),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '\$${filteredPlans[index].planAmount}.00/month',
                                                              style: TextStyle(
                                                                color: ColorCons
                                                                    .buttonBG,
                                                                fontSize: 21.0,
                                                                fontFamily:
                                                                    'NeueHaasGroteskTextPro',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: OutlinedButton(
                                                          onPressed: () {
                                                            QR.toName(
                                                                Routes
                                                                    .PLAN_DETAILS
                                                                    .name,
                                                                params: {
                                                                  'id': state
                                                                      .choosePlan[
                                                                          index]
                                                                      .id
                                                                      .toString()
                                                                });

                                                            choosePlanBloc.updatePlanId(
                                                                state
                                                                    .choosePlan[
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                                colorValue);
                                                          },
                                                          style: OutlinedButton
                                                              .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                            side: BorderSide(
                                                                width: 1.0,
                                                                color: ColorCons
                                                                    .buttonBG),
                                                          ),
                                                          child: Text(
                                                            "Details",
                                                            style: TextStyle(
                                                              color: ColorCons
                                                                  .buttonBG,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'NeueHaasGroteskTextPro',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            subscriptionPlan ==
                                                                        '' ||
                                                                    subscriptionPlan
                                                                        .isEmpty
                                                                ? QR.toName(
                                                                    Routes
                                                                        .ENROLL
                                                                        .name,
                                                                    params: {
                                                                        'id': state
                                                                            .choosePlan[index]
                                                                            .id
                                                                            .toString()
                                                                      })
                                                                : QR.toName(
                                                                    Routes
                                                                        .RENIWALPLAN
                                                                        .name,
                                                                    params: {
                                                                      'id': state
                                                                          .choosePlan[
                                                                              index]
                                                                          .id
                                                                          .toString(),
                                                                      'subscriptionPlan':
                                                                          subscriptionPlan
                                                                    },
                                                                  );

                                                            choosePlanBloc.updatePlanId(
                                                                state
                                                                    .choosePlan[
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                                colorValue);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                ColorCons
                                                                    .buttonBG,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            "Choose Plan",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'NeueHaasGroteskTextPro',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ))
                                          : const SizedBox();
                                    },
                                  )))
                        ],
                      ))),
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

  Color getColorForIndex(int index) {
    List<Color> colorList = [
      const Color.fromARGB(255, 226, 143, 153),
      const Color.fromARGB(255, 183, 225, 184),
      const Color.fromARGB(255, 156, 202, 241),
      const Color.fromARGB(255, 173, 115, 236),
      const Color.fromARGB(255, 127, 230, 141),
      const Color.fromARGB(255, 228, 148, 225),
      const Color.fromARGB(255, 182, 244, 239),
      const Color.fromARGB(255, 237, 173, 195),
      const Color.fromARGB(255, 187, 194, 243),
      const Color.fromARGB(255, 189, 222, 237),
    ];
    return colorList[index % colorList.length];
  }

  Color getDividerColorForIndex(int index) {
    List<Color> colorList = [
      const Color.fromARGB(255, 237, 131, 144),
      const Color.fromARGB(255, 183, 225, 184),
      const Color.fromARGB(255, 156, 202, 241),
      const Color.fromARGB(255, 173, 115, 236),
      const Color.fromARGB(255, 127, 230, 141),
      const Color.fromARGB(255, 228, 148, 225),
      const Color.fromARGB(255, 182, 244, 239),
      const Color.fromARGB(255, 237, 173, 195),
      const Color.fromARGB(255, 187, 194, 243),
      const Color.fromARGB(255, 189, 222, 237),
    ];

    // Ensure the index is within bounds
    return colorList[index % colorList.length];
  }
}
