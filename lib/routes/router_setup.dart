// // routesSetupPage when navigate to other page and page not found (this page will displayed)

// import 'package:flutter/material.dart';
// import 'package:qlevar_router/qlevar_router.dart';

// class RouteSetup {
//   static void setup() {
//     QR.settings.enableDebugLog = true;
//     QR.settings.notFoundPage = QRoute(
//       path: 'path',
//       builder: () => const Scaffold(
//         body: Center(
//           child: Text(
//             "No Page Found",
//           ),
//         ),
//       ),
//     );
//     debugPrint(QR.history.entries.toList().toString());
//     QR.observer.onNavigate.add((path, route) async {
//       debugPrint('Observer: Navigating to $path'); //comment this in prod
//     });

//     QR.observer.onPop.add((path, route) async {
//       debugPrint('Observer: popping out from $path'); //comment this in prod
//     });
//     QR.settings.pagesType = const QFadePage();
//   }
// }
