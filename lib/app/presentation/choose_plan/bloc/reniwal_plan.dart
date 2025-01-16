// reniwalPlan once you enrolled with Free Plan after 3months user have to proceed with other plan

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/presentation/choose_plan/bloc/plan_details_bloc.dart';
import 'package:lm_club/app/presentation/choose_plan/bloc/plan_details_state.dart';
import 'package:lm_club/constants/color_constants.dart';
import 'package:accordion/accordion.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ReniwalPlan extends StatefulWidget {
  final String id;
  final String? subscriptionPlan;
  const ReniwalPlan({Key? key, required this.id, this.subscriptionPlan})
      : super(key: key);
  @override
  State<ReniwalPlan> createState() => _ReniwalState();
}

final Map<String, String> planImages = {
  'bronze': "assets/images/bronze.png",
  'silver': 'assets/images/silver.png',
  'gold': 'assets/images/gold.png',
  'platinum': 'assets/images/platinum.png'
  // Add other plan types and their respective image paths
};

class _ReniwalState extends State<ReniwalPlan> {
  final PlanDetailsBloc _planDetailsBloc = getIt.get<PlanDetailsBloc>();
  // final String id = globals.planId;
  final String id = QR.params.asMap["id"]?.value as String;
  final String subscriptionPlan =
      QR.params.asMap["subscriptionPlan"]?.value as String;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _planDetailsBloc..getplan(id),
      child: BlocConsumer<PlanDetailsBloc, PlanDetailsState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Stack(children: [
              Scaffold(
                  backgroundColor: ColorCons.appBG,
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
                        title: subscriptionPlan == 'FREE'
                            ? const Text(
                                'Plan Details',
                                style: TextStyle(
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                  fontSize: 18,
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : const Text(
                                'Renewal Plan Details',
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
                                                : ColorCons.silver,
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
                                      subscriptionPlan == 'FREE'
                                          ? Text(
                                              "Registration / Renewal   \$${state.choosePlanModal!.registrationAmount!}",
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    35, 44, 58, 1),
                                                fontSize: 12.0,
                                                fontFamily:
                                                    'NeueHaasGroteskTextPro',
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textAlign: TextAlign.left,
                                            )
                                          : const SizedBox(),
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
                                        ],
                                      ))
                                ]))
                      ],
                    ),
                  ),
                  bottomNavigationBar: BottomAppBar(
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                QR.toName(Routes.RENIWALPAY.name, params: {
                                  'reniwal': state.choosePlanModal!.planAmount
                                      .toString(),
                                  'planId':
                                      state.choosePlanModal?.id.toString(),
                                  'subscriptionPlan': subscriptionPlan,
                                  'registrationAmount': state
                                      .choosePlanModal!.registrationAmount
                                      .toString()
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(55, 74, 156, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                elevation: 4,
                              ),
                              child: SizedBox(
                                height: 42,
                                child: Center(
                                  child: subscriptionPlan == 'FREE'
                                      ? const Text(
                                          'Proceed',
                                          style: TextStyle(
                                            fontFamily:
                                                "NeueHaasGroteskTextPro",
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Pay',
                                          style: TextStyle(
                                            fontFamily:
                                                "NeueHaasGroteskTextPro",
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              if (state.isLoading)
                Container(
                  color: Colors.transparent.withOpacity(0.2),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.hexagonDots(
                          size: 35,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 10),
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
