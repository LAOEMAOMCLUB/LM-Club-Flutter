// BroadCastpostSuccessPage once Post created and posted this poupPage shows

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'dart:async';
import '../../../routes/app_routes.dart';

class PostSuccess extends StatefulWidget {
  const PostSuccess({Key? key}) : super(key: key);
  @override
  State<PostSuccess> createState() => _PostSuccessState();
}

class _PostSuccessState extends State<PostSuccess> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      // QR.to(Routes.BROADCAST);
      var broadCastExist = QR.history.entries
          .where((element) => element.path == Routes.MY_POSTS)
          .toList()
          .isNotEmpty;

      if (broadCastExist) {
        QR.to(Routes.MY_POSTS);
      } else {
        QR.navigator.removeLast();
        QR.navigator.removeLast();
        QR.navigator.replace(Routes.BUSINESS_CREATE_POST, Routes.MY_POSTS);
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
            const SizedBox(height: 20),
            const Flexible(
              child: Text(
                'Post Created Successful,Waiting for Approval !',
                style: TextStyle(
                  fontFamily: 'NeueHaasGroteskTextPro',
                  color: Color.fromRGBO(10, 116, 58, 1),
                  fontSize: 16,
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
