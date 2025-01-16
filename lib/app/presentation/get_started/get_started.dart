// GetStartedPage this page will navigate user to login page.

import 'package:flutter/material.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:video_player/video_player.dart';
// import 'package:lm_club/app/home/home.dart';
// import 'package:lm_club/app/presentation/quiz/quiz.dart';
// import 'package:share_plus/share_plus.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedtate();
}

class _GetStartedtate extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/pageOne.png"),
                  fit: BoxFit.cover),
            ),
            child: Container(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Flexible(
                          child: Text(
                            'The Membership\nClub Ever!',
                            style: TextStyle(
                              color: Color.fromRGBO(238, 238, 238, 1),
                              fontSize: 24.0,
                              fontFamily: 'NeueHaasGroteskTextPro',
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Image.asset(
                          "assets/images/logo1.png",
                          width: 113,
                          height: 73,
                          alignment: Alignment.center,
                        ),
                      ],
                    )),
                    Container(
                        padding: const EdgeInsets.all(50),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  QR.navigator.replaceAllWithName(
                                    Routes.SIGN_IN.name,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  backgroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                child: const Text(
                                  "GET STARTED",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontFamily: 'NeueHaasGroteskTextPro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const VideoPopup();
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(0, 176, 80, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                label: const Text(
                                  "SEE HOW IT WORKS",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontFamily: 'NeueHaasGroteskTextPro',
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.clip,
                                ),
                                icon: Image.asset(
                                  "assets/images/play-button.png",
                                  width: 25,
                                  height: 25,
                                  alignment: Alignment.center,
                                ),
                              )
                            ])),
                  ],
                ))));
  }
}

class VideoPopup extends StatefulWidget {
  const VideoPopup({super.key});

  @override
  _VideoPopupState createState() => _VideoPopupState();
}

class _VideoPopupState extends State<VideoPopup> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/images/lm_video.mp4', // Update with your video path
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8), // Adjust spacing as needed
          TextButton(
            onPressed: () {
              _controller.pause();
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
