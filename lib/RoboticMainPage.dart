import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class HomePageR extends StatefulWidget {
  const HomePageR({super.key});

  @override
  State<HomePageR> createState() => _HomePageRState();
}

class _HomePageRState extends State<HomePageR> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldGradientBackground(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(width: 20.0, height: 50.0),
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 40.0,
                      fontFamily: 'Horizon',
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        RotateAnimatedText('be AWESOME'),
                        RotateAnimatedText('be OPTIMISTIC'),
                        RotateAnimatedText('be DIFFERENT'),
                      ],
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ),
                ],
              ),
            ),
            // AnimatedText(
            //   alignment: Alignment.center,
            //   speed: Duration(milliseconds: 1000),
            //   controller: AnimatedTextController.loop,
            //   displayTime: Duration(milliseconds: 1000),
            //   wordList: ['animations.', 'are.', 'easier.', 'now.'],
            //   textStyle: const TextStyle(
            //       color: Colors.black,
            //       fontSize: 55,
            //       fontWeight: FontWeight.w700),
            //   onAnimate: (index) {
            //     print("Animating index:" + index.toString());
            //   },
            //   onFinished: () {
            //     print("Animtion finished");
            //   },
            // ),
          ],
        ),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFF8EC5FC),
            Color(0xFFE0C3FC),
          ],
        ),
      ),
    );
  }
}
