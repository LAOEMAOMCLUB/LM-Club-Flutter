// htmlViewPage this page is used to show dynamic data as htmlView.

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HTMLView extends StatelessWidget {
  final String name;
  final String content;

  const HTMLView({
    Key? key,
    required this.name,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76.0),
        child: Container(
          // height: 76.0,
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
            elevation: 0,
            title: Text(name),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromRGBO(252, 254, 255, 1),
          padding: const EdgeInsets.all(20.0),
          child: Html(
            data: content,
            style: {
              "body": Style(
                color: const Color.fromRGBO(35, 44, 58, 1),
                fontSize: FontSize(14),
                fontWeight: FontWeight.w400,
                fontFamily: 'NeueHaasGroteskTextPro',
              ),
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 217, 215, 215),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  elevation: 4,
                ),
                child: const SizedBox(
                  height: 42,
                  child: Center(
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontFamily: "NeueHaasGroteskTextPro",
                        fontSize: 14,
                        color: Color.fromRGBO(35, 44, 58, 1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
