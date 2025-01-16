// import 'dart:io';

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lm_club/app/core/di/locator.dart';
// import 'package:lm_club/app/home/home.dart';
// //import 'package:lm_club/app/presentation/brodcast/post_success.dart';
// import 'package:lm_club/app/presentation/coupons/bloc/coupon_bloc.dart';
// import 'package:lm_club/app/presentation/coupons/bloc/coupon_state.dart';
// // import 'package:lm_club/constants/color_constants.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:searchfield/searchfield.dart';

// class AddCoupen extends StatefulWidget {
//   const AddCoupen({super.key});

//   @override
//   State<AddCoupen> createState() => _AddCoupenState();
// }

// class _AddCoupenState extends State<AddCoupen> {
//   XFile? image;
//   File? imageFile;
//   DateTime selectedDate = DateTime.now();

//   final ImagePicker picker = ImagePicker();
//   Future getImage(ImageSource media) async {
//     var img = await picker.pickImage(source: media);

//     setState(() {
//       image = img;
//     });
//     if (img != null) {
//       setState(() {
//         imageFile = File(img.path);
//       });
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         _couponsBloc.validUptoController.text =
//             picked.toString(); // Set the selected date in TextField
//       });
//     }
//   }

//   List<SearchFieldListItem<String>> suggestions = [
//     SearchFieldListItem("Dining"),
//     SearchFieldListItem("Coupouns/Deals"),
//     SearchFieldListItem("Events"),
//   ];

