// import 'package:flutter/material.dart';
// import 'package:lm_club/app/presentation/add_widget/scratch.dart';
// import 'package:lm_club/constants/color_constants.dart';

// class AddWidget extends StatefulWidget {
//   const AddWidget({Key? key}) : super(key: key);

//   @override
//   State<AddWidget> createState() => _AddWidgetState();
// }

// class Item {
//   String text;
//   bool light;

//   Item({required this.text, required this.light});
// }

// class _AddWidgetState extends State<AddWidget> {
//   List<Item> items1 = [
//     Item(text: "Network", light: false),
//     Item(text: "E - store", light: true),
//     Item(text: "Beehive", light: false),
//     Item(text: "Broadcast", light: false),
//   ];

//   List<Item> items2 = [
//     Item(text: "Network", light: true),
//     Item(text: "Money Club", light: false),
//     Item(text: "Lounge", light: true),
//     Item(text: "Buy/sell", light: false),
//     Item(text: "Contest", light: true),
//   ];

//   bool light = true;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: ColorCons.appBG,
//         appBar: AppBar(
//           centerTitle: false,
//           backgroundColor: ColorCons.appBG,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             padding: EdgeInsets.zero,
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: const Text(
//             'Select your widgets and get Surprised !',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontFamily: 'NeueHaasGroteskTextPro',
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: items1.length,
//                   itemBuilder: (context, index) {
//                     final item = items1[index];
//                     return Container(
//                       margin: const EdgeInsets.symmetric(vertical: 8.0),
//                       padding: const EdgeInsets.fromLTRB(16, 10, 20, 16),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         gradient: const LinearGradient(
//                           colors: [
//                             Color.fromRGBO(147, 196, 113, 0.12),
//                             Color.fromRGBO(75, 116, 48, 0.12),
//                           ],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                         ),
//                         border: Border.all(
//                           color: const Color.fromRGBO(220, 220, 59, 0.12),
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 item.text,
//                                 style: const TextStyle(
//                                   fontSize: 13.0,
//                                   color: Color.fromRGBO(238, 238, 238, 1),
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: 'NeueHaasGroteskTextPro',
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Container(
//                                     height: 20,
//                                     width: 2,
//                                     color: const Color.fromRGBO(65, 65, 65, 1),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   const Text(
//                                     'Select widget',
//                                     style: TextStyle(
//                                       fontSize: 12.0,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color.fromRGBO(147, 196, 113, 1),
//                                       fontFamily: 'NeueHaasGroteskTextPro',
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Container(
//                                     height: 27,
//                                     width: 46,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(18),
//                                       color: item.light
//                                           ? const Color.fromRGBO(0, 176, 80, 1)
//                                           : const Color.fromRGBO(65, 65, 65, 1),
//                                     ),
//                                     child: Switch(
//                                       value: item.light,
//                                       onChanged: (bool value) {
//                                         setState(() {
//                                           item.light = value;
//                                         });
//                                       },
//                                       activeColor: Colors.transparent,
//                                       activeTrackColor: Colors.transparent,
//                                       inactiveThumbColor: Colors.transparent,
//                                       inactiveTrackColor: Colors.transparent,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: items2.length,
//                   itemBuilder: (context, index) {
//                     final item = items2[index];
//                     return Container(
//                       margin: const EdgeInsets.symmetric(vertical: 8.0),
//                       padding: const EdgeInsets.fromLTRB(16, 10, 20, 16),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         gradient: const LinearGradient(
//                           colors: [
//                             Color.fromRGBO(147, 196, 113, 0.12),
//                             Color.fromRGBO(75, 116, 48, 0.12),
//                           ],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                         ),
//                         border: Border.all(
//                           color: const Color.fromRGBO(220, 220, 59, 0.12),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             item.text,
//                             style: const TextStyle(
//                               fontSize: 13.0,
//                               color: Color.fromRGBO(238, 238, 238, 1),
//                               fontWeight: FontWeight.bold,
//                               fontFamily: 'NeueHaasGroteskTextPro',
//                             ),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   const Color.fromRGBO(223, 107, 29, 1),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3.0),
//                               ),
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10),
//                               elevation: 0,
//                             ),
//                             child: const Text(
//                               'Upgrade',
//                               style: TextStyle(
//                                 fontSize: 12.0,
//                                 color: Colors.white,
//                                 fontFamily: 'NeueHaasGroteskTextPro',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: BottomAppBar(
//           color: const Color.fromRGBO(
//               27, 27, 27, 1), 
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 30),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const Scratch(),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         const Color.fromRGBO(148, 197, 115, 1),
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(15.0),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10), 
//                     elevation: 4, 
//                   ),
//                   child: const SizedBox(
//                     width: 290,
//                     height: 42,
//                     child: Center(
//                       child: Text(
//                         'Continue',
//                         style: TextStyle(
//                             fontFamily: "NeueHaasGroteskTextPro",
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
