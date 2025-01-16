// import 'package:flutter/material.dart';

// class BusinessReward extends StatefulWidget {
//   const BusinessReward({Key? key}) : super(key: key);

//   @override
//   State<BusinessReward> createState() => _BusinessRewardState();
// }

// class _BusinessRewardState extends State<BusinessReward> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(76.0),
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
//           alignment: Alignment.center,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color.fromRGBO(12, 57, 131, 1),
//                 Color.fromRGBO(0, 176, 80, 1),
//               ],
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(25),
//               bottomRight: Radius.circular(25),
//             ),
//           ),
//           child: AppBar(
//             backgroundColor: Colors.transparent,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.white),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             title: const Text(
//               'Rewards',
//               style: TextStyle(
//                 color: Color.fromRGBO(238, 238, 238, 1),
//                 fontSize: 16,
//                 fontFamily: 'NeueHaasGroteskTextPro',
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             centerTitle: false,
//             elevation: 0,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
//             decoration: BoxDecoration(
//               color: const Color.fromRGBO(208, 231, 250, 1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Image.asset(
//                             "assets/images/coin.png",
//                             width: 20,
//                             height: 20,
//                           ),
//                           const SizedBox(
//                             width: 3.5,
//                           ),
//                           const Text(
//                             "577",
//                             style: TextStyle(
//                               color: Color.fromRGBO(55, 74, 156, 1),
//                               fontSize: 28,
//                               fontFamily: 'NeueHaasGroteskTextPro',
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 8,
//                       ),
//                       const Text(
//                         "Total Coin Balance",
//                         style: TextStyle(
//                           color: Color.fromRGBO(55, 74, 156, 1),
//                           fontSize: 12,
//                           fontFamily: 'NeueHaasGroteskTextPro',
//                           fontWeight: FontWeight.w300,
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Image.asset(
//                   "assets/images/rewards_bg.png",
//                   height: 84,
//                 )
//               ],
//             ),
//           ),
//           Expanded(
//             child: DefaultTabController(
//                 length: 3,
//                 child: Container(
//                   margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//                   child: Column(children: [
//                     const TabBar(
//                       tabs: [
//                         Tab(
//                             child: Text(
//                           "Broadcast",
//                           style: TextStyle(
//                             color: Color.fromRGBO(55, 74, 156, 1),
//                             fontSize: 10,
//                             fontFamily: 'NeueHaasGroteskTextPro',
//                             fontWeight: FontWeight.normal,
//                           ),
//                         )),
//                       ],
//                       indicator: BoxDecoration(
//                         border: Border(
//                           bottom: BorderSide(
//                             color: Color.fromRGBO(55, 74, 156, 1),
//                             width: 3.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TabBarView(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     width: double.infinity,
//                                     margin:
//                                         const EdgeInsets.symmetric(vertical: 5),
//                                     padding: const EdgeInsets.all(12.0),
//                                     decoration: BoxDecoration(
//                                       color: const Color.fromRGBO(
//                                           240, 240, 240, 1),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                             padding: const EdgeInsets.fromLTRB(
//                                                 0, 0, 0, 0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Image.asset(
//                                                   "assets/images/coin.png",
//                                                   width: 20,
//                                                   height: 20,
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 const Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       '100',
//                                                       style: TextStyle(
//                                                         color: Color.fromRGBO(
//                                                             35, 44, 58, 1),
//                                                         fontSize: 16.0,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         fontFamily:
//                                                             'NeueHaasGroteskTextPro',
//                                                       ),
//                                                       textAlign: TextAlign.left,
//                                                     ),
//                                                     SizedBox(
//                                                       height: 2,
//                                                     ),
//                                                     Text(
//                                                       'Deal of the day unlocked Reward',
//                                                       style: TextStyle(
//                                                         color: Color.fromRGBO(
//                                                             113, 113, 113, 1),
//                                                         fontSize: 8,
//                                                         fontFamily:
//                                                             'NeueHaasGroteskTextPro',
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             )),
//                                         const Text(
//                                           "23rd Nov",
//                                           style: TextStyle(
//                                             color: Color.fromRGBO(
//                                                 113, 113, 113, 1),
//                                             fontSize: 8,
//                                             fontFamily:
//                                                 'NeueHaasGroteskTextPro',
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width: double.infinity,
//                                     margin:
//                                         const EdgeInsets.symmetric(vertical: 5),
//                                     padding: const EdgeInsets.all(12.0),
//                                     decoration: BoxDecoration(
//                                       color: const Color.fromRGBO(
//                                           240, 240, 240, 1),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                             padding: const EdgeInsets.fromLTRB(
//                                                 0, 0, 0, 0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Image.asset(
//                                                   "assets/images/coin.png",
//                                                   width: 20,
//                                                   height: 20,
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 const Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       '120',
//                                                       style: TextStyle(
//                                                         color: Color.fromRGBO(
//                                                             35, 44, 58, 1),
//                                                         fontSize: 16.0,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         fontFamily:
//                                                             'NeueHaasGroteskTextPro',
//                                                       ),
//                                                       textAlign: TextAlign.left,
//                                                     ),
//                                                     SizedBox(
//                                                       height: 2,
//                                                     ),
//                                                     Text(
//                                                       'Deal of the day unlocked Reward',
//                                                       style: TextStyle(
//                                                         color: Color.fromRGBO(
//                                                             113, 113, 113, 1),
//                                                         fontSize: 8,
//                                                         fontFamily:
//                                                             'NeueHaasGroteskTextPro',
//                                                       ),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       maxLines: 1,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             )),
//                                         const Text(
//                                           "23rd Nov",
//                                           style: TextStyle(
//                                             color: Color.fromRGBO(
//                                                 113, 113, 113, 1),
//                                             fontSize: 8,
//                                             fontFamily:
//                                                 'NeueHaasGroteskTextPro',
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width: double.infinity,
//                                     margin:
//                                         const EdgeInsets.symmetric(vertical: 5),
//                                     padding: const EdgeInsets.all(12.0),
//                                     decoration: BoxDecoration(
//                                       color: const Color.fromRGBO(
//                                           240, 240, 240, 1),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                             padding: const EdgeInsets.fromLTRB(
//                                                 0, 0, 0, 0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Image.asset(
//                                                   "assets/images/coin.png",
//                                                   width: 20,
//                                                   height: 20,
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 const Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       '40',
//                                                       style: TextStyle(
//                                                         color: Color.fromRGBO(
//                                                             35, 44, 58, 1),
//                                                         fontSize: 16.0,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         fontFamily:
//                                                             'NeueHaasGroteskTextPro',
//                                                       ),
//                                                       textAlign: TextAlign.left,
//                                                     ),
//                                                     SizedBox(
//                                                       height: 2,
//                                                     ),
//                                                     Text(
//                                                       'Redemption of 1 Month Subscription of Zee5 249',
//                                                       style: TextStyle(
//                                                         color: Color.fromRGBO(
//                                                             113, 113, 113, 1),
//                                                         fontSize: 8,
//                                                         fontFamily:
//                                                             'NeueHaasGroteskTextPro',
//                                                       ),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       maxLines: 1,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             )),
//                                         const Text(
//                                           "23rd Nov",
//                                           style: TextStyle(
//                                             color: Color.fromRGBO(
//                                                 113, 113, 113, 1),
//                                             fontSize: 8,
//                                             fontFamily:
//                                                 'NeueHaasGroteskTextPro',
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width: double.infinity,
//                                     margin:
//                                         const EdgeInsets.symmetric(vertical: 5),
//                                     padding: const EdgeInsets.all(12.0),
//                                     decoration: BoxDecoration(
//                                       color: const Color.fromRGBO(
//                                           240, 240, 240, 1),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                             padding: const EdgeInsets.fromLTRB(
//                                                 0, 0, 0, 0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Image.asset(
//                                                   "assets/images/coin.png",
//                                                   width: 20,
//                                                   height: 20,
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 const Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       '100',
//                                                       style: TextStyle(
//                                                         color: Color.fromRGBO(
//                                                             35, 44, 58, 1),
//                                                         fontSize: 16.0,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         fontFamily:
//                                                             'NeueHaasGroteskTextPro',
//                                                       ),
//                                                       textAlign: TextAlign.left,
//                                                     ),
//                                                     SizedBox(
//                                                       height: 2,
//                                                     ),
//                                                     Text(
//                                                       'Deal of the day unlocked Reward',
//                                                       style: TextStyle(
//                                                         color: Color.fromRGBO(
//                                                             113, 113, 113, 1),
//                                                         fontSize: 8,
//                                                         fontFamily:
//                                                             'NeueHaasGroteskTextPro',
//                                                       ),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       maxLines: 1,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             )),
//                                         const Text(
//                                           "23rd Nov",
//                                           style: TextStyle(
//                                             color: Color.fromRGBO(
//                                                 113, 113, 113, 1),
//                                             fontSize: 8,
//                                             fontFamily:
//                                                 'NeueHaasGroteskTextPro',
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width: double.infinity,
//                                     margin: const EdgeInsets.symmetric(
//                                         vertical: 10),
//                                     padding: const EdgeInsets.all(12.0),
//                                     decoration: BoxDecoration(
//                                       color: const Color.fromRGBO(
//                                           240, 240, 240, 1),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                             padding: const EdgeInsets.fromLTRB(
//                                                 0, 0, 0, 0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Image.asset(
//                                                   "assets/images/coin.png",
//                                                   width: 20,
//                                                   height: 20,
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 const Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       '30',
//                                                       style: TextStyle(
//                                                         color: Color.fromRGBO(
//                                                             35, 44, 58, 1),
//                                                         fontSize: 16.0,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         fontFamily:
//                                                             'NeueHaasGroteskTextPro',
//                                                       ),
//                                                       textAlign: TextAlign.left,
//                                                     ),
//                                                     SizedBox(
//                                                       height: 2,
//                                                     ),
//                                                     Text(
//                                                       'Deal of the day unlocked Reward',
//                                                       style: TextStyle(
//                                                         color: Color.fromRGBO(
//                                                             113, 113, 113, 1),
//                                                         fontSize: 8,
//                                                         fontFamily:
//                                                             'NeueHaasGroteskTextPro',
//                                                       ),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       maxLines: 1,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             )),
//                                         const Text(
//                                           "23rd Nov",
//                                           style: TextStyle(
//                                             color: Color.fromRGBO(
//                                                 113, 113, 113, 1),
//                                             fontSize: 8,
//                                             fontFamily:
//                                                 'NeueHaasGroteskTextPro',
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width: double.infinity,
//                                     margin:
//                                         const EdgeInsets.symmetric(vertical: 5),
//                                     padding: const EdgeInsets.all(12.0),
//                                     decoration: BoxDecoration(
//                                       color: const Color.fromRGBO(
//                                           240, 240, 240, 1),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                             padding: const EdgeInsets.fromLTRB(
//                                                 0, 0, 0, 0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Image.asset(
//                                                   "assets/images/coin.png",
//                                                   width: 20,
//                                                   height: 20,
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 const Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       '100',
//                                                       style: TextStyle(
//                                                         color: Color.fromRGBO(
//                                                             35, 44, 58, 1),
//                                                         fontSize: 16.0,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         fontFamily:
//                                                             'NeueHaasGroteskTextPro',
//                                                       ),
//                                                       textAlign: TextAlign.left,
//                                                     ),
//                                                     SizedBox(
//                                                       height: 2,
//                                                     ),
//                                                     Text(
//                                                       'Deal of the day unlocked Reward',
//                                                       style: TextStyle(
//                                                         color: Color.fromRGBO(
//                                                             113, 113, 113, 1),
//                                                         fontSize: 8,
//                                                         fontFamily:
//                                                             'NeueHaasGroteskTextPro',
//                                                       ),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       maxLines: 1,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             )),
//                                         const Text(
//                                           "23rd Nov",
//                                           style: TextStyle(
//                                             color: Color.fromRGBO(
//                                                 113, 113, 113, 1),
//                                             fontSize: 8,
//                                             fontFamily:
//                                                 'NeueHaasGroteskTextPro',
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ]),
//                 )),
//           )
//         ],
//       ),
//     );
//   }
// }
