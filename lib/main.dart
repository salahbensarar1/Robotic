import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rctc/arm_widget.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'Gyro.dart';
import 'RoboticMainPage.dart';
import 'animation.dart';
// import 'connect.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Color(0xFF8EC5FC),
          Color(0xFFE0C3FC),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 100,
              child: MyAnimatedWidget(
                duration: const Duration(seconds: 2),
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePageR())),
                  child: Image.asset('assets/robot.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GyroscopeWidget())),
                  child: const Text(
                    'Try to connect to a device',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  )).animate().fade(duration: 2.seconds),
            ),
          ],
        ),
      ),
    );
  }
}
