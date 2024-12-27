// planDetailPage here we can see details of selected plan.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/presentation/choose_plan/bloc/plan_details_bloc.dart';
import 'package:lm_club/app/presentation/choose_plan/bloc/plan_details_state.dart';
import 'package:lm_club/constants/color_constants.dart';
import 'package:accordion/accordion.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lm_club/utils/globals.dart' as globals;
import 'package:qlevar_router/qlevar_router.dart';

class PlanDetails extends StatefulWidget {
  const PlanDetails({Key? key}) : super(key: key);
  @override
  State<PlanDetails> createState() => _PlanDetailsState();
}

final Map<String, String> planImages = {
  'bronze': "assets/images/bronze.png",
  'silver': 'assets/images/silver.png',
  'gold': 'assets/images/gold.png',
  'platinum': 'assets/images/platinum.png'
  // Add other plan types and their respective image paths
};

class _PlanDetailsState extends State<PlanDetails> {
  final PlanDetailsBloc _planDetailsBloc = getIt.get<PlanDetailsBloc>();

  @override
  Widget build(BuildContext context) {
    String? colorValue = globals.colorValue;
    // Replace this with your hex color

    Color hexToRgba(String hexColor) {
      hexColor = hexColor.replaceAll("#", "");
      int value = int.parse(hexColor, radix: 16);

      int alpha = (value >> 24) & 0xFF;
      int red = (value >> 16) & 0xFF;
      int green = (value >> 8) & 0xFF;
      int blue = value & 0xFF;

      return Color.fromRGBO(red, green, blue, alpha / 255.0);
    }

    Color rgbaColor = hexToRgba(colorValue);

    return BlocProvider(
      create: (context) => _planDetailsBloc..getplan(globals.planId),
      child: BlocConsumer<PlanDetailsBloc, PlanDetailsState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Stack(children: [
              Scaffold(
                  backgroundColor: ColorCons.appBG,
                  // appBar: AppBar(
                  //   backgroundColor: Colors.transparent,
                  //   elevation: 0,
                  //   shadowColor: const Color.fromRGBO(0, 0, 0, 0.16),
                  //   flexibleSpace: Container(
                  //     decoration: const BoxDecoration(
                  //       gradient: LinearGradient(
                  //         colors: [
                  //           Color.fromRGBO(12, 57, 131, 1),
                  //           Color.fromRGBO(0, 176, 80, 1),
                  //         ],
                  //         begin: Alignment.centerLeft,
                  //         end: Alignment.centerRight,
                  //       ),
                  //       borderRadius: BorderRadius.only(
                  //         bottomLeft: Radius.circular(25),
                  //         bottomRight: Radius.circular(25),
                  //       ),
                  //     ),
                  //     child: const Center(
                  //       child: Text(
                  //         'Plan Details',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 16,
                  //           fontFamily: 'NeueHaasGroteskTextPro',
                  //           fontWeight: FontWeight.w900,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  //   centerTitle: true,
                  //   leading: IconButton(
                  //     icon: const Icon(Icons.arrow_back, color: Colors.white),
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //     },
                  //   ),
                  // ),
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
                        title: const Text(
                          'Plan Details',
                          style: TextStyle(
                            color: Color.fromRGBO(238, 238, 238, 1),
                            fontSize: 18,
                            fontFamily: 'NeueHaasGroteskTextPro',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        centerTitle: false,
                        elevation: 0,
                      ),
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(14, 12, 12, 14),
                            decoration: BoxDecoration(
                                color: state.choosePlanModal!.plan == 'Bronze'
                                    ? ColorCons.bronze
                                    : state.choosePlanModal!.plan == 'Silver'
                                        ? ColorCons.silver
                                        : state.choosePlanModal!.plan == 'Gold'
                                            ? ColorCons.gold
                                            : state.choosePlanModal!.plan ==
                                                    'Platinum'
                                                ? ColorCons.platinum
                                                : rgbaColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            margin: const EdgeInsets.only(left: 0, bottom: 0),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                170,
                                        child:
                                            Text(state.choosePlanModal!.plan!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: ColorCons.buttonBG,
                                                  fontSize: 18.0,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w900,
                                                )),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Registration / Renewal   \$${state.choosePlanModal!.registrationAmount!}",
                                        style: const TextStyle(
                                          color: Color.fromRGBO(35, 44, 58, 1),
                                          fontSize: 12.0,
                                          fontFamily: 'NeueHaasGroteskTextPro',
                                          fontWeight: FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${state.choosePlanModal!.planAmountString}/month',

                                            // state.choosePlanModal!
                                            //     .planAmountString!,
                                            style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(35, 44, 58, 1),
                                              fontSize: 18.0,
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              fontWeight: FontWeight.w900,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  // if (imagePath.isNotEmpty)
                                  //   Image.asset(
                                  //     imagePath,
                                  //     width: 83,
                                  //     height: 83,
                                  //     alignment: Alignment.center,
                                  //   ),

                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.18,
                                    height: MediaQuery.of(context).size.width *
                                        0.18,
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                              112, 112, 112, 1),
                                          width: 2.0,
                                        ),
                                        image: state.choosePlanModal!.imagePath!
                                                .isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(state
                                                    .choosePlanModal!
                                                    .imagePath!),
                                                fit: BoxFit.fill,
                                              )
                                            : const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/bronze.png'),
                                                fit: BoxFit.fill,
                                              )),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 20, 8),
                                  child: Text(
                                    "Benefits",
                                    style: TextStyle(
                                      color: Color.fromRGBO(35, 44, 59, 1),
                                      fontSize: 16.0,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w900,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Accordion(
                                  paddingListTop: 0,
                                  paddingListBottom: 0,
                                  headerBorderColor:
                                      const Color.fromRGBO(221, 221, 221, 1),
                                  headerBorderColorOpened:
                                      const Color.fromRGBO(221, 221, 221, 1),
                                  headerBackgroundColor:
                                      const Color.fromRGBO(255, 255, 255, 1),
                                  headerBorderWidth: 1,
                                  headerBackgroundColorOpened:
                                      const Color.fromRGBO(255, 255, 255, 1),
                                  contentBackgroundColor:
                                      const Color.fromRGBO(255, 255, 255, 0.8),
                                  headerBorderRadius: 5,
                                  contentBorderRadius: 5,
                                  contentBorderColor:
                                      const Color.fromRGBO(221, 221, 221, 1),
                                  contentBorderWidth: 1,
                                  scaleWhenAnimating: true,
                                  openAndCloseAnimation: true,
                                  paddingBetweenClosedSections: 0,
                                  paddingBetweenOpenSections: 0,
                                  headerPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 13),
                                  contentHorizontalPadding: 13,
                                  contentVerticalPadding: 13,
                                  children: state.choosePlanModal!.widgets!
                                      .map((item) {
                                    return AccordionSection(
                                      isOpen: false,
                                      rightIcon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Color.fromRGBO(219, 219, 219, 1),
                                        size: 20,
                                      ),
                                      header: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              state.choosePlanModal!.plan!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    35, 44, 58, 1),
                                                fontSize: 10.0,
                                                fontFamily:
                                                    'NeueHaasGroteskTextPro',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6, width: 30),
                                          Text(
                                            item.name!,
                                            style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(35, 44, 58, 1),
                                              fontSize: 10.0,
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                item.description!,
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                  fontSize: 10.0,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ]),
                                    );
                                  }).toList(),
                                )
                              ],
                            )),
                        Container(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Terms & Conditions",
                                    style: TextStyle(
                                      color: Color.fromRGBO(35, 44, 59, 1),
                                      fontSize: 16.0,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w900,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          14, 14, 14, 12),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 1),
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  221, 221, 221, 1))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Introduction ",
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(35, 44, 59, 1),
                                              fontSize: 13.0,
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 1,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                              state.choosePlanModal!
                                                  .description!,
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    35, 44, 59, 1),
                                                fontSize: 10.0,
                                                fontFamily:
                                                    'NeueHaasGroteskTextPro',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          // const SizedBox(
                                          //   height: 8,
                                          // ),
                                          // InkWell(
                                          //     onTap: () {},
                                          //     child: const Text(
                                          //       "Read more ..",
                                          //       style: TextStyle(
                                          //         color: Color.fromRGBO(
                                          //             0, 176, 80, 1),
                                          //         fontSize: 12.0,
                                          //         fontFamily:
                                          //             'NeueHaasGroteskTextPro',
                                          //         fontWeight: FontWeight.w900,
                                          //       ),
                                          //     ))
                                        ],
                                      ))
                                ]))
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
}
