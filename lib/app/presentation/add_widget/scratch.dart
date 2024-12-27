import 'package:flutter/material.dart';
import 'package:lm_club/app/home/home.dart';

class Scratch extends StatefulWidget {
  const Scratch({Key? key}) : super(key: key);

  @override
  State<Scratch> createState() => _ScratchState();
}

class _ScratchState extends State<Scratch> {
  bool showContainer = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showContainer = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 0.9;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(76, 100, 60, 1),
                    Color.fromRGBO(27, 27, 27, 1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                    spreadRadius: 3,
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !showContainer,
                    child: Image.asset('assets/images/box.png'),
                  ),
                  if (showContainer)
                    Container(
                      width: containerWidth,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/bg.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/box-top.png'),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Congratulations',
                            style: TextStyle(
                              color: Color.fromRGBO(236, 177, 0, 1),
                              fontSize: 32,
                              fontFamily: 'NeueHaasGroteskTextPro',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const Text(
                            'You won a ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'NeueHaasGroteskTextPro',
                                fontWeight: FontWeight.normal),
                          ),
                          const Text(
                            'Scratch Card !',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'NeueHaasGroteskTextPro',
                                fontWeight: FontWeight.bold),
                          ),
                          Image.asset('assets/images/box-bottom.png'),
                          const SizedBox(
                            height: 90,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Home(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(148, 197, 115, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              elevation: 4,
                            ),
                            child: const SizedBox(
                              width: 150,
                              height: 42,
                              child: Center(
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                      fontFamily: "NeueHaasGroteskTextPro",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
