
// SuccessBeehivePost once Post created and posted this poupPage shows

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'package:lm_club/routes/app_routes.dart';

class BeehiveSuccessPost extends StatefulWidget {
  const BeehiveSuccessPost({Key? key}) : super(key: key);
  @override
  State<BeehiveSuccessPost> createState() => _BeehiveSuccessPost();
}

class _BeehiveSuccessPost extends State<BeehiveSuccessPost> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      var isBeehiveExisted = QR.history.entries
          .where((i) => i.path == Routes.BEEHIVE)
          .toList()
          .isNotEmpty;
      if (isBeehiveExisted) {
        QR.to(Routes.BEEHIVE);
      } else {
        QR.navigator.removeLast();
        QR.navigator.replace(Routes.ADD_BEEHIVE, Routes.BEEHIVE);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/Success.png',
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 15),
            const Flexible(
              child: Text(
                'Post Created Successful,Waiting for Approval !',
                style: TextStyle(
                  fontFamily: 'NeueHaasGroteskTextPro',
                  color: Color.fromRGBO(10, 116, 58, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
