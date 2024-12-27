// referEarnPage we can refer a friend and earn points by sharing ourcode.

import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/presentation/refer/bloc/refer_bloc.dart';
import 'package:lm_club/app/presentation/refer/bloc/refer_state.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:url_launcher/url_launcher.dart';

class MyObject {
  final String id;
  final String value;
  final String text;

  MyObject({
    required this.id,
    required this.value,
    required this.text,
  });
}

class ReferEarn extends StatefulWidget {
  const ReferEarn({Key? key}) : super(key: key);

  @override
  State<ReferEarn> createState() => _ReferEarnState();
}

class _ReferEarnState extends State<ReferEarn> {
  late int referalCount;

  String bonusPoints = '';
  bool isValueInRange = false;
  Color activeColor =
      const Color.fromRGBO(35, 44, 58, 1); // Color for active range
  Color inactiveColor = const Color.fromRGBO(35, 44, 58, 0.5);
  final ReferEarnBloc _referEarnBloc = getIt.get<ReferEarnBloc>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _referEarnBloc..getReferalCode(),
        child: BlocConsumer<ReferEarnBloc, ReferEarnState>(
            listener: (context, state) {},
            builder: (context, state) {
              int referalCount = state.refeeralCode!.referalCount!;
              String bonusPoints = state.refeeralCode!.bonusPoints!.toString();

              return Stack(children: [
                Scaffold(
                    backgroundColor: const Color.fromRGBO(208, 231, 250, 1),
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
                        ),
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () {
                              QR.back();
                            },
                          ),
                          title: const Text(
                            'Refer your friends and Earn',
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
                    body: SingleChildScrollView(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(208, 231, 250, 1),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(24, 33, 24, 24),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                "assets/images/medal.png",
                                                width: 27.0,
                                                height: 27.0,
                                              ),
                                              const SizedBox(width: 4.0),
                                              const Text(
                                                "100",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                  fontSize: 24,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          const Text(
                                            "Your Friend gets 100 Points on Signup, and you get 100 points too Every time!",
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(35, 44, 58, 1),
                                              fontSize: 13,
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Image.asset(
                                      "assets/images/prize.png",
                                      width: 136,
                                      height: 80,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(
                                    context, bonusPoints, referalCount);
                              },
                              child: SizedBox(
                                width: double.infinity,
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 26),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          24, 125, 161, 0.2),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromARGB(255, 18, 121, 159),
                                  ),
                                  child: state.refeeralCode!.referalCount! >= 10
                                      ? ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Container(
                                            width: double.infinity,
                                            color: const Color.fromRGBO(
                                                237, 249, 253, 1),
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 10, 16, 10),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween, // Align content to the space between the widgets
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .fromLTRB(
                                                          26, 0, 20, 0),
                                                      child: const Text(
                                                        "1 - 10",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'NeueHaasGroteskTextPro',
                                                          color: Color.fromRGBO(
                                                              35, 44, 58, 1),
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      width: 1,
                                                      color:
                                                          const Color.fromRGBO(
                                                              24,
                                                              125,
                                                              161,
                                                              0.2),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 16),
                                                Stack(children: [
                                                  SizedBox(
                                                    child: Center(
                                                      child: Image.asset(
                                                        "assets/images/badge.png",
                                                        width: 24,
                                                        height: 24,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  const Positioned(
                                                    left: 2,
                                                    top: 0,
                                                    bottom: 5,
                                                    right: 0,
                                                    child: Center(
                                                      child: Text(
                                                        '1 ',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromRGBO(
                                                              35, 44, 58, 1),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: RichText(
                                                    text: const TextSpan(
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            'NeueHaasGroteskTextPro',
                                                        color: Color.fromRGBO(
                                                            35, 44, 58, 1),
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'You have reached ',
                                                        ),
                                                        TextSpan(
                                                          text: 'Level 1',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: ' by referring',
                                                        ),
                                                        TextSpan(
                                                          text: ' 10 members',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.chevron_right,
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Container(
                                            width: double.infinity,
                                            color: const Color.fromRGBO(
                                                237, 249, 253, 1),
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 10, 16, 10),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween, // Align content to the space between the widgets
                                              children: [
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: RichText(
                                                    text: const TextSpan(
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            'NeueHaasGroteskTextPro',
                                                        color: Color.fromRGBO(
                                                            35, 44, 58, 1),
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'Keep referring to reach new levels and maximize your rewards!',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.chevron_right,
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(20),
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          2, 0, 2, 20),
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(10),
                                        color: const Color.fromRGBO(
                                            221, 221, 221, 1),
                                        child: ClipRRect(
                                          child: Container(
                                            width: double.infinity,
                                            color: const Color.fromRGBO(
                                                237, 249, 253, 1),
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 10, 16, 10),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    const Text(
                                                      "Your referral code",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'NeueHaasGroteskTextPro',
                                                        color: Color.fromRGBO(
                                                            35, 44, 58, 1),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 1,
                                                    ),
                                                    Text(
                                                      state.refeeralCode!
                                                          .referalCode!,
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontFamily:
                                                              'NeueHaasGroteskTextPro',
                                                          color: Color.fromRGBO(
                                                              24, 125, 161, 1),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  width: 1,
                                                  height: 37,
                                                  color: const Color.fromRGBO(
                                                      184, 188, 204, 1),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text: state
                                                                .refeeralCode!
                                                                .referalCode!));

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Text copied to clipboard'),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    "Copy",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            'NeueHaasGroteskTextPro',
                                                        color: Color.fromRGBO(
                                                            35, 44, 58, 1)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "Share your referral CodeVia",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(35, 44, 58, 1),
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // _launchWhatsApp(state
                                            //     .refeeralCode!.referalCode!);

                                            String referralCode = state
                                                .refeeralCode!.referalCode!;
                                            shareReferralCode(referralCode);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    0, 176, 80, 1),
                                            padding: const EdgeInsets.all(15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/images/watsapp.png",
                                                width: 18,
                                                height: 18,
                                              ),
                                              const SizedBox(width: 3),
                                              const Text(
                                                'Whatsapp',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            state.refeeralCode!.referalCode!.isNotEmpty
                                ? Container(
                                    height: MediaQuery.sizeOf(context).height,
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 0, 10, 35),
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              25, 10, 20, 12),
                                          child: Text(
                                            "Frequently Asked Questions",
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(35, 44, 58, 1),
                                              fontSize: 14.0,
                                              fontFamily:
                                                  'NeueHaasGroteskTextPro',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Accordion(
                                          paddingListTop: 0,
                                          paddingListBottom: 0,
                                          headerBorderColor:
                                              const Color.fromARGB(
                                                  255, 240, 235, 235),
                                          headerBorderColorOpened:
                                              const Color.fromARGB(
                                                  255, 240, 235, 235),
                                          headerBackgroundColor:
                                              const Color.fromARGB(
                                                  255, 240, 235, 235),
                                          headerBorderWidth: 1,
                                          headerBackgroundColorOpened:
                                              const Color.fromARGB(
                                                  255, 240, 235, 235),
                                          contentBackgroundColor:
                                              const Color.fromARGB(
                                                  255, 240, 235, 235),
                                          headerBorderRadius: 5,
                                          contentBorderRadius: 5,
                                          contentBorderColor:
                                              const Color.fromARGB(
                                                  255, 240, 235, 235),
                                          contentBorderWidth: 1,
                                          scaleWhenAnimating: true,
                                          openAndCloseAnimation: true,
                                          paddingBetweenClosedSections: 0,
                                          paddingBetweenOpenSections: 0,
                                          headerPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 13),
                                          contentHorizontalPadding: 13,
                                          contentVerticalPadding: 13,
                                          children: [
                                            AccordionSection(
                                                isOpen: false,
                                                rightIcon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Color.fromRGBO(
                                                      167, 165, 165, 1),
                                                  size: 20,
                                                ),
                                                header: const Text(
                                                  'What is the Enroll Rewards Program?',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        35, 44, 58, 1),
                                                    fontSize: 12.0,
                                                    fontFamily:
                                                        'NeueHaasGroteskTextPro',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                content: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                        child: state
                                                                .refeeralCode!
                                                                .referalCode!
                                                                .isNotEmpty
                                                            ? const Text(
                                                                "The Grow Rewards Program is an initiative of the LM membership club that rewards members for referring new people to join their community. It's designed to acknowledge and reward the efforts of members who contribute to the growth of the club.",
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          35,
                                                                          44,
                                                                          58,
                                                                          1),
                                                                  fontSize:
                                                                      10.0,
                                                                  fontFamily:
                                                                      'NeueHaasGroteskTextPro',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                      ),
                                                    ])),
                                            AccordionSection(
                                              isOpen: true,
                                              rightIcon: const Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Color.fromRGBO(
                                                    167, 165, 165, 1),
                                                size: 20,
                                              ),
                                              header: const Text(
                                                'How does it work?',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      35, 44, 58, 1),
                                                  fontSize: 12.0,
                                                  fontFamily:
                                                      'NeueHaasGroteskTextPro',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              content: const Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Members can earn points in the following way:',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          35, 44, 58, 1),
                                                      fontSize: 10.0,
                                                      fontFamily:
                                                          'NeueHaasGroteskTextPro',
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    '1. By inviting friends, family, and colleagues to join the LM club.',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          35, 44, 58, 1),
                                                      fontSize: 10.0,
                                                      fontFamily:
                                                          'NeueHaasGroteskTextPro',
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    '2. Each new member enrolled translates into reward points for the inviting member.',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          35, 44, 58, 1),
                                                      fontSize: 10.0,
                                                      fontFamily:
                                                          'NeueHaasGroteskTextPro',
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    '3. For every tenth member that a member successfully enrolls, they receive not only bonus points but also a prestigious trophy.',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          35, 44, 58, 1),
                                                      fontSize: 10.0,
                                                      fontFamily:
                                                          'NeueHaasGroteskTextPro',
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            AccordionSection(
                                                isOpen: true,
                                                rightIcon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Color.fromRGBO(
                                                      167, 165, 165, 1),
                                                  size: 20,
                                                ),
                                                header: const Text(
                                                  'Where can I use these points?',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        35, 44, 58, 1),
                                                    fontSize: 12.0,
                                                    fontFamily:
                                                        'NeueHaasGroteskTextPro',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                content: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          "The points earned through the LM Grow Rewards Program can be redeemed for a variety of exciting prizes, discounts, or exclusive offers from partner businesses of the LM club. Specific details on where and how to redeem these points would typically be provided by the club, often through a catalog.",
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    35,
                                                                    44,
                                                                    58,
                                                                    1),
                                                            fontSize: 10.0,
                                                            fontFamily:
                                                                'NeueHaasGroteskTextPro',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ),
                                                    ])),
                                            AccordionSection(
                                                isOpen: true,
                                                rightIcon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Color.fromRGBO(
                                                      167, 165, 165, 1),
                                                  size: 20,
                                                ),
                                                header: const Text(
                                                  'Can I earn points for referring anyone, or do they have to meet certain criteria?',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        35, 44, 58, 1),
                                                    fontSize: 12.0,
                                                    fontFamily:
                                                        'NeueHaasGroteskTextPro',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                content: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          "Points are awarded for each new member who joins the club, but they usually need to meet the membership criteria set out by the LM club.",
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    35,
                                                                    44,
                                                                    58,
                                                                    1),
                                                            fontSize: 10.0,
                                                            fontFamily:
                                                                'NeueHaasGroteskTextPro',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ),
                                                    ])),
                                          ],
                                        )
                                      ],
                                    ))
                                : const SizedBox()
                          ],
                        ),
                      ),
                    )),
                if (state.isLoading)
                  Container(
                    color: Colors.transparent
                        // ignore: deprecated_member_use
                        .withOpacity(0.2), // Semi-transparent black overlay
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingAnimationWidget.hexagonDots(
                            size: 35,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                              height: 10), // Adjust spacing if needed
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

  // void shareReferralCode(String referralCode) {
  //   String appLink = Platform.isAndroid
  //       ? 'https://play.google.com/store/apps/details?id=com.laoemaom.lmclub'
  //       : 'https://apps.apple.com/app/lm-club/id6469708246';
  //   String message =
  //       'Hey there! I have been really enjoying the perks of the LM club, and I think you would too! '
  //       'It is packed with awesome rewards and benefits that genuinely make a difference. If you are interested, '
  //       'you can join using my referral link/code: *$referralCode* - $appLink. By signing up through it, we both get to earn reward points! .';

  //   Share.share(message);
  // }

  void shareReferralCode(String referralCode) async {
    String appLink = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=com.laoemaom.lmclub'
        : 'https://apps.apple.com/app/lm-club/id6469708246';

    String message =
        'Hey there! I have been really enjoying the perks of the LM club, and I think you would too! '
        'It is packed with awesome rewards and benefits that genuinely make a difference. If you are interested, '
        'you can join using my referral link/code: *$referralCode* - $appLink. By signing up through it, we both get to earn reward points!';

    // Encode the message for URL
    String encodedMessage = Uri.encodeComponent(message);

    // Create the WhatsApp URL
    String whatsappUrl = 'https://wa.me/?text=$encodedMessage';

    // Launch the URL
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  void _showBottomSheet(BuildContext context, bonusPoints, referalCount) {
    showModalBottomSheet(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reached refer levels',
                        style: TextStyle(
                          color: Color.fromRGBO(35, 44, 58, 1),
                          fontSize: 14,
                          fontFamily: 'NeueHaasGroteskTextPro',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                // Repeating rows

                Container(
                  padding: const EdgeInsets.fromLTRB(21, 15, 21, 10),
                  child: _buildRow(bonusPoints, referalCount),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(String bonusPoints, int referralCount) {
    List<RangeData> ranges = [
      RangeData(start: 1, end: 10, label: '1-10', level: '1'),
      RangeData(start: 11, end: 20, label: '11-20', level: '2'),
      RangeData(start: 21, end: 30, label: '21-30', level: '3'),
      RangeData(start: 31, end: 40, label: '31-40', level: '4'),
      // Add more ranges as needed
    ];

    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Members',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(170, 170, 170, 1),
              ),
            ),
            SizedBox(width: 44),
            Text(
              'Levels',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(170, 170, 170, 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        for (var range in ranges)
          _buildRange(referralCount, bonusPoints, range),
      ],
    );
  }

  Widget _buildRange(int referralCount, String bonusPoints, RangeData range) {
    //bool isInRange = referralCount >= range.start && referralCount <= range.end;
    bool isInRange = referralCount >= range.end;
    return GestureDetector(
        onTap: () {
          isInRange
              ? _showCongratulationsDialog(context, bonusPoints, range)
              : const SizedBox();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 38,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    range.label,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: isInRange ? activeColor : inactiveColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            isInRange
                ? Container(
                    width: 8.0,
                    height: 8.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(35, 44, 58, 1),
                    ),
                  )
                : const SizedBox(),
            SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 0, 0, 26),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isInRange
                            ? const Color.fromRGBO(24, 125, 161, 0.2)
                            : const Color.fromRGBO(24, 125, 161, 0),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(237, 249, 253, 1),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      child: Container(
                        width: double.infinity,
                        color: const Color.fromRGBO(237, 249, 253, 1),
                        padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(children: [
                              SizedBox(
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/badge.png",
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 2,
                                top: 0,
                                bottom: 5,
                                right: 0,
                                child: Center(
                                  child: Text(
                                    '${range.level} ',
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(35, 44, 58, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            const SizedBox(width: 5),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    color: isInRange
                                        ? const Color.fromRGBO(35, 44, 58, 1)
                                        : const Color.fromRGBO(35, 44, 58, 0.5),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'You have reached ',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                        color: isInRange
                                            ? const Color.fromRGBO(
                                                35, 44, 58, 1)
                                            : const Color.fromRGBO(
                                                35, 44, 58, 0.5),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Level ${range.level} ',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: isInRange
                                            ? const Color.fromRGBO(
                                                35, 44, 58, 1)
                                            : const Color.fromRGBO(
                                                35, 44, 58, 0.5),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' by referring',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w200,
                                        color: isInRange
                                            ? const Color.fromRGBO(
                                                35, 44, 58, 1)
                                            : const Color.fromRGBO(
                                                35, 44, 58, 0.5),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${range.end} members ',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: isInRange
                                            ? const Color.fromRGBO(
                                                35, 44, 58, 1)
                                            : const Color.fromRGBO(
                                                35, 44, 58, 0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
                              decoration: BoxDecoration(
                                color: isInRange
                                    ? const Color.fromRGBO(252, 223, 108, 1)
                                    : const Color.fromRGBO(252, 223, 108, 0.5),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    bonusPoints,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Image.asset(
                                    "assets/images/medal.png",
                                    width: 21.0,
                                    height: 21.0,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void _showCongratulationsDialog(
      BuildContext context, String bonusPoints, RangeData range) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: const RadialGradient(
                colors: [Color(0xFFFFFFFF), Color(0xFFD0E7FA)],
                center: Alignment.center,
                radius: 1.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  "assets/images/Design.png",
                  width: double.infinity,
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Congratulations',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'GreatVibes-Regular',
                    color: Color.fromRGBO(236, 177, 0, 1),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 20, 0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'NeueHaasGroteskTextPro',
                          color: Color.fromRGBO(35, 44, 58, 1)),
                      children: [
                        const TextSpan(
                          text: 'You have reached ',
                        ),
                        TextSpan(
                          text: 'Level ${range.level} ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: ' by',
                        ),
                        const WidgetSpan(
                          child: SizedBox(width: 10),
                        ),
                        const TextSpan(
                          text: ' referring',
                        ),
                        TextSpan(
                          text: ' ${range.end} members ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 73,
                  padding: const EdgeInsets.fromLTRB(7, 6, 7, 6),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(252, 223, 108, 1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/medal.png",
                        width: 20.0,
                        height: 20.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        bonusPoints,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 150,
                  height: 40,
                  margin: const EdgeInsets.only(bottom: 0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF292D38),
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: const Color(0xFF4C5057),
                      width: 1.0,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      QR.back();
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RangeData {
  final int start;
  final int end;
  final String label;
  final String level;
  RangeData(
      {required this.start,
      required this.end,
      required this.label,
      required this.level});
}

class DottedContainer extends StatelessWidget {
  const DottedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 1.0,
      child: DottedBorder(
        color: Colors.black,
        borderType: BorderType.RRect, // Use BorderType.RRect for bottom border
        strokeWidth: 1.0,
        dashPattern: const [4, 4], // Adjust the dashPattern as needed
        child: Container(), // Empty child
      ),
    );
  }
}
