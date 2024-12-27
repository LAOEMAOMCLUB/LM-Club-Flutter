// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lm_club/app/core/di/locator.dart';
// //import 'package:lm_club/app/presentation/brodcast/post_success.dart';
// import 'package:lm_club/app/presentation/coupons/bloc/coupon_bloc.dart';
// import 'package:lm_club/app/presentation/coupons/bloc/coupon_state.dart';
// //import 'package:lm_club/app/presentation/coupons/coupon.dart';
// import 'package:lm_club/constants/color_constants.dart';

// class SelectCategories extends StatefulWidget {
//   const SelectCategories({Key? key}) : super(key: key);

//   @override
//   State<SelectCategories> createState() => _SelectCategoriesState();
// }

// class _SelectCategoriesState extends State<SelectCategories> {
//   final CouponsBloc _couponsBloc = getIt.get<CouponsBloc>();
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (context) => _couponsBloc..fetchCategories(),
//         // ..fetchCoupons(),
//         child:
//             BlocConsumer<CouponsBloc, CouponsState>(listener: (context, state) {
//           if (state.isSuccesful!) {
//             // Navigator.push(context,
//             //     MaterialPageRoute(builder: (context) => const PostSuccess()));

//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text(state.error!)));
//           } else if (state.error!.isNotEmpty) {
//               ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 backgroundColor:
//                     Colors.red, // Change background color of SnackBar
//                 content: Center(
//                   child: Text(
//                     state.error!,
//                     style: const TextStyle(
//                       color:
//                           Colors.white, // Change text color of SnackBar content
//                       fontSize: 16, // Change font size of SnackBar content
//                       // Add other text styles as needed
//                     ),
//                   ),
//                 ),
//                 duration:
//                     const Duration(seconds: 3), // Adjust duration as needed
//               ),
//             );
//           }
//         }, builder: (context, state) {
//           return MaterialApp(
//               debugShowCheckedModeBanner: false,
//               home: Scaffold(
//                   backgroundColor: ColorCons.appBG,
//                   appBar: AppBar(
//                     centerTitle: false,
//                     backgroundColor: ColorCons.appBG,
//                     leading: IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.white),
//                       padding: EdgeInsets.zero,
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     title: Text(
//                       'Select Categories',
//                       style: TextStyle(
//                           color: ColorCons.textGreen,
//                           fontSize: 16,
//                           fontFamily: 'NeueHaasGroteskTextPro',
//                           fontWeight: FontWeight.bold),
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () {},
//                         style: TextButton.styleFrom(
//                             foregroundColor: ColorCons.appBG),
//                         child: const Text(
//                           'Select All',
//                           style: TextStyle(
//                               color: Color.fromRGBO(187, 187, 187, 1),
//                               fontFamily: 'NeueHaasGroteskTextPro',
//                               fontSize: 14),
//                         ),
//                       ),
//                     ],
//                   ),
//                   body:
//                   //  GridView.builder(
//                   //   gridDelegate:
//                   //       const SliverGridDelegateWithFixedCrossAxisCount(
//                   //     crossAxisCount: 2, // Number of columns
//                   //     crossAxisSpacing: 10.0, // Spacing between columns
//                   //     mainAxisSpacing: 10.0, // Spacing between rows
//                   //   ),
//                   //   itemCount: state.categories.length, // Total number of items
//                   //   itemBuilder: (BuildContext context, int index) {
//                   //     // itemBuilder builds each item in the grid
//                   //     return Container(
//                   //       color: Colors
//                   //           .blue, // Just an example, you can use any widget here
//                   //       child: Center(
//                   //         child: Text(
//                   //           state.categories[index].category,
//                   //           style: const TextStyle(
//                   //             color: Colors.white,
//                   //             fontSize: 18.0,
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     );
//                   //   },
//                   // )
//                   //   
                  
//                    GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2, // Number of columns
//                       crossAxisSpacing: 10.0, // Spacing between columns
//                       mainAxisSpacing: 10.0, // Spacing between rows
//                     ),
//                     itemCount: 9, // Total number of items
//                     itemBuilder: (BuildContext context, int index)  =>
//                                    Expanded(
//                                     child: InkWell(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                       onTap: () {
//                                       },
//                                       child: Stack(
//                                         children: <Widget>[
//                                           ClipRRect(
//                                             borderRadius: BorderRadius.circular(10.0),
//                                             child: Container(
//                                               width: double
//                                                   .infinity,
//                                               height: 88,
//                                               decoration: const BoxDecoration(
//                                                 shape: BoxShape.rectangle,
//                                               ),
//                                               child: Image.asset(
//                                                 'assets/images/FashionClothing.jpg',
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                           Positioned.fill(
//                                             left: 0,
//                                             top: 0,
//                                             right: 0,
//                                             bottom: 0,
//                                             child: Container(
//                                               padding: const EdgeInsets.all(8),
//                                               decoration: BoxDecoration(
//                                                 color: const Color.fromRGBO(
//                                                     74, 63, 53, 0.76),
//                                                 borderRadius: BorderRadius.circular(10.0),
//                                               ),
//                                               child:  const Center(
//                                                 child: Text(
//                                                  // state.categories[index].category
//                                                  '',
//                                                   style: TextStyle(
//                                                     fontFamily: 'NeueHaasGroteskTextPro',
//                                                     color: Colors.white,
//                                                     fontSize: 13.0,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
                                   
//                               ),
                  
//                         //           const SizedBox(
//                         //             width: 20,
//                         //           ),
//                         //           Expanded(
//                         //             child: Container(),
                       
//                         // BottomAppBar(
//                         //   color: Colors.transparent,
//                         //   child:Container(
//                         //               padding:const EdgeInsets.fromLTRB(20, 0, 20, 0),
//                         //   child: ElevatedButton(
//                         //     onPressed: () {
//                         //       Navigator.pop(context);
//                         //       Navigator.push(
//                         //           context,
//                         //           MaterialPageRoute(
//                         //               builder: (context) => const Coupon()));
//                         //     },
//                         //     style: ButtonStyle(
//                         //       backgroundColor:
//                         //           MaterialStateProperty.all<Color>(Colors.transparent),
//                         //       elevation: MaterialStateProperty.all<double>(0),
//                         //       overlayColor:
//                         //           MaterialStateProperty.all<Color>(Colors.transparent),
//                         //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         //         RoundedRectangleBorder(
//                         //           borderRadius: BorderRadius.circular(
//                         //               34.0),
//                         //         ),
//                         //       ),
//                         //     ),
//                         //     child: Ink(
//                         //       decoration: BoxDecoration(
//                         //         gradient: const LinearGradient(
//                         //           colors: [Color(0xFF93C471), Color(0xFF4B742F)],
//                         //           begin: Alignment.topCenter,
//                         //           end: Alignment.bottomCenter,
//                         //         ),
//                         //         borderRadius: BorderRadius.circular(34.0),
//                         //       ),
//                         //       child: Container(
//                         //         width: double.infinity,
//                         //         padding: const EdgeInsets.all(11),
//                         //         alignment: Alignment.center,
//                         //         child: const Text(
//                         //           'Continue',
//                         //           style: TextStyle(
//                         //             color: Colors.white,
//                         //             fontSize: 14.0,
//                         //             fontFamily: 'NeueHaasGroteskTextPro',
//                         //           ),
//                         //         ),
//                         //       ),
//                         //     ),
//                         //   ),)
//                         // ),
                     
//                     ),
//           );}
//                   ));
//         }
// }