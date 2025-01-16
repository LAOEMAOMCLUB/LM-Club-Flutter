// SplashPage here we show splash screens 

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:lm_club/routes/app_routes.dart';
import 'package:qlevar_router/qlevar_router.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _Splashtate();
}

class _Splashtate extends State<Splash> {
  final List<String> images = [
    "assets/images/secondPage.png",
    "assets/images/pageThree.png",
    "assets/images/fourthPage.png",
    "assets/images/pageFive.png",
    "assets/images/pageSix.png",
    "assets/images/pageSeven.png",
  ];

  int _currentIndex = 0;
  bool _isLastPage = false;
  double _logoTopPosition = 350.0;
  final slider.CarouselSliderController _carouselController =
      slider.CarouselSliderController();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _currentIndex = 1;
      });
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _currentIndex = 0;
        _animateLogo();
      });
    });
  }

  void _animateLogo() {
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        _logoTopPosition = 70.0;
        if (_logoTopPosition <= 0) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/splash.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (_currentIndex > 0)
            slider.CarouselSlider(
              carouselController: _carouselController,
              items: images.map((image) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
              options: slider.CarouselOptions(
                autoPlay: true,
                pauseAutoPlayInFiniteScroll: true,
                height: double.infinity,
                autoPlayCurve: Curves.easeIn,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 700),
                pauseAutoPlayOnTouch: false,
                aspectRatio: 0.5,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index + 1;
                    _isLastPage = index == images.length - 2;
                    if (_isLastPage) {
                      Timer(const Duration(seconds: 1), () {
                        QR.to(Routes.GETSTARTED);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const GetStarted()),
                        // );
                      });
                    }
                  });
                },
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            top: _logoTopPosition,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/logo1.png",
              width: 113,
              height: 65,
              alignment: Alignment.center,
            ),
          ),
          // if (_currentIndex > 0)
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: _buildDots(images.length),
          ),
          // if (_currentIndex > 0)
          Positioned(
            bottom: 19.0,
            right: 16.0,
            child: _buildEndText(),
          ),
        ],
      ),
    );
  }

  Widget _buildDots(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return Container(
          width: 10.0,
          height: 10.0,
          margin: const EdgeInsets.symmetric(horizontal: 6.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1.0,
            ),
            shape: BoxShape.circle,
            color: index == _currentIndex
                ? const Color.fromRGBO(0, 176, 80, 1)
                : Colors.transparent,
          ),
        );
      }),
    );
  }

  Widget _buildEndText() {
    return GestureDetector(
      onTap: () {
        if (_currentIndex < images.length - 1) {
          _carouselController.nextPage();
        } else {
          // Navigator.push(
          //   context,
          //   PageRouteBuilder(
          //     pageBuilder: (context, animation, secondaryAnimation) =>
          //         const GetStarted(),
          //     transitionsBuilder:
          //         (context, animation, secondaryAnimation, child) {
          //       const begin = Offset(1.0, 0.0);
          //       const end = Offset.zero;
          //       const curve = Curves.easeInOut;

          //       var tween = Tween(begin: begin, end: end)
          //           .chain(CurveTween(curve: curve));

          //       var offsetAnimation = animation.drive(tween);

          //       return SlideTransition(
          //         position: offsetAnimation,
          //         child: child,
          //       );
          //     },
          //   ),
          // );

          Navigator.pushReplacementNamed(context, '/get-started');
        }
      },
      child: const Text(
        'Skip',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