//   final CouponsBloc _couponsBloc = getIt.get<CouponsBloc>();

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (context) => _couponsBloc,
//         // ..fetchCategories(),
//         child:
//             BlocConsumer<CouponsBloc, CouponsState>(listener: (context, state) {
//           if (state.isSuccesful!) {
//             _couponsBloc.addCoupon(image!.path);
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => const Home()));
//             //_broadcastBloc.fetchBroadcasts();
//             // ScaffoldMessenger.of(context)
//             //     .showSnackBar(SnackBar(content: Text(state.error!)));
//           } else if (state.error!.isNotEmpty) {
//             ScaffoldMessenger.of(context).showSnackBar(
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
//           return Stack(children: [
//             Scaffold(
//               backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
//               appBar: PreferredSize(
//                 preferredSize: const Size.fromHeight(76.0),
//                 child: Container(
//                   padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
//                   alignment: Alignment.center,
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Color.fromRGBO(12, 57, 131, 1),
//                         Color.fromRGBO(0, 176, 80, 1),
//                       ],
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                     ),
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(25),
//                       bottomRight: Radius.circular(25),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color.fromRGBO(255, 255, 255, 1),
//                         blurRadius: 15.0,
//                         spreadRadius: 10.0,
//                       ),
//                     ],
//                   ),
//                   child: AppBar(
//                     backgroundColor: Colors.transparent,
//                     leading: IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     title: const Text(
//                       'Add Coupon',
//                       style: TextStyle(
//                         color: Color.fromRGBO(238, 238, 238, 1),
//                         fontSize: 16,
//                         fontFamily: 'NeueHaasGroteskTextPro',
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     centerTitle: false,
//                     elevation: 0,
//                   ),
//                 ),
//               ),
//               body: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 23, left: 23, top: 6.0),
//                   child: Form(
//                       key: _couponsBloc.webFormKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             // key: _newListingBloc.cityKey,
//                             child: SearchField(
//                               suggestionState: Suggestion.expand,
//                               suggestionAction: SuggestionAction.unfocus,
//                               suggestions: suggestions,
//                               // .map((states) =>
//                               //     SearchFieldListItem(states.name!,
//                               //         item: states.id,
//                               //         child: const Row(
//                               //           mainAxisAlignment:
//                               //               MainAxisAlignment.spaceBetween,
//                               //           children: [
//                               //             Padding(
//                               //               padding: EdgeInsets.only(
//                               //                   left: 19, right: 19),
//                               //               child: Center(
//                               //                 child: Text(
//                               //                   'Daining',
//                               //                   style: TextStyle(
//                               //                       fontFamily: 'Söhne',
//                               //                       fontSize: 14,
//                               //                       color: Color.fromRGBO(
//                               //                           35, 44, 58, 1)),
//                               //                 ),
//                               //               ),
//                               //             ),
//                               //           ],
//                               //         )))
//                               // .toList(),
//                               // validator: MultiValidator([
//                               //   RequiredValidator(
//                               //       errorText: 'Select Cate is Required'),
//                               // ]),
//                               textInputAction: TextInputAction.continueAction,
//                               // controller:,
//                               maxSuggestionsInViewPort: 4,
//                               itemHeight: 40,
//                               searchStyle: const TextStyle(
//                                 fontSize: 13,
//                                 color: Color.fromRGBO(35, 44, 58, 1),
//                                 fontFamily: 'NeueHaasGroteskTextPro',
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               searchInputDecoration: const InputDecoration(
//                                 // hintText: 'State',
//                                 labelText: 'State/Province/Region',
//                                 errorStyle: TextStyle(fontSize: 13.0),
//                                 labelStyle: TextStyle(
//                                   fontSize: 14,
//                                   color: Color.fromRGBO(116, 116, 116, 1),
//                                   fontFamily: 'NeueHaasGroteskTextPro',
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 hintStyle: TextStyle(
//                                   color: Color.fromRGBO(35, 44, 58, 1),
//                                   fontSize: 13,
//                                   fontFamily: 'NeueHaasGroteskTextPro',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Color.fromRGBO(184, 188, 204, 1),
//                                   ),
//                                 ),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Color.fromRGBO(184, 188, 204, 1),
//                                   ),
//                                 ),
//                                 suffixIcon: Icon(
//                                   Icons.arrow_drop_down_circle,
//                                   color: Color.fromRGBO(221, 221, 221, 1),
//                                   size: 20,
//                                 ),
//                               ),
//                               suggestionStyle: const TextStyle(
//                                 fontSize: 14,
//                                 fontFamily: 'NeueHaasGroteskTextPro',
//                                 color: Color.fromRGBO(35, 44, 58, 1),
//                               ),
//                               suggestionItemDecoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: Colors.grey,
//                                   width: 0.5,
//                                 ),
//                                 // borderRadius: BorderRadius.circular(8.0),
//                               ),
//                               // suggestionsDecoration: SuggestionDecoration(),
//                               onSuggestionTap: (x) {},
//                               onSubmit: (p0) {},
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: TextFormField(
//                               keyboardType: TextInputType.phone,
//                               controller: _couponsBloc.cNameController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Post Name',
//                                 hintText: 'Mcdonald',
//                                 errorStyle: TextStyle(fontSize: 18.0),
//                                 labelStyle: TextStyle(
//                                     fontSize: 14,
//                                     color: Color.fromRGBO(116, 116, 116, 1),
//                                     fontFamily: 'NeueHaasGroteskTextPro',
//                                     fontWeight: FontWeight.w500),
//                                 hintStyle: TextStyle(
//                                     color: Color.fromRGBO(35, 44, 58, 1),
//                                     fontSize: 13,
//                                     fontFamily: 'NeueHaasGroteskTextPro',
//                                     fontWeight: FontWeight.w400),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Color.fromRGBO(184, 188, 204, 1),
//                                   ),
//                                 ),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Color.fromRGBO(184, 188, 204, 1),
//                                   ),
//                                 ),
//                               ),
//                               style: const TextStyle(
//                                   color: Color.fromRGBO(35, 44, 58, 1),
//                                   fontSize: 13,
//                                   fontFamily: 'NeueHaasGroteskTextPro',
//                                   fontWeight: FontWeight.w400),
//                             ),
//                           ),
//                           Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: TextFormField(
//                                 keyboardType: TextInputType.name,
//                                 controller: _couponsBloc.descriptionController,
//                                 decoration: const InputDecoration(
//                                   hintText: 'Desc',
//                                   labelText: 'Description',
//                                   errorStyle: TextStyle(fontSize: 18.0),
//                                   labelStyle: TextStyle(
//                                     fontSize: 14,
//                                     color: Color.fromRGBO(116, 116, 116, 1),
//                                     fontFamily: 'NeueHaasGroteskTextPro',
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                   hintStyle: TextStyle(
//                                     color: Color.fromRGBO(35, 44, 58, 1),
//                                     fontSize: 13,
//                                     fontFamily: 'NeueHaasGroteskTextPro',
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                   enabledBorder: UnderlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: Color.fromRGBO(184, 188, 204, 1),
//                                     ),
//                                   ),
//                                   focusedBorder: UnderlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: Color.fromRGBO(184, 188, 204, 1),
//                                     ),
//                                   ),
//                                 ),
//                                 style: const TextStyle(
//                                   color: Color.fromRGBO(35, 44, 58, 1),
//                                   fontSize: 13,
//                                   fontFamily: 'NeueHaasGroteskTextPro',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               )),
//                           Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: TextFormField(
//                                 keyboardType: TextInputType.name,
//                                 controller: _couponsBloc.descriptionController,
//                                 decoration: const InputDecoration(
//                                   hintText: 'Coupen Code',
//                                   labelText: 'Coupen Code',
//                                   errorStyle: TextStyle(fontSize: 18.0),
//                                   labelStyle: TextStyle(
//                                     fontSize: 14,
//                                     color: Color.fromRGBO(116, 116, 116, 1),
//                                     fontFamily: 'NeueHaasGroteskTextPro',
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                   hintStyle: TextStyle(
//                                     color: Color.fromRGBO(35, 44, 58, 1),
//                                     fontSize: 13,
//                                     fontFamily: 'NeueHaasGroteskTextPro',
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                   enabledBorder: UnderlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: Color.fromRGBO(184, 188, 204, 1),
//                                     ),
//                                   ),
//                                   focusedBorder: UnderlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: Color.fromRGBO(184, 188, 204, 1),
//                                     ),
//                                   ),
//                                 ),
//                                 style: const TextStyle(
//                                   color: Color.fromRGBO(35, 44, 58, 1),
//                                   fontSize: 13,
//                                   fontFamily: 'NeueHaasGroteskTextPro',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               )),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: GestureDetector(
//                               onTap: () {
//                                 _selectDate(context);
//                               },
//                               child: AbsorbPointer(
//                                 child: TextFormField(
//                                   keyboardType: TextInputType.datetime,
//                                   controller: _couponsBloc.validUptoController,
//                                   decoration: const InputDecoration(
//                                     labelText: 'Valid Until',
//                                     // hintText: '31 Oct 2023',
//                                     errorStyle: TextStyle(fontSize: 18.0),
//                                     labelStyle: TextStyle(
//                                       fontSize: 14,
//                                       color: Color.fromRGBO(116, 116, 116, 1),
//                                       fontFamily: 'NeueHaasGroteskTextPro',
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     hintStyle: TextStyle(
//                                       color: Color.fromRGBO(35, 44, 58, 1),
//                                       fontSize: 13,
//                                       fontFamily: 'NeueHaasGroteskTextPro',
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: Color.fromRGBO(184, 188, 204, 1),
//                                       ),
//                                     ),
//                                     focusedBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: Color.fromRGBO(184, 188, 204, 1),
//                                       ),
//                                     ),

//                                     suffixIcon: Padding(
//                                       padding: EdgeInsets.only(right: 8.0),
//                                       // child: Image.asset(
//                                       //   "assets/images/note.png",
//                                       //   width: 10.0,
//                                       //   height: 10.0,
//                                       //   color: const Color.fromRGBO(
//                                       //       116, 116, 116, 1),
//                                       // ),
//                                       child: Icon(
//                                         Icons.calendar_today,
//                                         size: 20.0,
//                                         color: Color.fromRGBO(116, 116, 116, 1),
//                                       ),
//                                     ),
//                                   ),
//                                   style: const TextStyle(
//                                     color: Color.fromRGBO(35, 44, 58, 1),
//                                     fontSize: 13,
//                                     fontFamily: 'NeueHaasGroteskTextPro',
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               'Image',
//                               style: TextStyle(
//                                 color: Color.fromRGBO(116, 116, 116, 1),
//                                 fontSize: 13,
//                                 fontFamily: 'NeueHaasGroteskTextPro',
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   getImage(ImageSource.gallery);
//                                   _couponsBloc.uploadImage(
//                                       imageFile, image!.path);
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   width: MediaQuery.of(context).size.width,
//                                   height: 45.0,
//                                   child: DottedBorder(
//                                     borderType: BorderType.RRect,
//                                     radius: const Radius.circular(10),
//                                     dashPattern: const [6, 4],
//                                     color: const Color.fromRGBO(55, 74, 156, 1),
//                                     strokeWidth: 1,
//                                     child: Align(
//                                       alignment: Alignment.center,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: <Widget>[
//                                           Image.asset(
//                                             "assets/images/camera.png",
//                                             width: 23.0,
//                                             height: 23.0,
//                                             color: const Color.fromRGBO(
//                                                 55, 74, 156, 1),
//                                           ),
//                                           const SizedBox(width: 10),
//                                           const Text(
//                                             "Take a photo",
//                                             style: TextStyle(
//                                               fontSize: 12.0,
//                                               fontFamily:
//                                                   'NeueHaasGroteskTextPro',
//                                               color: Color.fromRGBO(
//                                                   55, 74, 156, 1),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )),
//                           const Center(
//                             child: Text(
//                               "OR",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontFamily: 'NeueHaasGroteskTextPro',
//                                 color: Color.fromRGBO(170, 170, 170, 1),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   getImage(ImageSource.gallery);
//                                   _couponsBloc.uploadImage(
//                                       imageFile, image!.path);
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   width: MediaQuery.of(context).size.width,
//                                   height: 80.0,
//                                   child: DottedBorder(
//                                     borderType: BorderType.RRect,
//                                     radius: const Radius.circular(10),
//                                     dashPattern: const [6, 4],
//                                     color: const Color.fromRGBO(55, 74, 156, 1),
//                                     strokeWidth: 1,
//                                     child: Align(
//                                       alignment: Alignment.center,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: <Widget>[
//                                           Image.asset(
//                                             "assets/images/upload.png",
//                                             width: 23.0,
//                                             height: 23.0,
//                                             color: const Color.fromRGBO(
//                                                 55, 74, 156, 1),
//                                           ),
//                                           const SizedBox(
//                                             height: 4.0,
//                                           ),
//                                           const Text(
//                                             "Upload Photo / Video",
//                                             style: TextStyle(
//                                               fontSize: 12.0,
//                                               fontFamily:
//                                                   'NeueHaasGroteskTextPro',
//                                               color: Color.fromRGBO(
//                                                   55, 74, 156, 1),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )),
//                           const SizedBox(height: 8.0),
//                           Center(
//                             child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 8.0),
//                                 child: imageFile != null
//                                     ? Stack(
//                                         children: [
//                                           ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(10.0),
//                                             child: Container(
//                                               width: 70,
//                                               height: 65,
//                                               decoration: const BoxDecoration(
//                                                 shape: BoxShape.rectangle,
//                                               ),
//                                               child: Image.file(
//                                                 imageFile!,
//                                                 fit: BoxFit.fill,
//                                               ),
//                                             ),
//                                           ),
//                                           Positioned(
//                                             top: -17,
//                                             right: -17,
//                                             child: IconButton(
//                                               onPressed: () {
//                                                 setState(() {
//                                                   // imageFile = File('');
//                                                 });
//                                               },
//                                               icon: const Icon(Icons.cancel),
//                                               iconSize: 16.0,
//                                               color: Colors.red,
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                     : const SizedBox()),
//                           )
//                         ],
//                       )),
//                 ),
//               ),
//               bottomNavigationBar: BottomAppBar(
//                 color: const Color.fromRGBO(255, 255, 255, 1),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(vertical: 30),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           _couponsBloc.addCoupon(image!.path);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color.fromRGBO(55, 74, 156, 1),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(3.0),
//                           ),
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           elevation: 4,
//                         ),
//                         child: const SizedBox(
//                           width: 290,
//                           height: 42,
//                           child: Center(
//                             child: Text(
//                               'Add Coupon',
//                               style: TextStyle(
//                                   fontFamily: "NeueHaasGroteskTextPro",
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             if (state.isLoading)
//               Container(
//                 color: Colors.transparent
//                     .withOpacity(0.2), // Semi-transparent black overlay
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       LoadingAnimationWidget.hexagonDots(
//                         size: 35,
//                         color: Colors.blue,
//                       ),
//                       const SizedBox(height: 10), // Adjust spacing if needed
//                       const Text(
//                         'Loading, please wait ...',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontFamily: 'NeueHaasGroteskTextPro',
//                             decoration: TextDecoration.none),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ]);
//         }));
//   }
// }
